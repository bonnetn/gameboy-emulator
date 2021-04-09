--@name MMU
--@client

local bit_band, bit_bor, bit_bxor, bit_lshift, bit_rshift = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift
local assert = assert

require("gameboy/memory/mbc/mbc.txt")
local new_mbc_state, mbc_get_rom, mbc_control, mbc_ram, mbc_get_ram = new_mbc_state, mbc_get_rom, mbc_control, mbc_ram, mbc_get_ram

require("gameboy/const.txt")
local FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_DMA, ADDR_BG_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM = FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_DMA, ADDR_BG_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM

require("gameboy/io.txt")
local io_boot_rom_enabled, new_io_state, io_get, io_set = io_boot_rom_enabled, new_io_state, io_get, io_set

local ROM               = 1
local RAM               = 2
local MBC_STATE         = 3
local IO_STATE          = 4

local function memory_get(m, addr)
    return m[addr+1]
end

local function memory_set(m, addr, v)
    m[addr+1] = v
end

function mmu_set(memory, addr, v)
    assert(memory ~= nil, "memory is nil")
    assert(addr >= 0 and addr <= 0xFFFF, "out of bounds memory (set) access")
    assert(v >= 0 and v <= 0xFF,"value out of bound when trying to set memory")
    
    if     addr >= 0x0000 and addr <= 0x7FFF then
        -- ROM
        mbc_control(memory[MBC_STATE], addr, v) -- Can't write to ROM, instead it's used for MBC control registers.
    
    elseif addr >= 0x8000 and addr <= 0x9FFF then
        -- VRAM
        memory_set(memory[RAM], addr, v)
        
    elseif addr >= 0xA000 and addr <= 0xBFFF then
        -- External RAM.
        mbc_ram(memory[MBC_STATE], addr, v)
        
    elseif addr >= 0xC000 and addr <= 0xDFFF then
        -- Work RAM (WRAM) 
        memory_set(memory[RAM], addr, v)
    
    elseif addr >= 0xE000 and addr <= 0xFDFF then
        -- Echo RAM
        -- print("attempt to write to ECHO RAM (prohibited)")
        
    elseif addr >= 0xFE00 and addr <= 0xFE9F then
        -- Sprite attribute table (OAM)    
        memory_set(memory[RAM], addr, v)
    
    elseif addr >= 0xFEA0 and addr <= 0xFEFF then
        -- Not Usable    
        -- print("attempt to write to area [FEA0, FEFF] (prohibited)")
        
    elseif addr >= 0xFF00 and addr <= 0xFF7F then
        -- I/O Registers
        io_set(memory[IO_STATE], addr, v)
        
        if addr == ADDR_DMA then
            -- Writing to this register launches a DMA transfer from ROM or RAM to OAM memory (sprite attribute table). 
            -- The written value specifies the transfer source address divided by 100h, that is, source & destination are:
            -- Source:      XX00-XX9F   ;XX in range from 00-F1h
            -- Destination: FE00-FE9F
            local src_start = bit_lshift(v, 8)
            local src_end = bit_bor(src_start, 0x9F)
            
            for pos=src_start, src_end do
                mmu_set(memory, pos-src_start+0xFE00, mmu_get(memory, pos))
            end
        end
    
    elseif addr >= 0xFF80 and addr <= 0xFFFE then
        -- High RAM (HRAM)
        memory_set(memory[RAM], addr, v)
        
    elseif addr >= 0xFFFF and addr <= 0xFFFF then
        -- Interrupts Enable Register (IE)
        memory_set(memory[RAM], addr, v)
        
    else
        error(string.format("Unexpected memory set address: %04X", addr))
    end
end

function mmu_get(memory, addr)
    assert(memory ~= nil, "memory is nil")
    assert(addr >= 0 and addr <= 0xFFFF, "out of bounds memory (get) access")
    
    if     addr >= 0x0000 and addr <= 0x7FFF then
        -- ROM
        if io_boot_rom_enabled(memory[IO_STATE]) and addr >= 0x0000 and addr <= 0x00FF then
            -- Boot ROM: 
            return memory_get(BOOT_ROM, addr)
        end

        return mbc_get_rom(memory[MBC_STATE], addr)
    
    elseif addr >= 0x8000 and addr <= 0x9FFF then
        -- VRAM
        return memory_get(memory[RAM], addr)
        
    elseif addr >= 0xA000 and addr <= 0xBFFF then
        -- External RAM.
        return mbc_get_ram(memory[MBC_STATE], addr)
        
    elseif addr >= 0xC000 and addr <= 0xDFFF then
        -- Work RAM (WRAM) 
        return memory_get(memory[RAM], addr)
    
    elseif addr >= 0xE000 and addr <= 0xFDFF then
        -- Echo RAM
        error("attempt to read from ECHO RAM (prohibited)")
        
    elseif addr >= 0xFE00 and addr <= 0xFE9F then
        -- Sprite attribute table (OAM)    
        return memory_get(memory[RAM], addr)
    
    elseif addr >= 0xFEA0 and addr <= 0xFEFF then
        -- Not Usable    
        error("attempt to read from area [FEA0, FEFF] (prohibited)")
        
    elseif addr >= 0xFF00 and addr <= 0xFF7F then
        -- I/O Registers
        local result = io_get(memory[IO_STATE], addr)
        assert(result ~= nil)
        return result
        
    elseif addr >= 0xFF80 and addr <= 0xFFFE then
        -- High RAM (HRAM)
        return memory_get(memory[RAM], addr)
        
    elseif addr >= 0xFFFF and addr <= 0xFFFF then
        -- Interrupts Enable Register (IE)
        return memory_get(memory[RAM], addr)
        
    else
        error(string.format("Unexpected memory get address: %04X", addr))
    end
end

function init_memory(rom)
    assert(rom ~= nil, "rom is nil")
    
    local ram = {}
    for i = 1, 0x10000 do
        ram[i] = 0
    end
    
    local memory = {}

    memory[ROM]       = rom
    memory[RAM]       = ram
    memory[MBC_STATE] = new_mbc_state(rom)
    memory[IO_STATE]  = new_io_state()

    return memory
end


