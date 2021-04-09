--@name No MBC
--@client

local RAM = 1
local ROM = 2

function no_mbc_new_state(type, rom_bank_count, ram_size, rom)
    local ram = {}
    for i=1, ram_size do 
        ram[i] = 0 
    end
    
    return {
        [RAM] = ram,
        [ROM] = rom,
    }
end

function no_mbc_get_rom(mbc, addr)
    return mbc[ROM][addr+1]
end

function no_mbc_control(mbc, addr, value)
    -- No-op.
end

function no_mbc_get_ram(mbc, addr)
    return mbc[RAM][addr + 1 - 0xA000]
end

function no_mbc_set_ram(mbc, addr, value)
    mbc[RAM][addr + 1 - 0xA000] = value
end
