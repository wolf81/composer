local PATH = (...):match('(.-)[^%.]+$') 
local Object = require(PATH .. 'classic')
local F = require(PATH .. 'functions')
local Theme = require(PATH .. 'theme')

local mfloor, mceil = math.floor, math.ceil

local getColorsForState = function(state)
	return Theme[state] or Theme['normal']
end

local getTextSize = function(text, font)
	return font:getWidth(text), font:getHeight()
end

local rectContainsPoint = function(rect, x, y)
	return (
		x > rect[1] and 
		x < rect[1] + rect[3] and 
		y > rect[2] and 
		y < rect[2] + rect[4]
	)
end

local getMidXY = function(rect)
	return rect[1] + rect[3] / 2, rect[2] + rect[4] / 2
end

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

--[[ LABEL ]]--

local Label = Control:extend()

function Label:new(opts)
	Control.new(self)

	local opts = opts or {}

	self.text = opts.text or ''

	local font = love.graphics.getFont()
	self.text_size = { getTextSize(self.text, font) }
end

function Label:draw()
	local c = getColorsForState('normal')
	local text_x, text_y = getMidXY(self.frame)

	-- love.graphics.setColor(c.bg)
	-- love.graphics.rectangle('fill', unpack(self.frame))

	--love.graphics.setFont(font)
	love.graphics.setColor(c.fg)
	love.graphics.print(
		self.text, 
		mfloor(text_x), 
		mfloor(text_y), 
		0, 1, 1,
		mceil(self.text_size[1] / 2), 
		mceil(self.text_size[2] / 2)
	)
end

function Label:__tostring()
	return F.describe('Label', self)
end

--[[ BUTTON ]]--

local Button = Control:extend()

function Button:new(opts)
	Control.new(self)

	local opts = opts or {}

	self.is_selected = false
	self.is_highlighted = false

	self.text = opts.text or ''

	local font = love.graphics.getFont()
	self.text_size = { getTextSize(self.text, font) }
end

function Button:update(dt)
	local m_x, m_y = love.mouse.getPosition()
	self.is_highlighted = rectContainsPoint(self.frame, m_x, m_y)
end

function Button:draw()
	local state = "normal"

	if self.is_selected then 
		state = "active"
	elseif self.is_highlighted then
		state = "hovered"
	end

	local c = getColorsForState(state)
	local text_x, text_y = getMidXY(self.frame)

	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', unpack(self.frame))

	--love.graphics.setFont(font)
	love.graphics.setColor(c.fg)
	love.graphics.print(
		self.text, 
		mfloor(text_x), 
		mfloor(text_y), 
		0, 1, 1,
		mceil(self.text_size[1] / 2), 
		mceil(self.text_size[2] / 2)
	)
end

function Button:__tostring()
	return F.describe('Button', self)
end

--[[ IMAGE BUTTON ]]--

local ImageButton = Control:extend()

function ImageButton:new(opts)
	Control.new(self)

	local opts = opts or {}

	self.is_selected = false
	self.is_highlighted = false
	self.image = opts.image and love.graphics.newImage(opts.image) or nil
end

function ImageButton:update(dt)
	local m_x, m_y = love.mouse.getPosition()
	self.is_highlighted = rectContainsPoint(self.frame, m_x, m_y)
end

function ImageButton:draw()
	local state = "normal"

	if self.is_selected then 
		state = "active"
	elseif self.is_highlighted then
		state = "hovered"
	end

	local c = getColorsForState(state)

	if self.image then
		love.graphics.setColor(c.fg)		

		local iw, ih = self.image:getDimensions()
		local ox = (iw - self.frame[3]) / 2
		local oy = (ih - self.frame[4]) / 2
		love.graphics.draw(self.image, self.frame[1], self.frame[2], 0, 1, 1, ox, oy)		
	end
end

function ImageButton:__tostring()
	return F.describe('ImageButton', self)
end

--[[ MODULE ]]--

return {
    Control = Control,
    Label = Label,
    Button = Button,
    ImageButton = ImageButton,
}
