--@name CPU
--@client

local bit_band, bit_bor, bit_bxor, bit_lshift, bit_rshift = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift
local systime = timer.systime

require("gameboy/const.txt")
local FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_DMA, ADDR_BG_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM = FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_DMA, ADDR_BG_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM

require("gameboy/memory/mmu.txt")
local mmu_set, mmu_get, init_memory = mmu_set, mmu_get, init_memory

require("gameboy/registers.txt")
local register_flag_zf, register_set_flag_zf, register_unset_flag_zf, register_flag_n, register_set_flag_n, register_unset_flag_n, register_flag_h, register_set_flag_h, register_unset_flag_h, register_flag_cy, register_set_flag_cy, register_unset_flag_cy, register_flag_ime, register_set_flag_ime, register_unset_flag_ime, register_flag_halt, register_set_flag_halt, register_unset_flag_halt, init_registers = register_flag_zf, register_set_flag_zf, register_unset_flag_zf, register_flag_n, register_set_flag_n, register_unset_flag_n, register_flag_h, register_set_flag_h, register_unset_flag_h, register_flag_cy, register_set_flag_cy, register_unset_flag_cy, register_flag_ime, register_set_flag_ime, register_unset_flag_ime, register_flag_halt, register_set_flag_halt, register_unset_flag_halt, init_registers

require("gameboy/util.txt")
local load_bytes, inv16, inv8, add8to8, add16to16, add8to16, sub8to8, sub16to16, next16 = load_bytes, inv16, inv8, add8to8, add16to16, add8to16, sub8to8, sub16to16, next16

local FREQUENCY = FREQUENCY
local TIMER_PERIOD = 16384 / FREQUENCY

local ADDR_IF   = ADDR_IF
local ADDR_IE   = ADDR_IE
local ADDR_TAC  = ADDR_TAC 
local ADDR_TIMA = ADDR_TIMA
local ADDR_TMA  = ADDR_TMA
local ADDR_DIV  = ADDR_DIV

local TIMER_MODE_TO_FREQ = {4096, 262144, 65536, 16384}

local REGISTERS  = 1
local MEMORY     = 2
local TIMER_DIV  = 3
local TIMER_CNT  = 4
local READER_POS = 5
local DMG_BUG    = 6

local OPCODES         = 7
local OPCODES_NAMES   = 8
local OPCODES16       = 9
local OPCODES16_NAMES = 10


local function next16(memory, pos)
    local low = mmu_get(memory, pos)
    local high = mmu_get(memory, pos+1)
    return bit_bor(low, bit_lshift(high, 8))
end

local function next8(memory, pos)
    return mmu_get(memory, pos)
end


function new_cpu(registers, memory)
    local opcodes, opcodes_names, opcodes16, opcodes16_names = register_opcodes(memory, registers)    
    
    return {
        [REGISTERS]       = registers,
        [MEMORY]          = memory,
        [TIMER_DIV]       = 0,
        [TIMER_CNT]       = 0,
        [READER_POS]      = 0,
        [DMG_BUG]         = false,
        [OPCODES]         = opcodes,
        [OPCODES_NAMES]   = opcodes_names,
        [OPCODES16]       = opcodes16,
        [OPCODES16_NAMES] = opcodes16_names,
    }
end

local function timer_increment_tima(memory)
    -- Return the incremented TIMA register. Wraps if needed.
    -- If TIMA wraps, an interrupt will also be triggered.
    local tima = mmu_get(memory, ADDR_TIMA) + 1
    
    if tima > 0xFF then
        -- Timer interrupt.
        local if_reg = mmu_get(memory, ADDR_IF)
        mmu_set(memory, ADDR_IF, bit_bor(if_reg, 4))
        
        return mmu_get(memory, ADDR_TMA) -- TIMA is set to TMA (not a typo)
    end
    
    return tima
end

local function update_timer(cpu, cycles)
    -- Update the timer registers and trigger interrupt if needed.
    local memory = cpu[MEMORY]
    
    cpu[TIMER_DIV] = cpu[TIMER_DIV] + cycles
    
    if cycles >= TIMER_PERIOD then
        cpu[TIMER_DIV] = cpu[TIMER_DIV] - TIMER_PERIOD
        local div = mmu_get(memory, ADDR_DIV)
        local div = bit_band(div + 1, 0xFF)
        mmu_set(memory, ADDR_DIV, div)
    end
    
    local tac = mmu_get(memory, ADDR_TAC)
    if bit_band(tac, 4) ~= 0 then -- Timer enabled.
        local mode = bit_band(tac, 3)
        local f = TIMER_MODE_TO_FREQ[mode + 1]
        local period = FREQUENCY / f

        cpu[TIMER_CNT] = cpu[TIMER_CNT] + cycles
        if cpu[TIMER_CNT] >= period then
            cpu[TIMER_CNT] = cpu[TIMER_CNT] - period 
            mmu_set(memory, ADDR_TIMA, timer_increment_tima(memory))
        end
    end
end

local function interrupt_get_pc(registers)
    -- Gets the PC of the next instruction to put on the stack when an interrupt triggers.
    local pc = register_pc(registers)
    if register_flag_halt(registers) then
        -- Resume on next instruction after halt.
        register_unset_flag_halt(registers)
        return pc + 1
    end
    return pc
end

local function interrupt_address(memory, interrupt_flag)
    -- Returns the interrupt address where to jump from the interrupt flag.
    -- Also returns the new value of the interrupt flag with the interrupt disab
    if bit_band(interrupt_flag, 1) ~= 0     then
        --print("VLBANK")
        return 0x40, bit_bxor(interrupt_flag, 1)
        
    elseif bit_band(interrupt_flag, 2) ~= 0 then
        -- print("LCD STAT")
        return 0x48, bit_bxor(interrupt_flag, 2)
        
    elseif bit_band(interrupt_flag, 4) ~= 0 then
        -- print("Timer")
        return 0x50, bit_bxor(interrupt_flag, 4)
        
    elseif bit_band(interrupt_flag, 8) ~= 0 then
        -- print("Serial")
        return 0x58, bit_bxor(interrupt_flag, 8)
        
    elseif bit_band(interrupt_flag, 16) ~= 0 then
        -- print("Joypad")
        return 0x60, bit_bxor(interrupt_flag, 16)
        
    else
        error("Unexpected interrupt")
    end
end

local function process_interrupts(cpu, interrupt_flag)
    local registers = cpu[REGISTERS]
    local memory = cpu[MEMORY]
    
    register_unset_flag_ime(registers)
    
    local pc = interrupt_get_pc(registers)
    local sp = register_sp(registers)
    
    local stack1 = sp - 1
    mmu_set(memory, stack1, bit_rshift(pc, 8))
    
    local stack2 = stack1 - 1
    mmu_set(memory, stack2, bit_band(pc, 255))
    
    register_set_sp(registers, stack2)

    local addr, interrupt_flag = interrupt_address(memory, interrupt_flag)
    
    mmu_set(memory, ADDR_IF, interrupt_flag) 
    register_set_pc(registers, addr)
    
    return 5
end

local function handle_interrupts(cpu)
    local registers = cpu[REGISTERS]
    local memory = cpu[MEMORY]
    
    local interrupt_flags = bit_band(mmu_get(memory, ADDR_IF), mmu_get(memory, ADDR_IE))
    if interrupt_flags ~= 0 then
        if register_flag_ime(registers) then
            local c = process_interrupts(cpu, interrupt_flags)
            update_timer(cpu, c)
            return c
            
        -- IME=0 and Interrupt, un-halt and reproduce DMG bug.
        elseif register_flag_halt(registers) then
            cpu[DMG_BUG] = true
            register_unset_flag_halt(registers)
            register_set_pc(registers, register_pc(registers) + 1)
        end
    end
end

local function get_offset_bug(cpu)
    -- DMG bug, reader may be offset by one byte if resuming from HALT.
    if cpu[DMG_BUG] then
        cpu[DMG_BUG] = false
        return -1
    end
    return 0
end

local function parse_opcode(cpu)
    local registers = cpu[REGISTERS]
    local memory = cpu[MEMORY]
    
    local reader_pos = register_pc(registers)
    local code = mmu_get(memory, reader_pos)
    
    local offset = get_offset_bug(cpu)
    
    if code ~= 0xCB then
        local func = cpu[OPCODES][code+1]
        return func(reader_pos + 1 + offset)

    else
        local code = mmu_get(memory, reader_pos + 1)
        local func = cpu[OPCODES16][code+1] 
        return func(reader_pos + 2 + offset)
    end
end
local function get_instruction_name(cpu, memory, registers)
    local code = mmu_get(memory, register_pc(registers))
    if code == 0xCB then
        local code = mmu_get(memory, register_pc(registers) + 1)
        return cpu[OPCODES16_NAMES][code+1]
    else
        return cpu[OPCODES_NAMES][code+1]
    end
end

local function get_next_instruction_name(cpu)
    local registers = cpu[REGISTERS]
    local memory = cpu[MEMORY]
    local name = get_instruction_name(cpu, memory, registers)
    
    local r8 = mmu_get(memory, register_pc(registers)+1)
    local r8 = string.format("%02X", r8)
    local r16 = next16(memory, register_pc(registers)+1)
    local r16 = string.format("%04X", r16)
    
    local name = string.replace(name, "a8", r8)
    local name = string.replace(name, "d8", r8)
    local name = string.replace(name, "r8", r8)
    
    local name = string.replace(name, "a16", r16)
    return name
end


local last_log = 0
local write_to_file = false
-- local f = file.open("log.txt", "w")
local function log_current_state(cpu)
    local registers = cpu[REGISTERS]
    
    if systime() - last_log > 1 or register_pc(registers) == 0xc302 then
        last_log = systime()
        -- print("log", string.format("%-15s | %s\n", get_next_instruction_name(cpu), registers:tostring()))
    end
    
    if register_pc(registers) >= 0x0100 then
        write_to_file = true
    end
    if write_to_file then                
        -- f:write(string.format("%-15s | %s\n", get_next_instruction_name(cpu), registers:tostring()))
    end
end

function cpu_tick(cpu)
    local c = handle_interrupts(cpu)
    if c ~= nil then 
        return c
    end
    
    log_current_state(cpu) 
    
    local c = parse_opcode(cpu)
    update_timer(cpu, c)
    return c        
end