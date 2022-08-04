local PATH = (...):match('(.-)[^%.]+$') 
local Object = require(PATH .. 'classic')
local F = require(PATH .. 'functions')

--[[ CONTROL ]]--

local Control = Object:extend()

function Control:new()
    self.color = F.randomColor()

    self.frame = { 0, 0, 0, 0 }
end

function Control:setFrame(x, y, w, h)
    self.frame = { x, y, w, h }
end

function Control:update(dt)
    -- body
end

function Control:draw()
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle('fill', unpack(self.frame))
end

function Control:__tostring()
    return F.describe('Control', self)
end

--[[ BUTTON ]]--

local Button = Control:extend()

--[[ MODULE ]]--

return {
    Control = Control,
    Button = Button,
}