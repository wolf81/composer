local PATH = (...):match('(.-)[^%.]+$') 
local F = require(PATH .. 'functions')
local Object = require(PATH .. 'classic')
local Rect = require(PATH .. 'rect')

--[[ LAYOUT ]]--

local Layout = Object:extend()
local Cols = Object:extend()
local Col = Layout:extend()
local Rows = Object:extend()
local Row = Layout:extend()

function Cols:new(children)
	assert(children ~= nil)

	for _, child in ipairs(children) do
		assert(child:is(Col), 'child should be of type Col')
	end

	self.children = children
end

function Rows:new(children)
	assert(children ~= nil)

	for _, child in ipairs(children) do
		assert(child:is(Row), 'child should be of type Row')
	end

	self.children = children
end

function Layout:new(...)
	self.size = math.huge
	self.frame = Rect(0, 0, 0, 0)
	self.children = {}
    self.color = F.randomColor()

	for _, arg in ipairs({...}) do
		local arg_type = type(arg)

		if type(arg) == 'number' then
			self.size = arg
		else
			if arg.is ~= nil then
				if arg:is(Cols) or arg:is(Rows) then
					self.children = arg.children
				end
			end
		end
	end
end

function Layout:resize(w, h)
	self.frame = Rect(self.frame.x, self.frame.y, w, h)
	self:layout()
end

function Layout:layout()
	local max_s = nil
	local tot_s = 0
	local spread_cnt = 0
	local o = nil

	for _, child in ipairs(self.children) do
		if child:is(Col) then
			print('child col')
			o = 'h'
			max_s = self.frame.w
		elseif child:is(Row) then
			print('child row')
			max_s = self.frame.h
			o = 'v'
		end

		if child.size ~= math.huge then
			tot_s = tot_s + child.size
		else
			spread_cnt = spread_cnt + 1
		end
	end

	local spread_s = math.floor((max_s - tot_s) / spread_cnt)

	if o == 'h' then
		local x, y, h = self.frame.x, self.frame.y, self.frame.h
		for _, child in ipairs(self.children) do
			local s = child.size ~= math.huge and child.size or spread_s
			child.frame = Rect(x, y, s, h)
			x = x + s

			child:layout()
		end
	elseif o == 'v' then

	else error() end
end

function Layout:update(dt)
	for _, child in ipairs(self.children) do
		child:update(dt)
	end
end

function Layout:draw()
	for _, child in ipairs(self.children) do
		child:draw()
	end

	local l = love.graphics.getLineWidth()

	love.graphics.setColor(unpack(self.color))
	local x, y, w, h = self.frame:unpack()
	love.graphics.rectangle('line', x + l / 2, y + l / 2, math.max(w - l, 0), math.max(h - l, 0))
end

--[[ COL ]]--


function Col:layout()
	local max_s = self.size
	local child_s = 0

	local spread_cnt = 0

	for _, child in ipairs(self.children) do
		if child.size ~= math.huge then
			child_s = child_s + child.size
		else
			spread_cnt = spread_cnt + 1
		end
	end

	local spread_amount = math.floor((max_s - child_s) / spread_cnt)
	local x, y, h = 0, self.frame.y, self.frame.h

	for _, child in ipairs(self.children) do
		if child.size == math.huge then
			child.size = spread_amount
		end

		child.x = x
		child.y = y

		child:resize()

		child.frame = Rect(x, y, child.size, h)
		print('>', child.frame)
		x = x + child.size
	end
end

--[[ ROW ]]--

--[[ MODULE ]]--

return {
	Layout = Layout,
	Rows = Rows,
	Row = Row,
	Cols = Cols,
	Col	= Col,
}
