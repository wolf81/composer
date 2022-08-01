-- based on the RectCut algorithm, but adjusted for easy integration with LÖVE
-- https://halt.software/dead-simple-layouts/

local Rect = {}
Rect.__index = Rect

function Rect.new(x, y, w, h)
    assert(w >= 0 and h >= 0, 'width and height cannot be negative')

    return setmetatable({
        x = x,
        y = y, 
        w = w,
        h = h,
    }, Rect)
end
    
-- cut out the left of the rect, returning the left piece and modifying the 
-- original rect
function Rect:cutLeft(a)
    local x = self.x
    self.x = self.x + a
    self.w = math.max(self.w - a, 0)
    return Rect(x, self.y, a, self.h)
end

-- cut out the right of the rect, returning the right piece and modifying the 
-- original rect
function Rect:cutRight(a)
    local x = self.x + self.w
    self.w = math.max(self.w - a, 0)
    return Rect(x - a , self.y, a, self.h)
end

-- cut out the top of the rect, returning the top piece and modifying the 
-- original rect
function Rect:cutTop(a)
    print('cutTop', a)
    
    local y = self.y
    self.y = self.y + a
    self.h = math.max(self.h - a, 0)
    return Rect(self.x, y, self.w, a)
end

-- cut out the bottom of the rect, returning the bottom piece and modifying the 
-- original rect
function Rect:cutBottom(a)
    print('cutBottom', a)

    local y = self.y + self.h
    self.h = math.max(self.h - a, 0)
    return Rect(self.x, y - a, self.w, a)
end

-- cut out the left of the rect, leaving the original unmodified
function Rect:getLeft(a)
    return Rect(self.x, self.y, a, self.h)
end

-- cut out the right of the rect, leaving the original unmodified
function Rect:getRight(a)
    return Rect(self.x + self.w - a , self.y, a, self.h)
end

-- cut out the top of the rect, leaving the original unmodified
function Rect:getTop(a)
    return Rect(self.x, self.y, self.w, a)
end

-- cut out the bottom of the rect, leaving the original unmodified
function Rect:getBottom(a)
    return Rect(self.x, self.y + self.h - a, self.w, a)
end

-- inset rect, leaving the original unmodified
function Rect:inset(top, left, bottom, right)
    left = left or top
    bottom = bottom or top
    right = right or left
    return Rect(self.x + left, self.y + top, self.w - (right + left), self.h - (bottom + top))
end

-- return x, y, w & h
function Rect:unpack()
    return self.x, self.y, self.w, self.h
end

function Rect:__tostring()
    return 'Rect { x = ' .. self.x .. ', y = ' .. self.y .. ', w = ' .. self.w .. ', h = ' .. self.h .. ' }'
end

return setmetatable(Rect, {
    __call = function(_, ...) return Rect.new(...) end,
})
