--@name Pixel functions
--@client

local bit_band, bit_bor, bit_bxor, bit_lshift, bit_rshift = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift

require("gameboy/memory/mmu.txt")
local mmu_set, mmu_get, init_memory = mmu_set, mmu_get, init_memory

require("gameboy/const.txt")
local FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_DMA, ADDR_BG_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM = FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_DMA, ADDR_BG_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM

local function lcdc(memory)  
    return mmu_get(memory, ADDR_LCDC)
end

function is_window_enabled(memory)
    return bit_band(lcdc(memory), 0x20) ~= 0
end

function get_window_tile_map_addr(memory)
    -- Returns the base address where the tile IDs for the WINDOW are stored.
    -- NOTE: This is NOT the tile DATA. This location in memory only contains tile ID!
    if bit_band(lcdc(memory), 0x40) ~= 0 then
        return 0x9C00
    else
        return 0x9800
    end
end

function get_background_tile_map_addr(memory)
    -- Returns the base address where the tile IDs for the BACKGROUND are stored.
    -- NOTE: This is NOT the tile DATA. This location in memory only contains tile ID!
    if bit_band(lcdc(memory), 0x08) ~= 0 then
        return 0x9C00
    else
        return 0x9800
    end
end

function get_window_pos(memory)
    return mmu_get(memory, ADDR_WINDOW_X) - 7, mmu_get(memory, ADDR_WINDOW_Y)
end

local function tile_adressing_mode(memory)
    -- True  => 8000 method
    -- False => 8800 method
    return bit_band(lcdc(memory), 0x10) ~= 0
end


function get_background_window_tile_addr(memory, tile_id)
    if tile_adressing_mode(memory) then
        -- The "8000 method" uses $8000 as its base pointer and uses an unsigned addressing, meaning that tiles 0-127 are in block 0, and tiles 128-255 are in block 1. 
        return 0x8000 + tile_id * 16
    
    else
        -- The "8800 method" uses $9000 as its base pointer and uses a signed addressing.
        if bit_band(tile_id, 0x80) == 0 then -- Positive number
            return 0x9000 + tile_id * 16
            
        else -- Negative number
                local x = bit_bxor(tile_id, 0xFF) + 1 -- complement 2
            return 0x9000 - x * 16
        end
    end
end

function get_sprite_tile_addr(tile_id)
    -- Sprites always use the "8000 method".
    return 0x8000 + tile_id * 16
end

function get_shade_from_tile(low, high, i)
    -- Gets the shade on the tile defined by (low, high) bytes on the i-th bit position.
    local mask = bit_lshift(1, i)
    local shade = (bit_band(low, mask) ~= 0) and 1 or 0
    local shade = (bit_band(high, mask) ~= 0) and bit_bor(shade, 2) or shade
    return shade
end
