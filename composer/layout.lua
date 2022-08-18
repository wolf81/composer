local _PATH = (...):match("(.-)[^%.]+$") 
local attr = require(_PATH .. "attributes")
local F = require(_PATH .. "functions")

local Stretch = attr.Stretch
local MinSize = attr.MinSize
local Margin = attr.Margin
local ExpSize = attr.ExpSize
local Size = attr.Size
local ID = attr.ID

--[[
--	Rect
--]]

local Rect = {}
Rect.__index = Rect

function Rect:new(x, y, w, h)
	return setmetatable({
		x = x,
		y = y,
		w = w, 
		h = h,
	}, Rect)
end

function Rect:__tostring()
	return F.describe("Rect", self)
end

setmetatable(Rect, {
	__call = Rect.new
})

--[[
--	Layout
--]] 

local Layout = {}
Layout.__index = Layout

function Layout:new(...)
	local stretch = Stretch(1, 1)
	local min_size = MinSize(0, 0)
	local children = {}

	for _, arg in ipairs({...}) do
		if getmetatable(arg) == Stretch then
			stretch = arg
		elseif getmetatable(arg) == MinSize then
			min_size = arg
		elseif type(arg) == "table" then
			children = arg
		end
	end

	return setmetatable({
		stretch = stretch,
		min_size = min_size,
		children = children,
		exp_size = nil,
		rect = Rect(0, 0, 0, 0),
	}, Layout)
end

function Layout:reshape(x, y, w, h)
	self:expand()
	self:layout(Rect(x, y, w, h))
end

function Layout:expand()
	for _, child in ipairs(self.children) do
		child:expand()
	end

	self:expandChildren()
end

function Layout:expandChildren()
	error("implementation required by subclasses")
end

function Layout:layout(rect)
	self:layoutChildren(rect)
	for _, child in ipairs(self.children) do
		child:layout(child.rect)
	end
end

function Layout:layoutChildren(rect)
	error("implementation required by subclasses")
end

function Layout:__tostring()
	return F.describe("Layout", self)
end

setmetatable(Layout, {
	__call = Layout.new,
})

--[[
--	Border
--	A Border element can be used to add a margin around a child element. The 
--	Border element should only contain a single child element.
--]]

local Border = {}
Border.__index = Border

function Border:new(...)
	local args = {...}

	local margin = F.removeMatch(args, function(v)
		return getmetatable(v) == Margin
	end)

	local this = Layout.new(self, unpack(args))

	this.margin = margin or Margin(0)

	return setmetatable(this, Border)
end

function Border:expandChildren()
	local w, h = self.margin.l + self.margin.r, self.margin.t + self.margin.b
	for _, child in ipairs(self.children) do
		w = math.max(w, child.exp_size.x)
		h = math.max(h, child.exp_size.y)
	end
	self.exp_size = ExpSize(w, h)
end

function Border:layoutChildren(rect)
	for _, child in ipairs(self.children) do 
		child.rect = Rect(
			rect.x + self.margin.l, 
			rect.y + self.margin.t, 
			rect.w - self.margin.l - self.margin.r,
			rect.h - self.margin.t - self.margin.b
		)
	end
end

function Border:__tostring()
	return F.describe("Border", self)
end

setmetatable(Border, {
	__index = Layout,
	__call = Border.new,
})

--[[
--	HStack
--	A HStack element can contain multiple child elements that will be arranged
--	horizontally.
--]]

local HStack = {}
HStack.__index = HStack

function HStack:new(...)
	local this = Layout.new(self, ...)

	return setmetatable(this, HStack)
end

function HStack:expandChildren()
	local w, h = 0, 0
	for _, child in ipairs(self.children) do
		w = w + child.exp_size.x
		h = math.max(h, child.exp_size.y)
	end
	self.exp_size = ExpSize(w, h)
end

function HStack:layoutChildren(rect)
	local x, y, h = rect.x, rect.y, 0
	local ch_widths = {}
	for _, child in ipairs(self.children) do
		ch_widths[#ch_widths + 1] = { child.exp_size.x, child.stretch.x }
	end
	
	if #ch_widths > 0 then
		ch_widths = F.spread(rect.w, unpack(ch_widths))
	end

	local results = F.zip(self.children, ch_widths)
	for _, result in ipairs(results) do
		local ch, w = unpack(result)

		if ch.stretch.y == 1 then 
			h = rect.h
		else
			h = ch.exp_size.y
		end
		ch.rect = Rect(x, y, w - 1, h)

		x = x + w
	end
end

function HStack:__tostring()
	return F.describe("HStack", self)
end

setmetatable(HStack, {
	__index = Layout,
	__call = HStack.new
})

--[[
--	VStack
--	A VStack element can contain multiple child elements that will be arranged
--	vertically.
--]]

local VStack = {}
VStack.__index = VStack

function VStack:new(...)
	local this = Layout.new(self, ...)

	return setmetatable(this, VStack)
end

function VStack:expandChildren()
	local w, h = 0, 0
	for _, child in ipairs(self.children) do
		w = math.max(w, child.exp_size.x)
		h = h + child.exp_size.y
	end
	self.exp_size = ExpSize(w, h - 1)
end

function VStack:layoutChildren(rect)
	local x, y, w = rect.x, rect.y, 0
	local ch_heights = {}
	for _, child in ipairs(self.children) do
		ch_heights[#ch_heights + 1] = { child.exp_size.y, child.stretch.y }
	end
	
	if #ch_heights > 0 then
		ch_heights = F.spread(rect.h, unpack(ch_heights))
	end

	local results = F.zip(self.children, ch_heights)
	for _, result in ipairs(results) do
		local ch, h = unpack(result)

		if ch.stretch.x ~= 0 then 
			w = rect.w
		else
			w = ch.exp_size.x
		end
		ch.rect = Rect(x, y, w, h - 1)

		y = y + h
	end
end

function VStack:__tostring()
	return F.describe("VStack", self)
end

setmetatable(VStack, {
	__index = Layout,
	__call = VStack.new,
})

--[[
--	Elem
--	An Elem element can be contained in a VStack, HStack or Border. A custom 
--	widget can be assigned to an element. 
--]]

local Elem = {}
Elem.__index = Elem

function Elem:new(widget, ...)
	local args = { ... }

	local id = F.removeMatch(args, function(v)
		return getmetatable(v) == ID
	end)

	local this = Layout.new(self, unpack(args))
	
	this.id = id
	this.rect = Rect(0, 0, 0, 0)
	this.widget = widget

	return setmetatable(this, Elem)
end

function Elem:expandChildren()
	self.exp_size = self.min_size
end

function Elem:layoutChildren(rect)
	-- body
end

function Elem:__tostring()
	return F.describe("Elem", self)
end

setmetatable(Elem, {
	__index = Layout,
	__call = Elem.new,
})

--[[
--	The module
--]]

return {
	Rect = Rect,
	Border = Border,
	HStack = HStack,
	VStack = VStack,
	Elem = Elem,
}