local PATH = (...):match('(.-)[^%.]+$') 
local Object = require(PATH .. 'classic')

local Margin = Object:extend()

function Margin:new(t, l, b, r)
    self.t = t or 0
    self.l = l or self.t
    self.b = b or self.t
    self.r = r or self.l
end

function Margin:unpack()
    return self.t, self.l, self.b, self.r
end

return {
    Margin = Margin,
}
