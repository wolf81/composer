local Grid = require 'composer.grid'
local Button = require 'widgets.button'

local Example = {}

Example.new = function()
    local layout = Grid(
        { math.huge, 64 }, 
        { math.huge, 64, 64, 64, 64, math.huge }
    )
    print('size', love.window.getMode())
    layout:resize(love.window.getMode())

    layout:addChild(Button(love.graphics.newImage('gfx/conversation.png')), 2, 2)
    layout:addChild(Button(love.graphics.newImage('gfx/cultist.png')), 2, 3)
    layout:addChild(Button(love.graphics.newImage('gfx/high-shot.png')), 2, 4)
    layout:addChild(Button(love.graphics.newImage('gfx/magic-potion.png')), 2, 5)

    local draw = function(self) layout:draw() end

    local update = function(self, dt) layout:update(dt) end

    local resize = function(self, w, h) layout:resize(w, h) end

    return setmetatable({
        draw = draw,
        resize = resize,
        update = update,
    }, Example)
end

return setmetatable(Example, {
    __call = function(_, ...) return Example.new(...) end,
})
