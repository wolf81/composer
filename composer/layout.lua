local PATH = (...):match('(.-)[^%.]+$') 
local F = require(PATH .. 'functions')
local Object = require(PATH .. 'classic')
local Rect = require(PATH .. 'rect')

--[[ LAYOUT ]]--

local Layout = Object:extend()
local Cols = Layout:extend()
local Col = Layout:extend()
local Rows = Layout:extend()
local Row = Layout:extend()

local Dummy = Object:extend()
function Dummy:draw() end
function Dummy:update(dt) end

function Cols:new(children)
	Layout.new(self, children)

	assert(children ~= nil)

	self.frame = Rect(0, 0, 0, 0)

	for _, child in ipairs(children) do
		assert(child:is(Col), 'child should be of type Col')
	end

	self.children = children
end

function Cols:layout()
	local fixed_w = 0
	local flex_cols = 0

	for _, col in ipairs(self.children) do
		if col.size ~= math.huge then
			fixed_w = fixed_w + col.size
		else
			flex_cols = flex_cols + 1
		end
	end

	local x, y, w, h = self.frame.x, self.frame.y, self.frame.w, self.frame.h
	local flex_w = math.floor((w - fixed_w) / flex_cols)
	print('flex_w', flex_w)

	for _, child in ipairs(self.children) do
		local w = child.size == math.huge and flex_w or child.size
		child.frame = Rect(x, y, w, h)
		print('ch', child)
		child:layout()
		print('layout', child)
		x = x + w
	end
end

function Cols:update(dt)
	for _, child in ipairs(self.children) do
		child:update(dt)
	end
end

function Cols:draw()
	for _, child in ipairs(self.children) do
		child:draw()
	end
end

function Cols:__tostring()
	return F.describe('Cols', self)
end

function Rows:new(children)
	assert(children ~= nil)

	self.frame = Rect(0, 0, 0, 0)

	for _, child in ipairs(children) do
		assert(child:is(Row), 'child should be of type Row')
	end

	self.children = children
end

function Rows:layout()
	local fixed_h = 0
	local flex_rows = 0

	print('total_h', self.frame.h)

	for _, row in ipairs(self.children) do
		if row.size ~= math.huge then			
			fixed_h = fixed_h + row.size
		else
			flex_rows = flex_rows + 1
		end
	end

	local x, y, w, h = self.frame.x, self.frame.y, self.frame.w, self.frame.h
	local flex_h = math.floor((h - fixed_h) / flex_rows)

	for _, child in ipairs(self.children) do
		local h = child.size == math.huge and flex_h or child.size
		child.frame = Rect(x, y, w, h)
		child:layout()
		y = y + h
	end
end

function Rows:update(dt)
	for _, child in ipairs(self.children) do
		child:update(dt)
	end
end

function Rows:draw()
	for _, child in ipairs(self.children) do
		child:draw()
	end
end

function Rows:__tostring()
	return F.describe('Rows', self)
end

function Layout:new(...)
	self.size = math.huge
	self.frame = Rect(0, 0, 0, 0)
	self.child = Dummy()
    self.color = F.randomColor()

	for _, arg in ipairs({...}) do
		if arg == nil then goto continue end

		if type(arg) == 'number' then
			self.size = arg
		else
			self.child = arg
		end

		::continue::
	end
end

function Layout:resize(w, h)
	self.frame = Rect(self.frame.x, self.frame.y, w, h)
	self:layout()
end

function Layout:layout()
	if not self.child then return end

	self.child.frame = self.frame
	self.child:layout()
	print(self.child)
end

function Layout:update(dt)
	if not self.child then return end
	self.child:update(dt)
end

function Layout:draw()
	self.child:draw()

	local l = love.graphics.getLineWidth()

	love.graphics.setColor(unpack(self.color))
	local x, y, w, h = self.frame:unpack()
	love.graphics.rectangle('line', x + l / 2, y + l / 2, math.max(w - l, 0), math.max(h - l, 0))
end

function Layout:__tostring()
	return F.describe('Layout', self)
end

--[[ COL ]]--


function Col:layout()
	if self.child then
		if self.child:is(Layout) then
			self.child.frame = self.frame
			self.child:layout()
		else
			self.child.frame = { self.frame:unpack() }
		end
	end
end

function Col:__tostring()
	return F.describe('Col', self)
end

--[[ ROW ]]--

function Row:layout()
	if self.child then
		if self.child:is(Layout) then
			self.child.frame = self.frame
			self.child:layout()
		else
			self.child.frame = { self.frame:unpack() }
		end
	end
end

function Row:__tostring()
	return F.describe('Row', self)
end

--[[ MODULE ]]--

return {
	Layout = Layout,
	Rows = Rows,
	Row = Row,
	Cols = Cols,
	Col	= Col,
}
