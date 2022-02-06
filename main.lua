io.stdout:setvbuf('no') -- show debug output live in SublimeText console

local composer = require "composer"

local layout_idx = 0
local layout = nil

local function updateLayout()
	layout_idx = layout_idx + 1
	if layout_idx > 3 then layout_idx = 1 end

	local path = "examples/example" .. layout_idx .. ".lua"
	print("loading:", path)
	layout = composer.load(path, true)

	layout.getElement("test1", function(e)
		e.widget.setText("blaat")
	end)
end

local function resizeLayout(w, h)
	layout.resize(w, h, function(e)
		e.widget.setFrame(e.rect.x, e.rect.y, e.rect.w, e.rect.h)
	end)
end

function love.load(args)
    local desktop_w, desktop_h = love.window.getDesktopDimensions()
    local flags = {
        resizable = true,
        minwidth = desktop_w * 0.4,
        minheight = desktop_h * 0.5,
    }
    love.window.setMode(desktop_w * 0.6, desktop_h * 0.7, flags)

    love.keyboard.pressed = {}
    love.keyboard.wasPressed = function(key)
        return love.keyboard.pressed[key] == true
    end

    love.keyboard.released = {}
    love.keyboard.wasReleased = function(key)
        return love.keyboard.released[key] == true
    end

    -- add custom controls to the layout engine loader
    composer.require("widgets/widgets.lua")
    updateLayout()

	local window_w, window_h = love.window.getMode()
    resizeLayout(window_w, window_h)

    love.window.setTitle("Composer " .. composer._VERSION)

--[[    print("\n\n")
    for k, v in pairs(_G.package.loaded) do
    	print(k, v)
    end
    print("\n\n")
--]]
end

function love.update(dt)
	layout:update(dt)
end

function love.draw()
	layout:draw()
end

function love.resize(w, h)
    resizeLayout(w, h)
end

function love.keypressed(key, code)
	print(key, code)

	if key == "g" then
		updateLayout()
		
		local window_w, window_h = love.window.getMode()
		resizeLayout(window_w, window_h)
	end
end