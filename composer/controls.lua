local PATH = (...):match("(.-)[^%.]+$") 
local F = require(PATH .. "functions")
local Object = require(PATH .. 'classic')

--[[ CONTROL ]]--

local Control = Object:extend()

function Control:new()
    self.frame = { 0, 0, 0, 0 }
end

function Control:setFrame(x, y, w, h)
    self.frame = { x + 1, y + 1, w - 2, h - 2 }
end

function Control:getFrame()
    return unpack(self.frame)
end

function Control:update(dt)
    -- body
end

function Control:draw()
    love.graphics.setColor(1.0, 0.0, 1.0)
    love.graphics.rectangle('line', unpack(self.frame))
    love.graphics.setColor(1.0, 1.0, 1.0)
end


function Control:__tostring()
    return F.describe('Control', self)
end

--[[ LABEL ]]--

local Label = Control:extend()

function Label:new(text)
    Control.new(self)

    self.text = text
end

function Label:__tostring()
    return F.describe('Label', self)
end


return {
    Control = Control,
    Label = Label,
}
