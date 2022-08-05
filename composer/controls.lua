local PATH = (...):match('(.-)[^%.]+$') 
local Object = require(PATH .. 'classic')
local F = require(PATH .. 'functions')
local Theme = require(PATH .. 'theme')

local mfloor, mceil = math.floor, math.ceil

local getColorsForState = function(state)
	return Theme[state] or Theme['normal']
end

local shallowCopy = function(tbl)
	return { unpack(tbl) }
end

local getTextSize = function(text, font)
	return { w = font:getWidth(text), h = font:getHeight() }
end

local parseFont = function(font_info)
	local font_size = 16
	local font_name = 'Bitstream Vera Sans'

	if type(font_info) == 'string' then
		font_name = font_info
	elseif type(font_info) == 'number' then
		font_size = font_info
	elseif type(font_info) == 'table' then
		for _, v in ipairs(font_info) do
			if type(v) == 'number' then font_size = v
			elseif type(v) == 'string' then font_name = v
			else error('value should be either a string, number or table containing a string and number') end
		end
	end

	return love.graphics.newFont(font_name, font_size)
end

local drawRect = function(frame)
	local line_width = love.graphics.getLineWidth()

	local x = frame.x + line_width / 2
	local y = frame.y + line_width / 2
	local w = frame.w - line_width
	local h = frame.h - line_width 

	love.graphics.rectangle('line', x, y, w, h)
end

local drawLine = function(x1, y1, x2, y2, state)
	-- TODO: color should probably be set in draw() function or we can get 
	-- unexpected results
	local state = state == 'disabled' and 'disabled' or 'normal'
	local c = getColorsForState(state)

	local line_width = love.graphics.getLineWidth()
	local x1 = x1 + line_width / 2
	local x2 = x2 - line_width
	local y1 = y1 + line_width / 2
	local y2 = y2 - line_width

	love.graphics.setColor(c.fg)
	love.graphics.line(x1, y1, x2, y2)
end

local drawBorder = function(frame, state)	
	-- TODO: color should probably be set in draw() function or we can get 
	-- unexpected results
	local state = state == 'disabled' and 'disabled' or 'normal'
	local c = getColorsForState(state)

	love.graphics.setColor(c.fg)
	drawRect(frame)
end

--[[ RECT ]]--

local Rect = Object:extend()

function Rect:new(x, y, w, h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
end

function Rect:midXY() return self.x + self.w / 2, self.y + self.h / 2 end

function Rect:maxX() return self.x + self.w end

function Rect:maxY() return self.y + self.h end

function Rect:containsPoint(x, y)
	return (
		x >= self.x and x < self.x + self.w and 
		y >= self.y and y < self.y + self.h
	)
end

function Rect:unpack() return self.x, self.y, self.w, self.h end

--[[ CONTROL ]]--

local Control = Object:extend()

function Control:new()
    self.color = F.randomColor()
    self.state = 'normal'
    self.frame = Rect(0, 0, 0, 0)
end

function Control:setFrame(x, y, w, h)
    self.frame = Rect(x, y, w, h)
end

function Control:setEnabled(is_enabled)
	if is_enabled then self.state = 'normal' else self.state = 'disabled' end
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
	self.font = opts.font and parseFont(opts.font) or love.graphics.getFont()	
	self.text_size = getTextSize(self.text, self.font)
end

function Label:draw()
	local c = getColorsForState('normal')
	local text_x, text_y = self.frame:midXY()

	love.graphics.setColor(c.fg)
	love.graphics.setFont(self.font)
	love.graphics.print(
		self.text, 
		mfloor(text_x), 
		mfloor(text_y), 
		0, 1, 1,
		mceil(self.text_size.w / 2), 
		mceil(self.text_size.h / 2)
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
	
	self.text = opts.text or ''
	self.font = opts.font and parseFont(opts.font) or love.graphics.getFont()	
	self.text_size = getTextSize(self.text, self.font)
end

function Button:update(dt)
	local m_x, m_y = love.mouse.getPosition()
	self.state = self.frame:containsPoint(m_x, m_y) and 'hovered' or 'normal'

	if self.state == 'hovered' and love.mouse.isDown(1) then
		self.state = 'active'
	end
end

function Button:draw()
	local state = 'normal'

	local c = getColorsForState(self.state)
	local text_x, text_y = self.frame:midXY(self.frame)

	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', self.frame:unpack())

	love.graphics.setColor(c.fg)
	love.graphics.setFont(self.font)
	love.graphics.print(
		self.text, 
		mfloor(text_x), 
		mfloor(text_y), 
		0, 1, 1,
		mceil(self.text_size.w / 2), 
		mceil(self.text_size.h / 2)
	)

	drawBorder(self.frame, self.state)
end

function Button:__tostring()
	return F.describe('Button', self)
end

--[[ CHECK BOX ]]--

local Checkbox = Object:extend()

function Checkbox:new(opts)
	-- body
end

function Checkbox:__tostring()
	return F.describe('Checkbox', self)
end

--[[ IMAGE BUTTON ]]--

local ImageButton = Control:extend()

function ImageButton:new(opts)
	Control.new(self)

	local opts = opts or {}

	self.state = 'normal'
	self.image = opts.image and love.graphics.newImage(opts.image) or nil
	
	self.drawBorder = function(c)
		love.graphics.setColor(c.fg)
		drawRect(self.frame)
	end
end

function ImageButton:update(dt)
	if self.state == 'disabled' then return end

	local m_x, m_y = love.mouse.getPosition()
	self.state = self.frame:containsPoint(m_x, m_y) and 'hovered' or 'normal'

	if self.state == 'hovered' and love.mouse.isDown(1) then
		self.state = 'active'
	end	
end

function ImageButton:draw()
	local c = getColorsForState(self.state)

	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', self.frame:unpack())

	-- now we can use the color for drawing
	love.graphics.setColor(c.fg)

	-- draw the image
	if self.image then
		local iw, ih = self.image:getDimensions()
		local ox = (iw - self.frame.w) / 2
		local oy = (ih - self.frame.h) / 2
		love.graphics.draw(self.image, self.frame.x, self.frame.y, 0, 1, 1, ox, oy)		
	end

	drawBorder(self.frame, self.state)
end

function ImageButton:__tostring()
	return F.describe('ImageButton', self)
end

--[[ SCROLL VIEW ]]--

local ScrollView = Control:extend()

ScrollView.BUTTON_SIZE = 24
ScrollView.SCROLL_SPEED = 100

function ScrollView:new(...)
	Control.new(self)

	self.btn_up = ImageButton({ image = 'composer/assets/arrow_up.png' })
	self.btn_dn = ImageButton({ image = 'composer/assets/arrow_dn.png' })
	self.scroller = ImageButton({ image = 'composer/assets/scroller.png' })

	self.btn_up:setEnabled(false)
	self.btn_dn:setEnabled(false)
	self.scroller:setEnabled(false)

	self.btn_up.drawBorder = function() end
	self.btn_dn.drawBorder = function() end
	self.scroller.drawBorder = function() end

	self.content_y = 0
	self.content_h = 0
end

function ScrollView:setFrame(x, y, w, h)
	Control.setFrame(self, x, y, w, h)

	local control_x = x + w - ScrollView.BUTTON_SIZE
	local control_s = ScrollView.BUTTON_SIZE

	local line_w = love.graphics:getLineWidth()

	self.btn_up:setFrame(control_x, y, control_s, control_s)
	self.btn_dn:setFrame(control_x, y + h - control_s, control_s, control_s)
	self.scroller:setFrame(control_x, y + control_s - line_w, control_s, control_s)
end

function ScrollView:setContentView(content_view)
	if not content_view then return end

	local _, h = content_view:sizeThatFits(self.frame.w, math.huge)
	self.content_y = 0
	self.content_h = h
end

function ScrollView:update(dt)
	self.btn_up:update(dt)
	self.btn_dn:update(dt)
	self.scroller:update(dt)
end

function ScrollView:draw()
	local c = getColorsForState(self.state)
	
	local line_w = love.graphics.getLineWidth()
	local line_x = self.frame:maxX() - ScrollView.BUTTON_SIZE + line_w / 2

	self.btn_up:draw()
	self.btn_dn:draw()

	-- draw seperator between up & down buttons and scroll area
	love.graphics.setColor(c.fg)
	for _, y in ipairs({ 
		self.btn_up.frame:maxY() - line_w / 2, 
		self.btn_dn.frame.y + line_w / 2 
	}) do
		love.graphics.line(line_x, y, line_x + ScrollView.BUTTON_SIZE - line_w, y)
	end

	-- draw scroller so scroller border always appears on top
	if self.content_h > self.frame:maxY() then
		self.scroller:draw()
		drawBorder(self.scroller.frame, self.state)
	end

	-- draw border between content area and scroll area
	love.graphics.setColor(c.fg)
	love.graphics.line(
		line_x, 
		self.frame.y + line_w / 2, 
		line_x, 
		self.frame:maxY() - line_w / 2
	)

	drawBorder(self.btn_up.frame, self.state)
	drawBorder(self.btn_dn.frame, self.state)

	-- draw outer border
	drawBorder(self.frame, self.state)
end

function ScrollView:__tostring()
	return F.describe('ScrollView', self)
end

--[[ MODULE ]]--

return {
    Control = Control,
    Label = Label,
    Button = Button,
    ImageButton = ImageButton,
    ScrollView = ScrollView,
    Checkbox = Checkbox,
}
