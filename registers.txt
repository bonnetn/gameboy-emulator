--@name Registers
--@client

local assert = assert
local bit_band, bit_bor, bit_bxor, bit_lshift, bit_rshift = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift

-- Registers

local BIT_7 = bit_lshift(1, 7)
local NOT_BIT_7 = bit_bxor(0xFF, BIT_7)
local BIT_6 = bit_lshift(1, 6)
local NOT_BIT_6 = bit_bxor(0xFF, BIT_6)
local BIT_5 = bit_lshift(1, 5)
local NOT_BIT_5 = bit_bxor(0xFF, BIT_5)
local BIT_4 = bit_lshift(1, 4)
local NOT_BIT_4 = bit_bxor(0xFF, BIT_4)

local function add_16bits_registers_functions(name, id)
    local name = string.lower(name)
    
    _G["register_" .. name] = function(registers)
        return registers[id]
    end
    
    _G["register_set_" .. name] = function(registers, v)
        assert(v >= 0 and v <= 0xFFFF, "16 bits register value out of bounds")
        registers[id] = v
    end
end

local function add_split_registers_functions(name, id_low, id_high)
    local name = string.lower(name)
    
    _G["register_" .. name] = function(registers)
        return bit_bor(
            registers[id_low], 
            bit_lshift(registers[id_high], 8)
        )
    end
    
    _G["register_set_" .. name] = function(registers, v)
        assert(v ~= nil)
        assert(v >= 0 and v <= 0xFFFF, "16 bits register value out of bounds")
        registers[id_low] = bit_band(v, 0xFF)
        registers[id_high] = bit_rshift(v, 8)
    end
    
    local high = name[1]
    local low = name[2]
    
    _G["register_" .. high] = function(registers)
        return registers[id_high]
    end
    
    _G["register_" .. low] = function(registers)
        return registers[id_low]
    end
    
    _G["register_set_" .. high] = function(registers, v)
        assert(v ~= nil)
        assert(v >= 0 and v <= 0xFF, "8 bits register value out of bounds")
        registers[id_high] = v
    end
    
    _G["register_set_" .. low] = function(registers, v)
        assert(v ~= nil)
        assert(v >= 0 and v <= 0xFF, "8 bits register value out of bounds")
        registers[id_low] = v
    end
end

add_split_registers_functions("AF", 1, 2)
add_split_registers_functions("BC", 3, 4)
add_split_registers_functions("DE", 5, 6)
add_split_registers_functions("HL", 7, 8)
add_16bits_registers_functions("SP", 9)
add_16bits_registers_functions("PC", 10)

local register_f = register_f
local register_set_f = register_set_f

function register_flag_zf(registers) 
    return bit_band(register_f(registers), BIT_7) ~= 0
end
function register_set_flag_zf(registers)
    register_set_f(registers, bit_bor(register_f(registers), BIT_7))
end
function register_unset_flag_zf(registers)
    register_set_f(registers, bit_band(register_f(registers), NOT_BIT_7))
end

function register_flag_n(registers) 
    return bit_band(register_f(registers), BIT_6) ~= 0 
end
function register_set_flag_n(registers)
    register_set_f(registers, bit_bor(register_f(registers), BIT_6))
end
function register_unset_flag_n(registers)
    register_set_f(registers, bit_band(register_f(registers), NOT_BIT_6))
end

function register_flag_h(registers) 
    return bit_band(register_f(registers), BIT_5) ~= 0
end
function register_set_flag_h(registers)
    register_set_f(registers, bit_bor(register_f(registers), BIT_5))
end
function register_unset_flag_h(registers)
    register_set_f(registers, bit_band(register_f(registers), NOT_BIT_5))
end

function register_flag_cy(registers) 
    return bit_band(register_f(registers), BIT_4) ~= 0
end
function register_set_flag_cy(registers)
    register_set_f(registers, bit_bor(register_f(registers), BIT_4))
end
function register_unset_flag_cy(registers)
    register_set_f(registers, bit_band(register_f(registers), NOT_BIT_4))
end

function register_flag_ime(registers) 
    return registers._ime
end
function register_set_flag_ime(registers)
    registers._ime = true
end
function register_unset_flag_ime(registers)
    registers._ime = false
end

function register_flag_halt(registers) 
    return registers._halt
end
function register_set_flag_halt(registers)
    registers._halt = true
end
function register_unset_flag_halt(registers)
    registers._halt = false
end

function init_registers()
    local Registers = {}
    
    Registers._ime = false
    Registers._halt = false

    for i=1, 10 do
        Registers[i] = 0
    end

    function Registers:tostring()
        return string.format("AF: %04X BC:%04X DE:%04X HL:%04X SP:%04X PC:%04X", register_af(self), register_bc(self), register_de(self), register_hl(self), register_sp(self), register_pc(self))
    end

    return Registers
end


local function test_registers()
    local r = init_registers()
    assert(r ~= nil)

    local function assert_registers(regs)
        for k,v in pairs(regs) do
            local got =_G["register_" .. k](r)
            assert(got == v, "register " .. string.upper(k) .. " got=" .. got .. ", want=" .. v) 
        end
    end
    local function assert_flags(flags)
        for k,v in pairs(flags) do
            local got = _G["register_flag_" .. k](r)
            assert(got == v, "flag " .. string.upper(k) .. " got=" .. tostring(got) .. ", want=" .. tostring(v)) 
        end
    end
    
    -- Initial state, all 0.
    local want = {
        af = 0,
        a  = 0,
        f  = 0,
        bc = 0,
        b  = 0,
        c  = 0,
        de = 0,
        d  = 0,
        e  = 0,
        hl = 0,
        h  = 0,
        l  = 0,
        sp = 0,  
        pc = 0,
    }
    assert_registers(want)

    -- 16 bits registers:
    register_set_af(r, 0x0102)
    want.af = 0x0102
    want.a = 0x01
    want.f = 0x02
    assert_registers(want)
    
    register_set_bc(r, 0x0304)
    want.bc = 0x0304
    want.b = 0x03
    want.c = 0x04
    assert_registers(want)
    
    register_set_de(r, 0x0506)
    want.de = 0x0506
    want.d = 0x05
    want.e = 0x06
    assert_registers(want)
    
    register_set_hl(r, 0x0708)
    want.hl = 0x0708
    want.h = 0x07
    want.l = 0x08
    assert_registers(want)
    
    register_set_sp(r, 0x090A)
    want.sp = 0x090A
    assert_registers(want)
    
    register_set_pc(r, 0x0B0C)
    want.pc = 0x0B0C
    assert_registers(want)

    -- 8 bits registers:
    register_set_a(r, 0xF1)
    want.af = 0xF102
    want.a = 0xF1
    assert_registers(want)
    
    register_set_f(r, 0xF2)
    want.af = 0xF1F2
    want.f = 0xF2
    assert_registers(want)
    
    register_set_b(r, 0xF3)
    want.bc = 0xF304
    want.b = 0xF3
    assert_registers(want)
    
    register_set_c(r, 0xF4)
    want.bc = 0xF3F4
    want.c = 0xF4
    assert_registers(want)
    
    register_set_d(r, 0xF5)
    want.de = 0xF506
    want.d = 0xF5
    assert_registers(want)
    
    register_set_e(r, 0xF6)
    want.de = 0xF5F6
    want.e = 0xF6
    assert_registers(want)
    
    register_set_h(r, 0xF7)
    want.hl = 0xF708
    want.h = 0xF7
    assert_registers(want)
    
    register_set_l(r, 0xF8)
    want.hl = 0xF7F8
    want.l = 0xF8
    assert_registers(want)
    
    -- Flags
    local want_flags = {
        zf  = false,
        n   = false,
        h   = false,
        cy  = false,
        ime = false,
    }    
    register_set_f(r, 0x00)
    assert_flags(want_flags)
    
    register_set_flag_zf(r)
    want_flags.zf = true
    assert_flags(want_flags)
    
    register_unset_flag_zf(r)
    want_flags.zf = false
    assert_flags(want_flags)
    
    
    register_set_flag_n(r)
    want_flags.n = true
    assert_flags(want_flags)
    
    register_unset_flag_n(r)
    want_flags.n = false
    assert_flags(want_flags)
    
    
    register_set_flag_h(r)
    want_flags.h = true
    assert_flags(want_flags)
    
    register_unset_flag_h(r)
    want_flags.h = false
    assert_flags(want_flags)
    
    register_set_flag_cy(r)
    want_flags.cy = true
    assert_flags(want_flags)
    
    register_unset_flag_cy(r)
    want_flags.cy = false
    assert_flags(want_flags)     
    
    register_set_flag_ime(r)
    want_flags.ime = true
    assert_flags(want_flags)
    
    register_unset_flag_ime(r)
    want_flags.ime = false
    assert_flags(want_flags)    
end

test_registers()

