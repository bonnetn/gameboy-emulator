--@name MBC3
--@client

local assert = assert
local bit_band, bit_bor, bit_bxor, bit_lshift, bit_rshift = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift

local RAM             = 1
local ROM             = 2
local ROM_BANK_NUMBER = 3
local RAM_BANK_NUMBER = 4
local RAM_ENABLE      = 5
local TIME            = 6
local ROM_BANK_COUNT  = 7
local MBC_TYPE        = 8
local RTC_REGISTER    = 9


function mbc3_new_state(type, rom_bank_count, ram_size, rom)
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
        [ROM_BANK_COUNT]  = rom_bank_count,
        [MBC_TYPE]        = type, 
        [RTC_REGISTER]    = 0,
        [TIME]            = os.time(),
    }
end

function mbc3_get_rom(mbc, addr)    
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

function mbc3_control(mbc, addr, value)
    if     addr >= 0x0000 and addr <= 0x1FFF then
        -- RAM Enable
        mbc[RAM_ENABLE] = (bit_band(value, 0x0F) == 0xA)
    
    elseif addr >= 0x2000 and addr <= 0x3FFF then
        -- ROM Bank Number
        local bank = bit_band(value, 0x7F)
        
        assert(bank < mbc[ROM_BANK_COUNT]) -- Selected bank is greater than the maximum number of banks.
        
        mbc[ROM_BANK_NUMBER] = bank
    
    elseif addr >= 0x4000 and addr <= 0x5FFF then
        -- RAM Bank Number - or - Upper Bits of ROM Bank Number
        if value >= 0 and value <= 3 then        
            local bank = bit_band(value, 0x03)
            mbc[RAM_BANK_NUMBER] = bank
            mbc[RTC_REGISTER] = 0
        elseif value >= 0x8 and value <= 0xC then
            -- RTC.
            mbc[RTC_REGISTER] = value
        else
            error("Unexpected value")
        end
    
    elseif addr >= 0x6000 and addr <= 0x7FFF then
        -- Latch clock data.
        if value == 0x01 then
            mbc[TIME] = os.time()
        end
        
    else
        error("unexpected MBC control address")
    end
end

function mbc3_get_ram(mbc, addr)
    if mbc[RTC_REGISTER] == 0 then
        local offset  = mbc[RAM_BANK_NUMBER] * 0x2000
        return mbc[RAM][addr + 1 - 0xA000 + offset]
        
    else
        print(mbc[TIME])
        -- RTC mode.
        if     mbc[RTC_REGISTER] == 0x08 then
            return mbc[TIME].sec
            
        elseif mbc[RTC_REGISTER] == 0x09 then
            return mbc[TIME].min
            
        elseif mbc[RTC_REGISTER] == 0x0A then
            return mbc[TIME].hour
            
        elseif mbc[RTC_REGISTER] == 0x0B then
            return 0 -- TODO: Implement day counter.
            
        elseif mbc[RTC_REGISTER] == 0x0C then
            return 0 -- TODO: implements flags.
            
        else
            error("unsupported RTC value")
        end
    end
end

function mbc3_set_ram(mbc, addr, value)
    if mbc[RTC_REGISTER] == 0 then
        local offset  = mbc[RAM_BANK_NUMBER] * 0x2000
        mbc[RAM][addr + 1 - 0xA000 + offset] = value
    else
        -- No-op.
    end
end
