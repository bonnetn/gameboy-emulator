--@name MBC
--@client

local bit_band, bit_bor, bit_bxor, bit_lshift, bit_rshift = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift

require("gameboy/memory/mbc/no_mbc.txt")
local no_mbc_new_state, no_mbc_get_rom, no_mbc_control, no_mbc_get_ram, no_mbc_set_ram = no_mbc_new_state, no_mbc_get_rom, no_mbc_control, no_mbc_get_ram, no_mbc_set_ram

require("gameboy/memory/mbc/mbc1.txt")
local mbc1_new_state, mbc1_get_rom, mbc1_control, mbc1_get_ram, mbc1_set_ram = mbc1_new_state, mbc1_get_rom, mbc1_control, mbc1_get_ram, mbc1_set_ram

require("gameboy/memory/mbc/mbc3.txt")
local mbc3_new_state, mbc3_get_rom, mbc3_control, mbc3_get_ram, mbc3_set_ram = mbc3_new_state, mbc3_get_rom, mbc3_control, mbc3_get_ram, mbc3_set_ram

require("gameboy/const.txt")
local FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_ROM_SIZE, ADDR_RAM_SIZE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_LYC, ADDR_DMA, ADDR_BG_PALETTE, ADDR_SPRITE_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM = FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_ROM_SIZE, ADDR_RAM_SIZE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_LYC, ADDR_DMA, ADDR_BG_PALETTE, ADDR_SPRITE_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM

local MBC_TYPE_ROM                            = 0x00
local MBC_TYPE_MBC1                           = 0x01
local MBC_TYPE_MBC1_RAM                       = 0x02
local MBC_TYPE_MBC1_RAM_BATTERY               = 0x03
local MBC_TYPE_MBC2                           = 0x05
local MBC_TYPE_MBC2_BATTERY                   = 0x06
local MBC_TYPE_ROM_RAM                        = 0x08
local MBC_TYPE_ROM_RAM_BATTERY                = 0x09
local MBC_TYPE_MMM01                          = 0x0B
local MBC_TYPE_MMM01_RAM                      = 0x0C
local MBC_TYPE_MMM01_RAM_BATTERY              = 0x0D
local MBC_TYPE_MBC3_TIMER_BATTERY             = 0x0F
local MBC_TYPE_MBC3_TIMER_RAM_BATTERY         = 0x10
local MBC_TYPE_MBC3                           = 0x11
local MBC_TYPE_MBC3_RAM                       = 0x12
local MBC_TYPE_MBC3_RAM_BATTERY               = 0x13
local MBC_TYPE_MBC5                           = 0x19
local MBC_TYPE_MBC5_RAM                       = 0x1A
local MBC_TYPE_MBC5_RAM_BATTERY               = 0x1B
local MBC_TYPE_MBC5_RUMBLE                    = 0x1C
local MBC_TYPE_MBC5_RUMBLE_RAM                = 0x1D
local MBC_TYPE_MBC5_RUMBLE_RAM_BATTERY        = 0x1E
local MBC_TYPE_MBC6                           = 0x20
local MBC_TYPE_MBC7_SENSOR_RUMBLE_RAM_BATTERY = 0x22
local MBC_TYPE_POCKET_CAMERA                  = 0xFC
local MBC_TYPE_BANDAI_TAMA5                   = 0xFD
local MBC_TYPE_HuC3                           = 0xFE
local MBC_TYPE_HuC1_RAM_BATTERY               = 0xFF

local NEW_STATE = {
    [1+MBC_TYPE_ROM]                            = no_mbc_new_state,
    [1+MBC_TYPE_MBC1]                           = mbc1_new_state,
    [1+MBC_TYPE_MBC1_RAM]                       = mbc1_new_state,
    [1+MBC_TYPE_MBC1_RAM_BATTERY]               = mbc1_new_state,
    [1+MBC_TYPE_MBC3]                           = mbc3_new_state,
    [1+MBC_TYPE_MBC3_RAM]                       = mbc3_new_state,
    [1+MBC_TYPE_MBC3_RAM_BATTERY]               = mbc3_new_state,
}

local ROM_MEMORY_GETTER = {
    [1+MBC_TYPE_ROM]                            = no_mbc_get_rom,
    [1+MBC_TYPE_MBC1]                           = mbc1_get_rom,
    [1+MBC_TYPE_MBC1_RAM]                       = mbc1_get_rom,
    [1+MBC_TYPE_MBC1_RAM_BATTERY]               = mbc1_get_rom,
    [1+MBC_TYPE_MBC3]                           = mbc3_get_rom,
    [1+MBC_TYPE_MBC3_RAM]                       = mbc3_get_rom,
    [1+MBC_TYPE_MBC3_RAM_BATTERY]               = mbc3_get_rom,
}

local MBC_MEMORY_CONTROL = {
    [1+MBC_TYPE_ROM]                            = no_mbc_control,
    [1+MBC_TYPE_MBC1]                           = mbc1_control,
    [1+MBC_TYPE_MBC1_RAM]                       = mbc1_control,
    [1+MBC_TYPE_MBC1_RAM_BATTERY]               = mbc1_control,
    [1+MBC_TYPE_MBC3]                           = mbc3_control,
    [1+MBC_TYPE_MBC3_RAM]                       = mbc3_control,
    [1+MBC_TYPE_MBC3_RAM_BATTERY]               = mbc3_control,
}

local RAM_MEMORY_GETTER = {
    [1+MBC_TYPE_ROM]                            = no_mbc_get_ram,
    [1+MBC_TYPE_MBC1]                           = mbc1_get_ram,
    [1+MBC_TYPE_MBC1_RAM]                       = mbc1_get_ram,
    [1+MBC_TYPE_MBC1_RAM_BATTERY]               = mbc1_get_ram,
    [1+MBC_TYPE_MBC3]                           = mbc3_get_ram,
    [1+MBC_TYPE_MBC3_RAM]                       = mbc3_get_ram,
    [1+MBC_TYPE_MBC3_RAM_BATTERY]               = mbc3_get_ram,
}

local RAM_MEMORY_SETTER = {
    [1+MBC_TYPE_ROM]                            = no_mbc_set_ram,
    [1+MBC_TYPE_MBC1]                           = mbc1_set_ram,
    [1+MBC_TYPE_MBC1_RAM]                       = mbc1_set_ram,
    [1+MBC_TYPE_MBC1_RAM_BATTERY]               = mbc1_set_ram,
    [1+MBC_TYPE_MBC3]                           = mbc3_set_ram,
    [1+MBC_TYPE_MBC3_RAM]                       = mbc3_set_ram,
    [1+MBC_TYPE_MBC3_RAM_BATTERY]               = mbc3_set_ram,
}

local ROM_BANK_COUNT = {
    [1+0x00] = 2,
    [1+0x01] = 4,
    [1+0x02] = 8,
    [1+0x03] = 16,
    [1+0x04] = 32,
    [1+0x05] = 64,
    [1+0x06] = 128,
    [1+0x07] = 256,
    [1+0x08] = 512,
    [1+0x52] = 72,
    [1+0x53] = 80,
    [1+0x54] = 96,
}

local RAM_SIZE = {
    [1+0x00] = 0 * 0x400,
    [1+0x01] = 2 * 0x400,
    [1+0x02] = 8 * 0x400,
    [1+0x03] = 32 * 0x400,
    [1+0x04] = 128 * 0x400,
    [1+0x05] = 64 * 0x400,
}

local MBC_TYPE        = 1
local STATE           = 2

function new_mbc_state(rom)
    local type = rom[ADDR_CARTRIDGE_TYPE+1]
    local rom_bank_count = ROM_BANK_COUNT[rom[ADDR_ROM_SIZE+1]+1]
    local ram_size = RAM_SIZE[rom[ADDR_RAM_SIZE+1]+1]
    
    print(string.format("MBC type: 0x%02X", type))
    print(string.format("ROM bank count: %d", rom_bank_count))
    print(string.format("RAM size: %d KibiBytes", ram_size / 0x400))
    
    return {
        [MBC_TYPE] = type,
        [STATE]    = NEW_STATE[type + 1](type, rom_bank_count, ram_size, rom),
    }
end

function mbc_get_rom(mbc, addr)
    return ROM_MEMORY_GETTER[mbc[MBC_TYPE] + 1](mbc[STATE], addr)
end


function mbc_control(mbc, addr, value)
    return MBC_MEMORY_CONTROL[mbc[MBC_TYPE] + 1](mbc[STATE], addr, value)
end

function mbc_get_ram(mbc, addr)
    return RAM_MEMORY_GETTER[mbc[MBC_TYPE] + 1](mbc[STATE], addr)
end


function mbc_ram(mbc, addr, value)
    return RAM_MEMORY_SETTER[mbc[MBC_TYPE] + 1](mbc[STATE], addr, value)
end
