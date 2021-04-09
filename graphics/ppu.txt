--@name PPU
--@client

local bit_band, bit_bor, bit_bxor, bit_lshift, bit_rshift = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift
local floor = math.floor


require("gameboy/graphics/fetcher.txt")
local new_fetcher, fetcher_reset, fetcher_tick = new_fetcher, fetcher_reset, fetcher_tick

require("gameboy/graphics/fifo.txt")
local new_fifo, fifo_push, fifo_pop, fifo_length, fifo_clear = new_fifo, fifo_push, fifo_pop, fifo_length, fifo_clear

require("gameboy/graphics/screen_queue.txt")
local push_pixel_to_draw, pixels_to_draw = push_pixel_to_draw, pixels_to_draw

require("gameboy/graphics/pixel_functions.txt")
local get_shade_from_tile, get_sprite_tile_addr, get_background_tile_map_addr, get_window_tile_map_addr, get_window_pos, is_window_enabled, get_background_window_tile_addr = get_shade_from_tile, get_sprite_tile_addr, get_background_tile_map_addr, get_window_tile_map_addr, get_window_pos, is_window_enabled, get_background_window_tile_addr

require("gameboy/const.txt")
local ADDR_SPRITE_PALETTE, ADDR_LYC, FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_DMA, ADDR_BG_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM = ADDR_SPRITE_PALETTE, ADDR_LYC, FREQUENCY, ADDR_CARTRIDGE_TYPE, ADDR_JOYPAD, ADDR_LCDC, ADDR_STAT, ADDR_SCY, ADDR_SCX, ADDR_LY, ADDR_DMA, ADDR_BG_PALETTE, ADDR_WINDOW_Y, ADDR_WINDOW_X, ADDR_BOOT_ROM_DISABLE, ADDR_SB, ADDR_SC, ADDR_IF, ADDR_IE, ADDR_TAC, ADDR_TIMA, ADDR_TMA, ADDR_DIV, ADDR_ROM_SIZE, ADDR_RAM_SIZE, BOOT_ROM

require("gameboy/memory/mmu.txt")
local mmu_set, mmu_get, init_memory = mmu_set, mmu_get, init_memory

local MEMORY            = 1  -- Memory (for reading the pixels)
local REGISTERS         = 2  -- Registers
local MODE              = 3  -- Mode of the PPU (also reflected in the memory)
local PIXEL             = 4  -- Pixels popped in the OAM_READ mode.
local TICKS             = 5  -- Ticks spent for this scanline [0, 456[
local FETCHER           = 6  -- Pixel fetcher.
local BGRND_QUEUE       = 7  -- Pixel queue.
local WINDOW_LINE_COUNT = 8  -- How many lines of the window have already been drawn to the screen.
local SPRITES           = 9  -- Sprites IDs of the sprites on the line.
local SPRITE_QUEUE      = 10 -- Sprite queue.
local PX_TO_DISCARD     = 11 -- Pixels to discard

local MODE_HBLANK   = 0
local MODE_VBLANK   = 1
local MODE_OAM_SCAN = 2
local MODE_OAM_READ = 3

function new_ppu(registers, memory)
    local bg_queue = new_fifo()
    local sprite_queue = new_fifo()
    
    return {
        [MEMORY]            = memory,
        [REGISTERS]         = registers,
        [MODE]              = MODE_OAM_SCAN,
        [PIXEL]             = 0,
        [TICKS]             = 0,
        [FETCHER]           = new_fetcher(memory, bg_queue),
        [BGRND_QUEUE]       = bg_queue,
        [WINDOW_LINE_COUNT] = 0,
        [WINDOW_LINE_COUNT] = 0,
        [SPRITES]           = {},
        [SPRITE_QUEUE]      = sprite_queue,
        [PX_TO_DISCARD]     = 0,
    }
end


local function is_ly_lyc_stat_interrupt_enabled(ppu)
    return bit_band(mmu_get(ppu[MEMORY], ADDR_STAT), 0x40) ~= 0
end

local function is_vblank_stat_interrupt_enabled(ppu)
    return bit_band(mmu_get(ppu[MEMORY], ADDR_STAT), 0x10) ~= 0
end

local function is_hblank_stat_interrupt_enabled(ppu)
    return bit_band(mmu_get(ppu[MEMORY], ADDR_STAT), 0x08) ~= 0
end

local function request_stat_interrupt(ppu)
    mmu_set(ppu[MEMORY], ADDR_IF, bit_bor(mmu_get(ppu[MEMORY], ADDR_IF), 2)) -- Request LCD STAT interrupt.
end

local function ppu_set_mode(ppu, mode)
    ppu[MODE] = mode
    local stat = mmu_get(ppu[MEMORY], ADDR_STAT)
    mmu_set(ppu[MEMORY], ADDR_STAT, bit_bor(bit_band(stat, 0xFC), mode))
    
    -- Post set mode actions:
    if mode == MODE_OAM_SCAN then

        ppu[PIXEL] = 0 
        for k,v in pairs(ppu[SPRITES]) do ppu[SPRITES][k] = nil end -- Clear the sprites.
        
    elseif mode == MODE_OAM_READ then
        -- NO-OP
        
    elseif mode == MODE_HBLANK then
        if is_hblank_stat_interrupt_enabled(ppu) then
            request_stat_interrupt(ppu)
        end

    elseif mode == MODE_VBLANK then
        if is_vblank_stat_interrupt_enabled(ppu) then
            request_stat_interrupt(ppu)
        end
        mmu_set(ppu[MEMORY], ADDR_IF, bit_bor(mmu_get(ppu[MEMORY], ADDR_IF), 1))    
        ppu[WINDOW_LINE_COUNT] = 0

    end
end

local function ppu_add_ticks(ppu, ticks)
    ppu[TICKS] = ppu[TICKS] + ticks
    if ppu[TICKS] == 456 then
        ppu[TICKS] = 0
    end

    return ticks
end

local function set_ly(ppu, ly)
    mmu_set(ppu[MEMORY], ADDR_LY, ly)
    if is_ly_lyc_stat_interrupt_enabled(ppu) and ly == mmu_get(ppu[MEMORY], ADDR_LYC) then
        request_stat_interrupt(ppu)
    end
end

local function get_ly(ppu)
    return mmu_get(ppu[MEMORY], ADDR_LY)
end

local function get_scx(ppu)
    return mmu_get(ppu[MEMORY], ADDR_SCX)
end

local function get_scy(ppu)
    return mmu_get(ppu[MEMORY], ADDR_SCY)
end

local function get_color_from_palette(color_id, palette_data)
    if color_id == 0 then
        return bit_band(palette_data, 0x03)
        
    elseif color_id == 1 then
        return bit_band(bit_rshift(palette_data, 2), 0x03)
        
    elseif color_id == 2 then
        return bit_band(bit_rshift(palette_data, 4), 0x03)
        
    elseif color_id == 3 then
        return bit_band(bit_rshift(palette_data, 6), 0x03)
    
    else
        error("invalid color ID")
    end
end

local function background_color_to_shade(memory, color_id)
    -- Returns the shade from the color ID for background tiles
    local bgp = mmu_get(memory, ADDR_BG_PALETTE)
    return get_color_from_palette(color_id, bgp)
end

local function sprite_color_to_shade(memory, color_id, palette)
    -- Returns the shade from the color ID for sprite tiles
    if color_id == 0 then return 0 end -- NOTE: color_id = 0 is always transparent
    local palette_addr = ADDR_SPRITE_PALETTE[palette + 1]
    local palette_data = mmu_get(memory, palette_addr)
    return get_color_from_palette(color_id, palette_data)
end


local function get_shade(is_window, color_id, memory)
    if is_window then
        return background_color_to_shade(memory, color_id)
    else
        return window_color_to_shade(memory, color_id)
    end
end


local function lcdc(memory)  
    return mmu_get(memory, ADDR_LCDC)
end

local function background_window_enabled(memory)
    return bit_band(lcdc(memory), 0x01) ~= 0
end
local function sprite_enabled(memory)
    return bit_band(lcdc(memory), 0x02) ~= 0
end
local function sprite_size(memory)
    return bit_band(lcdc(memory), 0x04) ~= 0 and 16 or 8
end

local function get_sprite(memory, sprite_id)
    local y = mmu_get(memory, 0xFE00 + sprite_id * 4 + 0)
    local x = mmu_get(memory, 0xFE00 + sprite_id * 4 + 1)
    local tile = mmu_get(memory, 0xFE00 + sprite_id * 4 + 2)
    local flags = mmu_get(memory, 0xFE00 + sprite_id * 4 + 3)
    local y_flip = bit_band(flags, 0x40) ~= 0
    local x_flip = bit_band(flags, 0x20) ~= 0
    local palette = bit_band(flags, 0x10) ~= 0 and 1 or 0
    local bg_priority = bit_band(flags, 0x80) == 0
    return x-8, y-16, tile, x_flip, y_flip, palette, bg_priority
end

function ppu_tick(ppu)
    -- Run 1 tick (dot) of the PPU.
    -- NOTE: You should always call ppu_set_mode AFTER increasing the tick count with ppu_add_ticks.
    -- The reason is that ppu_set_mode triggers some post change mode actions that rely on ticks.
    local ly = get_ly(ppu)
    local mode = ppu[MODE]
    
    if     mode == MODE_OAM_SCAN then -- MODE 2
        -- Address where the background tile IDs are stored.
        local tile_map_addr = get_background_tile_map_addr(ppu[MEMORY]) 
        
        local scx = get_scx(ppu)
        ppu[PX_TO_DISCARD] = scx % 8                                    -- We'll discard the first pixels of the tile to get the proper X offset.
        local scy = get_scy(ppu)                                        -- Current scroll position (viewport on the map).
        local y = scy + ly                                              -- Absolute Y position on the map of the pixels being drawn.
        local row_addr = tile_map_addr + floor(y/8) * 32 + floor(scx/8) -- Each line is 32 tiles -> Adding (y//8) * 32 to get the start of the line -> Adding x//8 to get the start of the line on X
        local tile_line = y % 8                                         -- Relative to the tile, this is the Y position of the pixel.
        
        fetcher_reset(ppu[FETCHER], row_addr, tile_line, false) -- Configure the fetcher to start fetching pixels from there.
        fifo_clear(ppu[SPRITE_QUEUE])                           -- Remove all the sprites from previous line.
        
        -- Compute the list of the sprites on this row.
        for i=0, 40-1 do
            local sprite_x, sprite_y, sprite_tile, sprite_x_flip, sprite_y_flip, sprite_palette, sprite_priority = get_sprite(ppu[MEMORY], i)
            if ly >= sprite_y and ly < sprite_y + sprite_size(ppu[MEMORY]) then
                -- On the line
                local sprites_length = #ppu[SPRITES]
                ppu[SPRITES][sprites_length + 1] = sprite_x
                ppu[SPRITES][sprites_length + 2] = sprite_y
                ppu[SPRITES][sprites_length + 3] = sprite_tile
                ppu[SPRITES][sprites_length + 4] = sprite_x_flip
                ppu[SPRITES][sprites_length + 5] = sprite_y_flip
                ppu[SPRITES][sprites_length + 6] = sprite_palette
                ppu[SPRITES][sprites_length + 7] = sprite_priority
                
                if #ppu[SPRITES] == 10 * 7 then
                    break -- DMG only allow 10 sprites per line
                end
            end
        end
        

        local ticks = ppu_add_ticks(ppu, 80)


        ppu_set_mode(ppu, MODE_OAM_READ)
        return ticks
        
    elseif mode == MODE_OAM_READ then 
        local q = ppu[BGRND_QUEUE]
        local scx = get_scx(ppu)
        local scy = get_scy(ppu)
        local ly = get_ly(ppu)
        local wx, wy = get_window_pos(ppu[MEMORY])
        local window_enabled = is_window_enabled(ppu[MEMORY])
        local window_tile_map_addr = get_window_tile_map_addr(ppu[MEMORY])
        local is_background_and_window_enabled = background_window_enabled(ppu[MEMORY])
        local are_sprites_enabled = sprite_enabled(ppu[MEMORY])
        local sprite_size = sprite_size(ppu[MEMORY])
        
        local dots = 0
        
        while ppu[PIXEL] ~= 160 do
            if bit_band(ppu[TICKS], 0x01) == 0 then -- Run fetcher once every second tick.
                fetcher_tick(ppu[FETCHER])
            end
            
            -- Sprite fetching:
            for i=1, #ppu[SPRITES], 7 do
                local sprite_x       = ppu[SPRITES][i + 0]
                if sprite_x == ppu[PIXEL] then
                    local sprite_y        = ppu[SPRITES][i + 1]
                    local sprite_tile     = ppu[SPRITES][i + 2]
                    local sprite_x_flip   = ppu[SPRITES][i + 3]
                    local sprite_y_flip   = ppu[SPRITES][i + 4]
                    local sprite_palette  = ppu[SPRITES][i + 5]
                    local sprite_priority = ppu[SPRITES][i + 6]
                    
                    -- Bit 0 of tile index for 8x16 objects should be ignored
                    if sprite_size == 16 then
                        sprite_tile = bit_band(sprite_tile, 0xFE)
                    end
                    
                    -- Make sure there are AT LEAST 8 transparents pixels in the queue, so we can merge.
                    while fifo_length(ppu[SPRITE_QUEUE]) ~= 8 do
                        fifo_push(ppu[SPRITE_QUEUE], 0, 0, 0) 
                    end
                    
                    -- Merge the pixels in the queue with the pixels of the sprite.
                    local tile_y = ly - sprite_y
                    local tile_y = sprite_y_flip and sprite_size - 1 - tile_y or tile_y
                    local tile_addr = get_sprite_tile_addr(sprite_tile) + tile_y * 2
                    local tile_high = mmu_get(ppu[MEMORY], tile_addr + 1)
                    local tile_low = mmu_get(ppu[MEMORY], tile_addr + 0)
    
                    for i=0, 8-1 do
                        local q_color, q_palette, q_bg_priority = fifo_pop(ppu[SPRITE_QUEUE]) 
                        
                        if q_color == 0 then
                            -- Current pixel in queue is transparent, use the sprite.
                            local shade = get_shade_from_tile(tile_low, tile_high, sprite_x_flip and i or 7-i)
                            fifo_push(ppu[SPRITE_QUEUE], shade, sprite_palette, sprite_priority) 
                            
                        else
                            -- Current pixel in the queue is NOT transparent, this sprite does not have priority.
                            fifo_push(ppu[SPRITE_QUEUE], q_color, q_palette, q_bg_priority) 
                        end
                    end
                    
                    -- Makes sure the pixel will be drawn on this iteration.
                    while fifo_length(q) <= 8 do
                        fetcher_tick(ppu[FETCHER]) 
                    end
                end
            end
            
            -- Background drawing:
            if fifo_length(q) > 8  then
                -- Pop pixel to draw.
                local color_id, palette, bg_priority = fifo_pop(q)
                local shade = background_color_to_shade(ppu[MEMORY], color_id)
                local shade = is_background_and_window_enabled and shade or 0
                
                -- Sprite merging:
                if fifo_length(ppu[SPRITE_QUEUE]) > 0 then
                    local sprite_color_id, sprite_palette, sprite_bg_priority = fifo_pop(ppu[SPRITE_QUEUE])
                    
                    local is_above = false
                    if sprite_color_id == 0 then 
                        is_above = false -- Sprite is transparent, don't draw
                    
                    elseif sprite_bg_priority then
                        is_above = true -- Sprite is not transparent and has priority.
                    
                    elseif not sprite_bg_priority then
                        is_above = (color_id == 0) -- Sprite only has priority if BG color = 0
                    end
                    
                    if are_sprites_enabled and is_above then
                        color_id, palette, bg_priority = sprite_color_id, sprite_palette, sprite_bg_priority
                        shade = sprite_color_to_shade(ppu[MEMORY], color_id, palette)
                    end
                end
                
                -- Actually draw the pixel.
                
                if ppu[PX_TO_DISCARD] == 0 then
                    push_pixel_to_draw(ppu[PIXEL] + scx, ly + scy, shade)
                    ppu[PIXEL] = ppu[PIXEL] + 1
                else
                    -- There are pixels to discard, don't draw.
                    ppu[PX_TO_DISCARD] = ppu[PX_TO_DISCARD] - 1
                end
                
                -- Post draw action: The following code is only executed once just after the pixel cursor is incremented.
                if window_enabled and  ppu[PIXEL] + scx == wx and ly >= wy then -- We are on the left edge of the window, let's start drawing the window
                    local row_addr = window_tile_map_addr + floor(ppu[WINDOW_LINE_COUNT]/8) * 32             -- Load the tile row
                    local tile_line = ppu[WINDOW_LINE_COUNT] % 8
                    fetcher_reset(ppu[FETCHER], row_addr, tile_line, true)
                    ppu[WINDOW_LINE_COUNT] = ppu[WINDOW_LINE_COUNT] + 1
                end
            end
            

            local ticks = ppu_add_ticks(ppu, 1)
            dots = dots + ticks

        end
        
        ppu_set_mode(ppu, MODE_HBLANK)
        
        return dots
    
    elseif mode == MODE_HBLANK then -- MODE 0

        local ticks = ppu_add_ticks(ppu, 456 - ppu[TICKS]) -- Wait the time necessary for the scanline to be 456 ticks.

        
        local ly = ly + 1
        set_ly(ppu, ly)
        
        if ly == 144 then
            ppu_set_mode(ppu, MODE_VBLANK)
        else
            ppu_set_mode(ppu, MODE_OAM_SCAN)
        end
        return ticks


    elseif mode == MODE_VBLANK then -- MODE 1

        local ticks = ppu_add_ticks(ppu, 456)

        
        local ly = ly + 1
        if ly == 154 then
            set_ly(ppu, 0)
            ppu_set_mode(ppu, MODE_OAM_SCAN)
        else
            set_ly(ppu, ly)
        end
        return ticks
        
    else
        error("invalid PPU mode")
    end
end
