--@name FIFO
--@client
local assert = assert

local MAX_SIZE = 16

local FIFO_HEAD = 1
local FIFO_TAIL = 2
local FIFO_ARR  = 3
local FIFO_SIZE = 4

function new_fifo()
    local arr = {}
    for i=1, MAX_SIZE * 3 do
        arr[i] = 0
    end
    return {
        [FIFO_HEAD] = 1,
        [FIFO_TAIL] = 1,
        [FIFO_ARR]  = arr,
        [FIFO_SIZE] = 0
    }    
end

function fifo_push(q, color, palette, bg_priority)
    assert(q ~= nil, "queue is nil")
    assert(q[FIFO_SIZE] < 16, "queue is full")
    
    local pos = q[FIFO_TAIL]
    q[FIFO_ARR][pos + 0] = color
    q[FIFO_ARR][pos + 1] = palette
    q[FIFO_ARR][pos + 2] = bg_priority
    
    local new_tail = pos + 3
    local new_tail = (new_tail == MAX_SIZE * 3 + 1) and 1 or new_tail  -- Next element cannot be inserted at the end, so we insert it at the start.
    q[FIFO_TAIL] = new_tail
    q[FIFO_SIZE] = q[FIFO_SIZE] + 1
end

function fifo_pop(q)
    assert(q ~= nil, "queue is nil")
    assert(q[FIFO_SIZE] > 0, "queue is empty")
    
    local pos = q[FIFO_HEAD]
    local color       = q[FIFO_ARR][pos + 0]
    local palette     = q[FIFO_ARR][pos + 1]
    local bg_priority = q[FIFO_ARR][pos + 2]
    
    local new_head = pos + 3
    local new_head = (new_head == MAX_SIZE * 3 + 1) and 1 or new_head
    
    q[FIFO_HEAD] = new_head
    q[FIFO_SIZE] = q[FIFO_SIZE] - 1
    return color, palette, bg_priority
end

function fifo_length(q)
    return q[FIFO_SIZE]
end


function fifo_clear(q)
    assert(q ~= nil, "queue is nil")
    
    q[FIFO_HEAD] = 1
    q[FIFO_TAIL] = 1
    q[FIFO_SIZE] = 0
end


local function test()
    local q = new_fifo()
    
    fifo_push(q, 1, 2, 3)
    fifo_push(q, 4, 5, 6)
    
    local a, b, c = fifo_pop(q)
    assert(a == 1 and b == 2 and c == 3)
    
    local a, b, c = fifo_pop(q)
    assert(a == 4 and b == 5 and c == 6)
    
    fifo_push(q, 7, 8, 9)
    local a, b, c = fifo_pop(q)
    assert(a == 7 and b == 8 and c == 9)
    
    for i=1,16 do
        fifo_push(q, i, i, i)
    end
    
    for i=1,16 do
        local a, b, c = fifo_pop(q)
        assert(a == i and b == i and c == i)
    end
end
test()