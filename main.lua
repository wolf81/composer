io.stdout:setvbuf('no') -- show debug output live in SublimeText console

local composer = require "composer"
local Example1 = require 'examples.example1'

local example = Example1()

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

    love.window.setTitle("Composer v" .. composer._VERSION)
end

function love.update(dt)
    example:update(dt)
end

function love.draw()
    example:draw()
end

function love.resize(w, h)
	window_w, window_h = w, h
    print('window size', w, h)
    example:resize(w, h)
end

function love.keypressed(key, code)
	if key == "g" then
		updateLayout()
		
		local window_w, window_h = love.window.getMode()
		resizeLayout(window_w, window_h)
	end
end