io.stdout:setvbuf('no') -- show debug output live in SublimeText console

local composer = require "composer"

local layout_idx = 0
local layout = nil

local window_w = 0
local window_h = 0

local function updateLayout()
	local is_debug = true

	layout_idx = layout_idx + 1
	if layout_idx > 3 then layout_idx = 1 end

	local path = "examples/example" .. layout_idx .. ".lua"
	print("loading:", path)
	layout = composer.load(path, is_debug)

	layout.getElement("test1", function(e)
		e.widget.setText("this text is changed using the ID")
	end)

	layout.getElement("button", function(e)
		e.widget.setTitle("these colors are changed using the ID")
		e.widget.setColors({ 0.5, 0.0, 0.0 }, { 0.0, 0.5, 0.0, 0.5 })
	end)
end

local function resizeLayout()
	layout.resize(window_w, window_h, function(e)
		e.widget.setFrame(e.rect.x, e.rect.y, e.rect.w, e.rect.h)
		print(e)
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

	window_w, window_h = love.window.getMode()
    resizeLayout()

    love.window.setTitle("Composer v" .. composer._VERSION)

--[[    print("\n\n")
    for k, v in pairs(_G.package.loaded) do
    	print(k, v)
    end
    print("\n\n")
--]]
end

function love.update(dt)
	layout.update(dt)
end

function love.draw()
	-- draw white background
	love.graphics.setColor(1.0, 1.0, 1.0)
	love.graphics.rectangle("fill", 0, 0, window_w, window_h)

	layout:draw()
end

function love.resize(w, h)
	window_w, window_h = w, h
    resizeLayout()
end

function love.keypressed(key, code)
	if key == "g" then
		updateLayout()
		
		local window_w, window_h = love.window.getMode()
		resizeLayout(window_w, window_h)
	end
end