local PATH = (...):match('(.-)[^%.]+$') 
local Object = require(PATH .. 'classic')
local F = require(PATH .. 'functions')
local Theme = require(PATH .. 'theme')
local core = require(PATH .. 'core')
local layout = require(PATH .. 'layout')
local utf8 = require 'utf8'

local mfloor, mceil, mmax, mmin = math.floor, math.ceil, math.max, math.min
local tconcat = table.concat

local getColorsForState = function(state)
	return Theme[state] or Theme['normal']
end

local round = function(x)
	return x >= 0 and mfloor(x + 0.5) or mceil(x - 0.5)
end

local getTextSize = function(text, font)
	return { w = font:getWidth(text), h = font:getHeight() }
end

local split = function(str, pos)
	local offset = utf8.offset(str, pos) or 0
	return str:sub(1, offset - 1), str:sub(offset)
end

local getAlignment = function(align)
	local alignments = { 'center', 'left', 'right' }

	if not align then return alignments[1] end

	for _, alignment in ipairs(alignments) do
		if align == alignment then return alignment end
	end

	error('invalid alignment, valid values are: ' .. tconcat(alignments, ', '))
end

local parseFont = function(font_info)
	local font_size = 16
	local font_name = nil

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

	if font_name == nil then
		return love.graphics.newFont(font_size)
	else
		return love.graphics.newFont(font_name, font_size)
	end
end

local drawRect = function(frame, corner_r)
	local corner_r = corner_r or 0
	local line_width = love.graphics.getLineWidth()

	local x = frame.x + line_width / 2
	local y = frame.y + line_width / 2
	local w = frame.w - line_width
	local h = frame.h - line_width 

	love.graphics.rectangle('line', x, y, w, h, corner_r, corner_r)
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

function Rect:__tostring()
	return '{ ' .. table.concat({ self.x, self.y, self.w, self.h }, ', ') .. ' }'
end

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
	if self.state == 'disabled' then return end

	local m_x, m_y = core.getMousePosition()
	local next_state = self.frame:containsPoint(m_x, m_y) and 'hovered' or 'normal'

	if next_state == 'hovered' and core.isMouseButtonDown() then
		next_state = 'active'
	end	

	if self.state == 'active' then
		core.setActive(self)

		if next_state == 'hovered' then self:hit() end
	end

	self.state = next_state
end

-- can be overidden by subclasses to respond on hit
function Control:hit() end

function Control:draw()
    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle('fill', unpack(self.frame))
end

function Control:sizeThatFits(w, h)
	return w, h
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
	self.align = getAlignment(opts.align)
	self.font = parseFont(opts.font)
	self.text_size = getTextSize(self.text, self.font)
end

function Label:draw()
	local c = getColorsForState('normal')
	love.graphics.setColor(c.fg)
	love.graphics.setFont(self.font)
	love.graphics.printf(
		self.text,
		self.font,
		mfloor(self.frame.x),
		mfloor(self.frame.y + (self.frame.h - self.text_size.h) / 2),
		self.frame.w,
		self.align
	)		
end

function Label:sizeThatFits(w, h)
	if w == math.huge then w = self.text_size.w end
	if h == math.huge then h = self.text_size.h end
	return w, h
end

function Label:__tostring()
	return F.describe('Label', self)
end

--[[ BUTTON ]]--

local Button = Control:extend()

Button.PADDING = 10

function Button:new(opts)
	Control.new(self)

	local opts = opts or {}

	self.text = opts.text or ''
	self.font = parseFont(opts.font)
	self.text_size = getTextSize(self.text, self.font)
	self.corner_radius = opts.corner_radius or 0
end

function Button:draw()
	local state = 'normal'

	local c = getColorsForState(self.state)
	local text_x, text_y = self.frame:midXY(self.frame)

	local x, y, w, h = self.frame:unpack()
	local r = self.corner_radius

	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x, y, w, h, r, r)

	love.graphics.setColor(c.fg)
	love.graphics.rectangle('line', x, y, w, h, r, r)

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

function Button:sizeThatFits(w, h)
	if w == math.huge then w = self.text_size.w + Button.PADDING * 2 end
	if h == math.huge then h = self.text_size.h + Button.PADDING * 2 end
	return w, h
end

function Button:__tostring()
	return F.describe('Button', self)
end

--[[ CHECK BOX ]]--

local Checkbox = Control:extend()
Checkbox.SIZE = 20

function Checkbox:new(opts)
	Control.new(self)

	local opts = opts or {}

	self.checked = opts.checked == true
	self.corner_radius = opts.corner_radius or 0
end

function Checkbox:hit()
	if self.state == 'disabled' then return end

	self.checked = not self.checked
end

function Checkbox:draw()
	local c = getColorsForState(self.state)

	local x, y, w, h = self.frame:unpack()

	-- for the checkbox, the active state contains only the checkmark image, so
	-- when in active state, use normal image for background
	local state = self.state == 'active' and 'normal' or self.state
	local r = self.corner_radius

	local dx, dy = (w - Checkbox.SIZE) / 2, (h - Checkbox.SIZE) / 2

	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x + dx, y + dy, Checkbox.SIZE, Checkbox.SIZE, r, r)

	love.graphics.setColor(c.fg)
	love.graphics.rectangle('line', x + dx, y + dy, Checkbox.SIZE, Checkbox.SIZE, r, r)

	-- if checked, draw checkmark
	if self.checked then
		local lw = love.graphics.getLineWidth()
		local x, y = self.frame:midXY()
		local r = Checkbox.SIZE / 2 - lw * 2
		love.graphics.circle('fill', x, y, r)
	end
end

function Checkbox:sizeThatFits(w, h)
	if w == math.huge then w = Checkbox.SIZE end
	if h == math.huge then h = Checkbox.SIZE end
	return w, h	
end

function Checkbox:__tostring()
	return F.describe('Checkbox', self)
end

--[[ IMAGE BUTTON ]]--

local ImageButton = Control:extend()

function ImageButton:new(opts)
	Control.new(self)

	local opts = opts or {}

	self.image = opts.image and love.graphics.newImage(opts.image)
	self.corner_radius = opts.corner_radius or 0
end

function ImageButton:draw()
	local c = getColorsForState(self.state)

	local x, y, w, h = self.frame:unpack()
	local r = self.corner_radius

	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x, y, w, h, r, r)

	love.graphics.setColor(c.fg)
	love.graphics.rectangle('line', x, y, w, h, r, r)

	-- draw the image
	local image = self.image
	if image then
		local iw, ih = image:getDimensions()
		local ox = (iw - self.frame.w) / 2
		local oy = (ih - self.frame.h) / 2
		love.graphics.draw(image, self.frame.x, self.frame.y, 0, 1, 1, ox, oy)		
	end
end

function ImageButton:sizeThatFits(w, h)
	local img_w, img_h = self.image:getDimensions()
	if w == math.huge then w = img_w end
	if h == math.huge then h = img_h end
	return w, h	
end

function ImageButton:__tostring()
	return F.describe('ImageButton', self)
end

--[[ PROGRESS ]]--

local Progress = Control:extend()
Progress.BAR_HEIGHT = 20
Progress.DEFAULT_WIDTH = 150

function Progress:new(opts)
	Control.new(self)

	local opts = opts or {}

	self.corner_radius = opts.corner_radius or 0
	self.value = opts.value or 0
end

function Progress:setValue(x)
	self.value = mmin(mmax(x, 0), 1.0)
end

function Progress:getValue()
	return self.value
end

function Progress:update(dt)
	Control.update(self, dt)

	if self.state == 'active' or self.state == 'hovered' then
		self.state = 'normal'
	end
end

function Progress:draw()
	local c = getColorsForState('active')

	local x, y, w, h = self.frame:unpack()
	local r = self.corner_radius

	local bar_y = y + mfloor(h - Progress.BAR_HEIGHT) / 2
	local bar_w = self.value * w

	if self.value > 0 then
		love.graphics.setColor(c.bg)
		love.graphics.rectangle('fill', x, bar_y, bar_w, Progress.BAR_HEIGHT, r, r)
	end

	c = getColorsForState('normal')
	love.graphics.setColor(c.fg)
	love.graphics.rectangle('line', x, bar_y, w, Progress.BAR_HEIGHT, r, r)
end

function Progress:__tostring()
	return F.describe('Progress', self)
end

function Progress:sizeThatFits(w, h)
	if w == math.huge then w = Progress.DEFAULT_WIDTH end
	if h == math.huge then h = Progress.BAR_HEIGHT end
	return w, h
end

--[[ SLIDER ]]--

local Slider = Control:extend()
Slider.BAR_HEIGHT = 10
Slider.KNOB_HEIGHT = 30
Slider.KNOB_WIDTH = 12
Slider.SPACING = 10
Slider.DEFAULT_WIDTH = 150

function Slider:new(opts)
	Control.new(self)

	local opts = opts or {}

	self.corner_radius = opts.corner_radius or 0
	self.min = opts.min or 0
	self.max = opts.max or 10
	self.step = opts.step or 20
	self.value = opts.value or 0
	self.font = parseFont(opts.font)

	self.text_size = getTextSize(tostring(self.max), self.font)
	self.text_size.w = self.text_size.w
end

function Slider:getValue()
	return self.min + self.value
end

function Slider:setValue(x)
	self.value = mmin(mmax(x, self.min), self.max) - self.min
end

function Slider:update(dt)
	Control.update(self, dt)

	if self.state == 'active' then
		local m_x, m_y = core.getMousePosition()
		self.value = round((m_x - self.frame.x) / (self.frame.w - self.text_size.w - Slider.SPACING) * self.step)
		self.value = math.min(self.value, self.max)
	end
end

function Slider:draw()
	local c = (self.state == 'active' and 
		getColorsForState('hovered') or 
		getColorsForState(self.state)
	)

	local x, y, w, h = self.frame:unpack()
	local r = self.corner_radius

	local bar_y = y + (h - Slider.BAR_HEIGHT) / 2
	local bar_step = (w - self.text_size.w - Slider.SPACING) / self.step
	local bar_w = self.value * bar_step

	-- draw bar fill based on current value
	if self.value > 0 then
		love.graphics.setColor(c.bg)
		love.graphics.rectangle('fill', x, bar_y, bar_w, Slider.BAR_HEIGHT, r, r)
	end

	-- draw bar outline
	love.graphics.setColor(c.fg)
	love.graphics.rectangle('line', x, bar_y, w - self.text_size.w - Slider.SPACING, Slider.BAR_HEIGHT, r, r)

	-- draw knob
	if self.state == 'active' or self.state == 'hovered' then
		c = getColorsForState(self.state)
		local knob_x = x + bar_w - Slider.KNOB_WIDTH / 2	
		love.graphics.setColor(c.bg)
		love.graphics.rectangle('fill', knob_x, y, Slider.KNOB_WIDTH, h, r, r)
		love.graphics.setColor(c.fg)
		love.graphics.rectangle('line', knob_x, y, Slider.KNOB_WIDTH, h, r, r)
	end

	-- draw value on right side
	if self.state == 'active' or self.state == 'hovered' then
		c = getColorsForState('normal')
	end	
	love.graphics.setColor(c.fg)
	love.graphics.setFont(self.font)
	love.graphics.printf(
		tostring(self.value),
		self.font,
		self.frame:maxX() - self.text_size.w,
		mfloor(self.frame.y + (self.frame.h - self.text_size.h) / 2),
		self.frame.w,
		self.align
	)			
end

function Slider:sizeThatFits(w, h)
	if w == math.huge then w = Slider.DEFAULT_WIDTH end
	if h == math.huge then h = mmax(Slider.KNOB_HEIGHT, self.text_size.h) end
	return w, h	
end

function Slider:__tostring()
	return F.describe('Slider', self)
end

--[[ INPUT ]]--

local Input = Control:extend()
Input.SPACING = 5
Input.DEFAULT_WIDTH = 150

function Input:new(opts)
	Control.new(self)

	local opts = opts or {}

	self.corner_radius = opts.corner_radius or 0
	self.text = opts.text or ''
	self.align = getAlignment(opts.align)
	self.font = parseFont(opts.font)
	self.text_size = getTextSize(self.text, self.font)

	self.cursor = mmax(1, utf8.len(self.text) + 1)
	self.draw_offset = 0
	-- cursor is position *before* the character (including EOS) i.e. in "hello":
	--   position 1: |hello
	--   position 2: h|ello
	--   ...
	--   position 6: hello|

	self.cursor_pos = 0
	if self.cursor > 1 then
		local s = self.text:sub(1, utf8.offset(self.text, self.cursor) - 1)
		self.cursor_pos = self.font:getWidth(s)
	end
end

function Input:hit()
	-- move cursor to mouse position
	self.cursor = utf8.len(self.text) + 1
	
	local x, _ = core.getMousePosition() - self.frame.x	
	for i = 1, utf8.len(self.text) + 1 do
		local s = self.text:sub(0, utf8.offset(self.text, i) - 1)
		if self.font:getWidth(s) >= x then
			self.cursor = i - 1
			break
		end
	end
end

function Input:update(dt)
	Control.update(self, dt)

	if self.cursor > 0 and core.getActive() == self then
		local s = self.text:sub(1, utf8.offset(self.text, self.cursor) - 1)
		self.cursor_pos = self.font:getWidth(s)
	else
		self.cursor_pos = 0
	end

	local wm = self.frame.w - Input.SPACING

	if self.cursor_pos - self.draw_offset < 0 then
		self.draw_offset = self.cursor_pos
	end
	if self.cursor_pos - self.draw_offset > wm then
		self.draw_offset = self.cursor_pos - wm
	end
	if self.text_size.w - self.draw_offset < wm and self.text_size.w > wm then
		self.draw_offset = self.text_size.w - wm
	end

	if self.cursor_pos < self.frame.w then
		self.draw_offset = 0
	end

	if core.getActive() ~= self then return end

	local keycode, char = core.getPressedKey()

	if char and char ~= '' then
		local a, b = split(self.text, self.cursor)
		self.text = tconcat({ a, char, b })
		self.cursor = self.cursor + utf8.len(char)
	end

	if keycode == 'backspace' then
		local a, b = split(self.text, self.cursor)
		self.text = tconcat({ split(a, utf8.len(a)), b })
		self.cursor = mmax(1, self.cursor - 1)
	elseif keycode == 'delete' then
		local a, b = split(self.text, self.cursor)
		local _, b = split(b, 2)
		self.text = tconcat({ a, b })
	end

	if keycode == 'left' then
		self.cursor = mmax(self.cursor - 1, 1)
	elseif keycode == 'right' then
		self.cursor = mmin(self.cursor + 1, utf8.len(self.text) + 1)
	elseif keycode == 'home' then
		self.cursor = 0
	elseif keycode == 'end' then
		self.cursor = utf8.len(self.text) + 1
	end
end

function Input:draw()
	local x, y, w, h = self.frame:unpack()
	local r = self.corner_radius

	-- draw fill
	local c = getColorsForState('normal')
	love.graphics.setColor(c.bg)
	love.graphics.rectangle('fill', x, y, w, h, r, r)

	-- draw outline
	local c = core.getActive() == self and
		getColorsForState('active') or 
		getColorsForState(self.state)
	love.graphics.setColor(c.fg)
	love.graphics.rectangle('line', x, y, w, h, r, r)

	-- set scissors
	local sx, sy, sw, sh = love.graphics.getScissor()
	love.graphics.setScissor(x - 1, y, w + 2, h)

	-- draw text
	local tx = mfloor(x - self.draw_offset + Input.SPACING)
	local ty = mfloor(y + (h - self.text_size.h) / 2)
	c = getColorsForState('normal')
	love.graphics.setColor(c.fg)
	love.graphics.setFont(self.font)
	love.graphics.print(self.text, tx, ty)	

	-- draw cursor
	if core.getActive() == self and (love.timer.getTime() % 1) > 0.5 then
		local c = self.text:sub(self.cursor - 1, self.cursor - 1)
		local ws = self.cursor == 1 and 0 or self.font:getWidth(c)

		if ws == 0 then x = x + Input.SPACING end

		local lw = love.graphics.getLineWidth()
		local ls = love.graphics.getLineStyle()
		
		love.graphics.setLineWidth(1)
		love.graphics.setLineStyle('rough')
		love.graphics.line(
			x + self.cursor_pos + ws / 2 - self.draw_offset, y + (h - self.text_size.h) / 2, 
			x + self.cursor_pos + ws / 2 - self.draw_offset, y + (h + self.text_size.h) / 2
		)
		love.graphics.setLineStyle(ls)
		love.graphics.setLineWidth(lw)
	end

	love.graphics.setScissor(sx, sy, sw, sh)
end

function Input:sizeThatFits(w, h)
	if w == math.huge then w = Input.DEFAULT_WIDTH end
	if h == math.huge then h = self.text_size.h + Input.SPACING * 2 end
	return w, h	
end

function Input:__tostring()
	return F.describe('Input', self)
end

--[[ MODULE ]]--

return {
    Control = Control,
    Label = Label,
    Button = function(...) return layout.Elem(Button(...)) end,
    ImageButton = ImageButton,
    Checkbox = Checkbox,
    Progress = Progress,
    Slider = Slider,
    Input = Input,
    Space = function(...) return layout.Elem(...) end,
}
