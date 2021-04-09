--@name Screen queue
--@client

local floor = math.floor
local systime = timer.systime

-- Shades currently displayed on the screen.
local SCREEN_SHADES = {}
for i=1, 256*256 do SCREEN_SHADES[i] = -1 end

local function get_arr(arr, x, y)
    return arr[1 + x + y * 256]
end
local function set_arr(arr, x, y, shade)
    arr[1 + x + y * 256] = shade
end

-- Contains the pixels to draw on the screen.
local pixel_queue = {}

-- Set of all the pixels in the queue.
local PIXEL_SET     = {}
for i=1, 256*256 do PIXEL_SET[i] = false end

function push_pixel_to_draw(x, y, shade)
    local x,y = floor(x), floor(y)
    if get_arr(SCREEN_SHADES, x, y) == shade then
        return -- Screen has already the correct color, no need to re-draw it.
    end
    set_arr(SCREEN_SHADES, x, y, shade)
    
    if get_arr(PIXEL_SET, x, y) then
        return -- Pixel already in the queue, prevents the pixel to be twice in the queue.
    end
    
    local l = #pixel_queue
    pixel_queue[l+1] = x
    pixel_queue[l+2] = y
    set_arr(PIXEL_SET, x, y, true)
end

function pixels_to_draw(cb)
    for i=1, #pixel_queue, 2 do
        local x = pixel_queue[i]
        local y = pixel_queue[i+1]
        cb(x, y, get_arr(SCREEN_SHADES, x, y))
        set_arr(PIXEL_SET, x, y, false)
        pixel_queue[i] = nil
        pixel_queue[i+1] = nil
        
    end
end