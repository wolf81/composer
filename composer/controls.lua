local PATH = (...):match('(.-)[^%.]+$') 
local Object = require(PATH .. 'classic')
local F = require(PATH .. 'functions')

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

--[[ BUTTON ]]--

local Button = Control:extend()

function Button:__tostring()
	return F.describe('Button', self)
end

--[[ MODULE ]]--

return {
    Control = Control,
    Button = Button,
}

--[[
local Control = require "src.ui.control"
local Point = require "src.ui.point"
local Core = require "src.ui.core"

local mfloor, mceil = math.floor, math.ceil

local Button = {}

function Button.new()
	local self = Control()

	-- normal, disabled, highlighted, selected

	local is_highlighted = false
	local is_selected = false

	local is_hit = false
	local is_sticky = false -- TODO: need better name here, stick scroll

	local font = love.graphics.getFont()
	local text_size = Point(0, 0)

	local title = ""

	local needs_update = false

	local action = function() end

	local baseUpdate = self.update
	function self.update(dt)
		baseUpdate()

		if needs_update then
			text_size.x = font:getWidth(title)
			text_size.y = font:getHeight()
			needs_update = false
		end

		if not self.isEnabled() then return end

		local frame = self.getFrame()
		
		local m_x, m_y = love.mouse.getPosition()
		local x, y = frame:origin()
		local w, h = frame:size()

		-- check if the user is currently interacting with this control
		local active = Core.getActive()
		if active ~= nil and active ~= self then return end

		is_highlighted = frame:containsPoint(m_x, m_y)
		local is_press = (is_highlighted or is_sticky and active) and love.mouse.isDown(1)
		is_hit = is_highlighted and is_selected and not is_press
		is_selected = is_press

		-- if this control is highlighted and pressed, make it the active control
		if is_selected then
			Core.setActive(self)
		end

		if is_hit then action() end

		-- keep a sticky highlight on this control if it's currently active
		is_highlighted = is_highlighted or active == self
	end

	local baseDraw = self.draw
	function self.draw()
		baseDraw()

		local state = "normal"

		if not self.isEnabled() then
			state = "disabled"
		elseif is_selected then 
			state = "active"
		elseif is_highlighted then
			state = "hovered"
		end

		local frame = self.getFrame()
		local x, y = frame:origin()
		local w, h = frame:size()

		local theme = self.getTheme()
		local c = Core.getColors(theme, state)
		love.graphics.setColor(unpack(c.bg))
		love.graphics.rectangle("fill", x + 0.5, y + 0.5, w, h)

		love.graphics.setColor(unpack(c.fg))
		love.graphics.rectangle("line", x + 0.5, y + 0.5, w, h)

		-- draw text
		love.graphics.setFont(font)
		love.graphics.print(
			title, 
			mfloor(frame:getMidX()), 
			mfloor(frame:getMidY()), 
			0, 1, 1, 
			mceil(text_size.x / 2), 
			mceil(text_size.y / 2)
		)		
	end

	function self.setTitle(new_title)
		title = new_title or ""
		needs_update = true
	end

	function self.getTitle()
		return title
	end

	-- probably a state flags function would be nicer
	-- instead of separate functions for enabled, highlighted, selected, ...

	function self.setHighlighted(highlighted)
		is_highlighted = highlighted
	end

	function self.isHighlighted()
		return is_highlighted
	end

	function self.setSelected(selected)
		is_selected = selected
	end

	function self.isSelected()
		return is_selected
	end

	function self.setFont(new_font)
		font = new_font or love.graphics.getFont()
		needs_update = true
	end

	function self.getFont()
		return font
	end

	function self.setSticky(sticky)
		is_sticky = sticky
	end

	function self.isSticky()
		return is_sticky
	end

	function self.isHit()
		return is_hit
	end

	function self.setAction(fn)
		action = fn or function() end
	end

	return self
end

return setmetatable(Button, {
	__call = Button.new,
})
]]