local mouse = { x = 0, y = 0, is_down = false }

local function updateMouse(x, y, is_down)
    mouse = { x = x, y = y, is_down = is_down }
end

local function getMousePosition()
    return mouse.x, mouse.y
end

local function isMouseButtonDown()
    return mouse.is_down
end

local function init()
    local update = _G.love.update

    if _G.love then
        _G.love.update = function(dt)        
            update(dt)

            -- update default mouse position for next frame
            updateMouse(love.mouse.getX(), love.mouse.getY(), love.mouse.isDown(1))
        end
    end
end

return {
    init = init,
    updateMouse = updateMouse,
    getMousePosition = getMousePosition,
    isMouseButtonDown = isMouseButtonDown,
}
