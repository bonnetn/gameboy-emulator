--@name Fetcher
--@client

local bit_band, bit_bor, bit_bxor, bit_lshift, bit_rshift = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift

require("gameboy/graphics/fifo.txt")
local new_fifo, fifo_push, fifo_pop, fifo_length, fifo_clear = new_fifo, fifo_push, fifo_pop, fifo_length, fifo_clear

require("gameboy/const.txt")
local FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_DMA, ADDR_BG_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM = FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_DMA, ADDR_BG_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM

require("gameboy/graphics/pixel_functions.txt")
local get_shade_from_tile, is_window_enabled, get_window_tile_map_addr, get_background_tile_map_addr, get_window_pos, get_background_window_tile_addr = get_shade_from_tile, is_window_enabled, get_window_tile_map_addr, get_background_tile_map_addr, get_window_pos, get_background_window_tile_addr

require("gameboy/memory/mmu.txt")
local mmu_set, mmu_get, init_memory = mmu_set, mmu_get, init_memory

-- Fetcher attributes:
local FIFO        = 1  -- Pixel queue
local MEMORY      = 2  -- Memory (for reading the tiles)
local MAP_ADDR    = 3  -- Address of the map containing all the tiles.
local TILE_I = 4       -- Tile that is being read.
local TILE_LINE   = 5  -- [0,7] line (Y) on the tile being read.
local STATE       = 6  -- State of the fetcher
local TILE_ID     = 7  -- Tile ID that will be put in the queue.
local TILE_LOW    = 8  -- Low byte of the current tile.
local TILE_HIGH   = 9  -- High byte of the current tile.
local IS_WINDOW   = 10 -- True if we should fetch from the window.


-- Fetcher current state:
local STATE_GET_TILE            = 1
local STATE_GET_TILE_DATA_LOW   = 2
local STATE_GET_TILE_DATA_HIGH  = 3
local STATE_SLEEP               = 4
local STATE_PUSH                = 5

function new_fetcher(memory, pixel_queue)
    return {
        [FIFO]        = pixel_queue,
        [MEMORY]      = memory,
        [MAP_ADDR]    = -1,
        [TILE_I]      = -1,
        [TILE_LINE]   = -1,
        [STATE]       = -1,
        [TILE_ID]     = -1,
        [TILE_LOW]    = -1,
        [TILE_HIGH]   = -1,
        [IS_WINDOW]   = false,
    }
end


function fetcher_reset(fetcher, map_addr, tile_line, is_window)
    fetcher[MAP_ADDR]    = map_addr
    fetcher[TILE_I]      = 0
    fetcher[TILE_LINE]   = tile_line
    fetcher[STATE]       = STATE_GET_TILE
    fetcher[IS_WINDOW]   = is_window
    fifo_clear(fetcher[FIFO])
end

function fetcher_tick(fetcher)
    local s = fetcher[STATE]
    if     s == STATE_GET_TILE then
        fetcher[TILE_ID] = mmu_get(fetcher[MEMORY], fetcher[MAP_ADDR] + fetcher[TILE_I])
        fetcher[STATE] = STATE_GET_TILE_DATA_LOW
        
    elseif s == STATE_GET_TILE_DATA_LOW then
        -- NOTE: Tile definition is 16 bytes. 8 * pairs of bytes, one for each line.
        local tile_addr = get_background_window_tile_addr(fetcher[MEMORY], fetcher[TILE_ID])
        
        local addr = tile_addr + fetcher[TILE_LINE] * 2
        fetcher[TILE_LOW] = mmu_get(fetcher[MEMORY], addr + 0)
        fetcher[STATE] = STATE_GET_TILE_DATA_HIGH
    
    elseif s == STATE_GET_TILE_DATA_HIGH then
        local tile_addr = get_background_window_tile_addr(fetcher[MEMORY], fetcher[TILE_ID])
        local addr = tile_addr + fetcher[TILE_LINE] * 2
        fetcher[TILE_HIGH] = mmu_get(fetcher[MEMORY], addr + 1)
        fetcher[STATE] = STATE_SLEEP
        
    elseif s == STATE_SLEEP then
        fetcher[STATE] = STATE_PUSH
        
    elseif s == STATE_PUSH then
        for i=0, 8-1 do
            local shade = get_shade_from_tile(fetcher[TILE_LOW], fetcher[TILE_HIGH], 7-i)
            fifo_push(fetcher[FIFO], shade, 0, 0) 
        end
        fetcher[TILE_I] = fetcher[TILE_I] + 1
        fetcher[STATE] = STATE_GET_TILE
        
        -- We must not wait one tick before executing GET_TILE.
        fetcher_tick(fetcher)
    else
        error(string.format("invalid fetcher state: %d", s))
    end

end