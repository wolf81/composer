local Button = {}

Button.new = function(image)
    local frame = { 0, 0, 0, 0 }

    local is_highlighted = false

    local setFrame = function(self, x, y, w, h)
        frame = { x, y, w, h }
    end

    local update = function(self, dt)
        local mx, my = love.mouse.getPosition()

        local x1, x2 = frame[1], frame[1] + frame[3]
        local y1, y2 = frame[2], frame[2] + frame[4]

        is_highlighted = mx >= x1 and mx < x2 and my >= y1 and my < y2
    end

    local draw = function(self)
        love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
        if is_highlighted then
            love.graphics.setColor(1.0, 0.0, 1.0, 1.0)
        end
        love.graphics.draw(image, frame[1], frame[2])
    end

    return setmetatable({
        setFrame = setFrame,
        update = update,
        draw = draw,
    }, Button)
end

return setmetatable(Button, {
    __call = function(_, ...) return Button.new(...) end,
})
