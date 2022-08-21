io.stdout:setvbuf('no') -- show debug output live in SublimeText console

local composer = require 'composer'

local layout_idx = 3
local layout = nil

local window_w = 0
local window_h = 0

local scale = 1.0

local function updateLayout()
	local is_debug = true

	layout_idx = layout_idx + 1
	if layout_idx > 7 then layout_idx = 1 end

	local path = 'examples/example' .. layout_idx .. '.lua'
	print('loading: ', path)
	layout = composer.load(path, is_debug)

	layout.getControl('test1', function(e)
		e.widget.setText('this text is changed using the ID')
	end)

	layout.getControl('button', function(e)
		e.widget.setTitle('these colors are changed using the ID')
		e.widget.setColors({ 0.5, 0.0, 0.0 }, { 0.0, 0.5, 0.0, 0.5 })
	end)
end

local function resizeLayout()
    layout.resize(window_w / scale, window_h / scale)
end

function love.load(args)
    local desktop_w, desktop_h = love.window.getDesktopDimensions()
    local flags = {
        resizable = true,
        minwidth = desktop_w * 0.4,
        minheight = desktop_h * 0.5,
        msaa = 8,
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

    math.randomseed(os.time())
    love.graphics.setLineWidth(2)

    -- required for composer to hook up updates for mouse position
    composer.init()

    -- add custom controls to the layout engine loader
    updateLayout()

	window_w, window_h = love.window.getMode()
    resizeLayout()

    love.window.setTitle('Composer v' .. composer._VERSION)
end

function love.update(dt)
    -- we only need to update mouse position manually if scale is not equal to 1
    composer.updateMouse(
        love.mouse.getX() / scale, 
        love.mouse.getY() / scale, 
        love.mouse.isDown(1)
    )

	layout.update(dt)
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(scale)

	-- draw white background
	love.graphics.setColor(0.0, 0.0, 0.0)
	love.graphics.rectangle('fill', 0, 0, window_w, window_h)

	layout.draw()

    love.graphics.pop()
end

function love.resize(w, h)
	window_w, window_h = w, h
    resizeLayout()
end

function love.keypressed(key)
	if key == 'tab' then
		updateLayout()
		
		local window_w, window_h = love.window.getMode()
		resizeLayout(window_w, window_h)
	end
end
