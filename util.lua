--@name Util
--@client

local bit_band, bit_bor, bit_bxor, bit_lshift, bit_rshift = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift
local assert = assert

require("gameboy/memory/mmu.txt")
local mmu_set, mmu_get, init_memory = mmu_set, mmu_get, init_memory

function load_bytes(path)
    -- Loads SIZE bytes into an array. If the files contains less than SIZE bytes, it will pad with zeros.
    local f = file.open(path, "rb")
    assert(f ~= nil, "could not open file")
    
    local size = f:size()
    local content = f:read(size)
    f:close()
    
    local arr = {}
    for i = 1, size do
        arr[i] = string.byte(content:sub(i, i))
    end
    return arr
end


function inv16(x)
    return bit_band(bit_bxor(x, 0xFFFF) + 1, 0xFFFF)
end

function inv8(x)
    return bit_band(bit_bxor(x, 0xFF) + 1, 0xFF)
end

function add8to8(x, y, reg, half_carry, carry)
    local result = x + y

    local c = (result > 0xFF)
    local h = (bit_band(bit_band(x, 0x0F) + bit_band(y, 0x0F), 0xF0) ~= 0)
    if half_carry then
      if h then
        register_set_flag_h(reg)
      else
        register_unset_flag_h(reg)
      end
    end
    
    if carry then
      if c then
        register_set_flag_cy(reg)
      else
        register_unset_flag_cy(reg)
      end
    end
    
    return bit_band(result, 0xFF)
end

 
function add16to16(x, y, reg, half_carry, carry)
    local result = x + y
    
    local c = (result > 0xFFFF)
    local h = (bit_band(bit_band(x, 0x0FFF) + bit_band(y, 0x0FFF),  0xF000) ~= 0)
    if half_carry then
      if h then
        register_set_flag_h(reg)
      else
        register_unset_flag_h(reg)
      end
    end
    
    if carry then
      if c then
        register_set_flag_cy(reg)
      else
        register_unset_flag_cy(reg)
      end
    end
    return bit_band(result, 0xFFFF)
end

function add8to16(x, y, reg, half_carry, carry)
    -- x: 8 bits
    -- y: 16 bits
    assert(x >= 0 and x <= 0xFF)
    assert(y >= 0 and y <= 0xFFFF)
    
    local x16 = x
    local x16 = (bit_band(x, 0x80) > 0) and inv16(inv8(x16)) or x16
    local result = add16to16(x16, y, reg, false, false)
    
    -- Set the flag, apparently adding 8 bits to 16 bits behaves like a 8 bits + 8 bits...
    add8to8(x, bit_band(y,0xFF), reg, half_carry, carry)
    
    return result
end


function sub8to8(x, y, reg, half_carry, carry)
    local r1 = bit_band(x, 0x0F) - bit_band(y, 0x0F)
    local r1 = (r1 < 0) and inv16(-r1) or r1
    
    local r2 = x - y
    local r2 = (r2 < 0) and inv16(-r2) or r2
    
    
    local c = (r2 > 0xFF)
    local h = (r1 > 0xF)

    if half_carry then
      if h then
        register_set_flag_h(reg)
      else
        register_unset_flag_h(reg)
      end
    end
    
    if carry then
      if c then
        register_set_flag_cy(reg)
      else
        register_unset_flag_cy(reg)
      end
    end
    
    return bit_band(r2, 0xFF)
end

function sub16to16(x, y, reg, half_carry, carry)
    assert(half_carry == false, "not implemented for half_carry=true")
    assert(carry == false, "not implemented for carry=true")
    return add16to16(x, inv16(y), reg, half_carry, carry)    
end

function next16(memory, pos)
    local low = mmu_get(memory, pos)
    local high = mmu_get(memory, pos+1)
    return bit_bor(low, bit_lshift(high, 8))
end
