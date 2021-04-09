--@name MBC1
--@client

local assert = assert
local bit_band, bit_bor, bit_bxor, bit_lshift, bit_rshift = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift

local RAM             = 1
local ROM             = 2
local ROM_BANK_NUMBER = 3
local RAM_BANK_NUMBER = 4
local RAM_ENABLE      = 5
local BANKING_MODE    = 6
local ROM_BANK_COUNT  = 7
local MBC_TYPE        = 8


function mbc1_new_state(type, rom_bank_count, ram_size, rom)
    local ram = {}
    for i=1, ram_size do 
        ram[i] = 0 
    end
    
    return {
        [RAM]             = ram,
        [ROM]             = rom,
        [ROM_BANK_NUMBER] = 1,
        [RAM_BANK_NUMBER] = 0,
        [RAM_ENABLE]      = false,
        [BANKING_MODE]    = false,
        [ROM_BANK_COUNT]  = rom_bank_count,
        [MBC_TYPE]        = type, 
    }
end

function mbc1_get_rom(mbc, addr)
    if     addr >= 0x0000 and addr <= 0x3FFF then
        -- BANK 0
        return mbc[ROM][addr + 1]

    elseif addr >= 0x4000 and addr <= 0x7FFF then
        -- BANK N
        local offset = 0x4000 * (mbc[ROM_BANK_NUMBER] - 1)
        return mbc[ROM][addr + offset + 1]
        
    else
        error("unexpected address")
    end
end

function mbc1_control(mbc, addr, value)
    if     addr >= 0x0000 and addr <= 0x1FFF then
        -- RAM Enable
        mbc[RAM_ENABLE] = (bit_band(value, 0x0F) == 0xA)
    
    elseif addr >= 0x2000 and addr <= 0x3FFF then
        -- ROM Bank Number
        local bank = bit_band(value, 0x1F)
        local bank = (bank == 0x00) and 0x01 or bank
        local bank = (bank == 0x20) and 0x21 or bank
        local bank = (bank == 0x40) and 0x41 or bank
        local bank = (bank == 0x60) and 0x61 or bank
        
        assert(bank < mbc[ROM_BANK_COUNT]) -- Selected bank is greater than the maximum number of banks.
        
        mbc[ROM_BANK_NUMBER] = bank
    
    elseif addr >= 0x4000 and addr <= 0x5FFF then
        -- RAM Bank Number - or - Upper Bits of ROM Bank Number
        local bank = bit_band(value, 0x03)
        mbc[RAM_BANK_NUMBER] = bank
    
    elseif addr >= 0x6000 and addr <= 0x7FFF then
        -- Banking Mode Select
        mbc[BANKING_MODE] = (bit_band(value, 0x01) == 1)
        assert(not mbc[BANKING_MODE], "advanced banking mode not supported")
        
    else
        error("unexpected MBC control address")
    end
end

function mbc1_get_ram(mbc, addr)
    local offset  = mbc[RAM_BANK_NUMBER] * 0x2000
    return mbc[RAM][addr + 1 - 0xA000 + offset]
end

function mbc1_set_ram(mbc, addr, value)
    local offset  = mbc[RAM_BANK_NUMBER] * 0x2000
    mbc[RAM][addr + 1 - 0xA000 + offset] = value
end
