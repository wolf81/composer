local PATH = (...):match('(.-)[^%.]+$') 
local F = require(PATH .. 'functions')
local Object = require(PATH .. 'classic')
local Rect = require(PATH .. 'rect')
local attr = require(PATH .. 'attributes')

--[[ LAYOUT ]]--

local Layout = Object:extend()
local Elem = Layout:extend()
local Stack = Layout:extend()
local HStack = Stack:extend()
local VStack = Stack:extend()

--[[ STACK ]]--

function Stack:new(...)
	self.frame = Rect(0, 0, 0, 0)
	self.spacing = attr.Spacing(0)
	self.children = {}
	self.size = math.huge

	for _, arg in pairs({...}) do
		if type(arg) == 'number' then
			self.size = arg
		elseif arg.is ~= nil then
			if arg:is(attr.Spacing) then
				self.spacing = arg
			end
		else
			if type(arg) == 'table' then
				for _, child in ipairs(arg) do
					assert(child:is(Layout), 'child should be of type Elem')					
				end

				self.children = arg
			end
		end
	end
end

function Stack:update(dt)
	for _, child in ipairs(self.children) do
		child:update(dt)
	end
end

function Stack:draw()
	for _, child in ipairs(self.children) do
		child:draw()
	end
end

--[[ HStack ]]--

function HStack:layoutChildren()
	local fixed_w = math.max(#self.children - 1, 0) * self.spacing.v
	local flex_children = 0
	local child_widths = {}

	-- calculate fixed width total and flex child count
	for idx, child in ipairs(self.children) do
		child_widths[idx] = child.size

		if child:is(VStack) then
			local cw, _ = child:sizeThatFits(child.size, math.huge)
			child_widths[idx] = cw
			fixed_w = fixed_w + cw
		elseif child.size ~= math.huge then
			fixed_w = fixed_w + child.size
		else
			if child.child or child.children then
				local cw, _ = child:sizeThatFits(child.size, math.huge)
				child_widths[idx] = cw
				fixed_w = fixed_w + cw
			else
				flex_children = flex_children + 1
			end
		end
	end

	-- calculate flex width for each flex children
	local x, y, w, h = self.frame.x, self.frame.y, self.frame.w, self.frame.h
	local flex_w = math.floor((w - fixed_w) / flex_children)

	-- set childumn frames and update child layouts
	for idx, child in ipairs(self.children) do
		local w = child_widths[idx]
		if w == math.huge then w = flex_w end
		child.frame = Rect(x, y, w, h)
		child:layoutChildren()
		x = x + w + self.spacing.v
	end
end

function HStack:sizeThatFits(w, h)
	local cw, ch = 0, 0

	cw = cw + math.max(#self.children - 1, 0) * self.spacing.v

	if self.size ~= math.huge then ch = self.size end

	for _, child in ipairs(self.children) do
		if child:is(VStack) then
			local tw, th = child:sizeThatFits(w, h)
			cw = cw + tw
			ch = math.max(ch, th)			
		elseif child.size ~= math.huge then
			cw = cw + child.size
		elseif child.child then
			local tw, th = child:sizeThatFits(w, h)
			cw = cw + tw
			ch = math.max(ch, th)
		end
	end

	return math.min(w, cw), math.min(ch, h)
end

function HStack:__tostring()
	return F.describe('HStack', self)
end

--[[ VStack ]]--

function VStack:layoutChildren()
	local fixed_h = math.max(#self.children - 1, 0) * self.spacing.v
	local flex_children = 0
	local child_heights = {}

	-- calculate fixed height total and flex child count
	for idx, child in ipairs(self.children) do
		child_heights[idx] = child.size

		if child:is(HStack) then
			local _, rh = child:sizeThatFits(math.huge, child.size)
			child_heights[idx] = rh
			fixed_h = fixed_h + rh
		elseif child.size ~= math.huge then			
			fixed_h = fixed_h + child.size
		else
			if child.child or child.children then
				local _, rh = child:sizeThatFits(math.huge, child.size)
				child_heights[idx] = rh
				fixed_h = fixed_h + rh
			else
				flex_children = flex_children + 1
			end
		end
	end

	-- calculate flex height for each flex child
	local x, y, w, h = self.frame.x, self.frame.y, self.frame.w, self.frame.h
	local flex_h = math.floor((h - fixed_h) / flex_children)

	-- set child frames and update child layouts
	for idx, child in ipairs(self.children) do
		local h = child_heights[idx]
		if h == math.huge then h = flex_h end
		child.frame = Rect(x, y, w, h)
		child:layoutChildren()
		y = y + h + self.spacing.v
	end
end

function VStack:sizeThatFits(w, h)
	local rw, rh = 0, 0

	if self.size ~= math.huge then rw = self.size end

	rh = rh + math.max(#self.children - 1, 0) * self.spacing.v

	for _, child in ipairs(self.children) do
		local tw, th = child:sizeThatFits(w, h)

		if child:is(HStack) then
			rh = rh + th
			rw = math.max(rw, tw)
		elseif child.size ~= math.huge then
			rh = rh + child.size
			rw = math.max(rw, tw)
		elseif child.child then
			rh = rh + th
			rw = math.max(rw, tw)
		end
	end

	return math.min(w, rw), math.min(rh, h)
end

function VStack:__tostring()
	return F.describe('VStack', self)
end

--[[ LAYOUT ]]--

function Layout:new(...)
	self.size = math.huge
	self.frame = Rect(0, 0, 0, 0)
	self.child = nil
    self.color = F.randomColor()
    self.margin = attr.Margin(0)

	for _, arg in ipairs({...}) do
		if arg == nil then goto continue end

		if type(arg) == 'number' then
			self.size = arg
		elseif arg.is ~= nil then
			if arg:is(attr.Margin) then
				self.margin = arg
			else
				self.child = arg				
			end
		end

		::continue::
	end
end

function Layout:resize(w, h)
	self.frame = Rect(self.frame.x, self.frame.y, w, h):inset(self.margin:unpack())
	self:layoutChildren()
end

function Layout:layoutChildren()
	self.child.frame = self.frame
	self.child:layoutChildren()
end

function Layout:update(dt)
	if not self.child then return end

	self.child:update(dt)
end

function Layout:draw()
	if not self.child then return end

	local l = love.graphics.getLineWidth()
	love.graphics.setColor(unpack(self.color))
	local x, y, w, h = self.frame:unpack()
	love.graphics.rectangle('line', x + l / 2, y + l / 2, math.max(w - l, 0), math.max(h - l, 0))

	self.child:draw()
end

function Layout:__tostring()
	return F.describe('Layout', self)
end

--[[ ELEM ]]--

function Elem:new(T, ...)
	Layout.new(self, ...)

	local args = {...}

	F.removeMatch(args, function(v) return type(v) == 'number' end)
	F.removeMatch(args, function(v) return v.is ~= nil and type(v) == 'function' and v:is(Margin) end)
	F.removeMatch(args, function(v) return v.is ~= nil and type(v) == 'function' and v:is(Spacing) end)

	local opts = F.removeMatch(args, function(v) return v.is == nil end)

	self.child = T and T(opts or {})
end

function Elem:layoutChildren()
	if self.child then
		if self.child:is(Layout) then
			self.child.frame = self.frame
			self.child:layoutChildren()
		else
			local x, y, w, h = self.frame:unpack()
			self.child:setFrame(x, y, w, h)
		end
	end
end

function Elem:sizeThatFits(w, h)
	if self.child then return self.child:sizeThatFits(w, h) end

	return w, h
end

function Elem:__tostring()
	return F.describe('Elem', self)
end

--[[ MODULE ]]--

return {
	Layout = Layout,
	VStack = VStack,
	HStack = HStack,
	Elem = Elem,
}
