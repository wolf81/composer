local mouse = { x = 0, y = 0, is_down = is_down }
local key = { down = nil, char = nil }
local active = nil

local function updateMouse(x, y, is_down)
    mouse = { x = x, y = y, is_down = is_down }
end

local function getMousePosition()
    return mouse.x, mouse.y
end

local function getPressedKey()
    return key.down, key.char
end

local function isMouseButtonDown()
    return mouse.is_down
end

local function init()
    if _G.love then
        local update = _G.love.update
        local keypressed = _G.love.keypressed
        local textinput = _G.love.textinput or function(t) end

        _G.love.update = function(dt)        
            update(dt)

            -- update default mouse position for next frame
            mouse = { 
                x = love.mouse.getX(), 
                y = love.mouse.getY(), 
                is_down = love.mouse.isDown(1),
            }

            key = { code = nil, char = nil }
        end

        _G.love.keypressed = function(k)
            keypressed(k)

            key.down = k            
        end

        _G.love.textinput = function(t)
            textinput(t)

            key.char = t
        end
    end
end

local function setActive(control)
    active = control
end

local function getActive()
    return active
end

return {
    init = init,
    updateMouse = updateMouse,
    getMousePosition = getMousePosition,
    getPressedKey = getPressedKey,
    isMouseButtonDown = isMouseButtonDown,
    setActive = setActive,
    getActive = getActive,
}
