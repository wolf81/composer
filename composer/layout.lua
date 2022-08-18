local PATH = (...):match('(.-)[^%.]+$') 
local F = require(PATH .. 'functions')
local Object = require(PATH .. 'classic')
local Rect = require(PATH .. 'rect')
local attr = require(PATH .. 'attributes')

--[[ LAYOUT ]]--

local Layout = Object:extend()
local Cols = Layout:extend()
local Rows = Layout:extend()
local Elem = Layout:extend()

--[[ DUMMY ]]--

local Dummy = Object:extend()
function Dummy:draw() end
function Dummy:update(dt) end
function Dummy:layoutChildren() end
function Dummy:setFrame() end
function Dummy:sizeThatFits(w, h) return w, h end
function Dummy:__tostring() return F.describe('Dummy', self) end

--[[ COLS ]]--

function Cols:new(...)
	self.frame = Rect(0, 0, 0, 0)
	self.spacing = attr.Spacing(0)
	self.children = {}

	for _, arg in pairs({...}) do
		if arg.is ~= nil then
			if arg:is(attr.Spacing) then
				self.spacing = arg
			end
		else
			if type(arg) == 'table' then
				for _, child in ipairs(arg) do
					assert(child:is(Elem), 'child should be of type Elem')					
				end

				self.children = arg
			end
		end
	end
end

function Cols:layoutChildren()
	local fixed_w = math.max(#self.children - 1, 0) * self.spacing.v
	local flex_cols = 0
	local col_widths = {}

	-- calculate fixed width total and flex column count
	for idx, col in ipairs(self.children) do
		col_widths[idx] = col.size

		if col.size ~= math.huge then
			fixed_w = fixed_w + col.size
		else
			if col.child and not col.child:is(Dummy) then
				local cw, _ = col.child:sizeThatFits(col.size, math.huge)
				col_widths[idx] = cw
				fixed_w = fixed_w + cw
			else
				flex_cols = flex_cols + 1
			end
		end
	end

	-- calculate flex width for each flex column
	local x, y, w, h = self.frame.x, self.frame.y, self.frame.w, self.frame.h
	local flex_w = math.floor((w - fixed_w) / flex_cols)

	-- set column frames and update child layouts
	for idx, col in ipairs(self.children) do
		local w = col_widths[idx]
		if w == math.huge then w = flex_w end
		col.frame = Rect(x, y, w, h)
		col:layoutChildren()
		x = x + w + self.spacing.v
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

function Cols:sizeThatFits(w, h)
	local cw, ch = 0, 0

	for _, col in ipairs(self.children) do
		if col.size ~= math.huge then
			cw = cw + col.size
		elseif col.child and not col.child:is(Dummy) then
			local tw, th = col.child:sizeThatFits(w, h)
			cw = cw + tw
			ch = math.max(ch, th)
		end
	end

	return math.min(w, cw), math.min(ch, h)
end

function Cols:__tostring()
	return F.describe('Cols', self)
end

--[[ ROWS ]]--

function Rows:new(...)
	self.frame = Rect(0, 0, 0, 0)
	self.spacing = attr.Spacing(0)
	self.children = {}

	for _, arg in pairs({...}) do
		if arg.is ~= nil then
			if arg:is(attr.Spacing) then
				self.spacing = arg
			end
		else
			if type(arg) == 'table' then
				for _, child in ipairs(arg) do
					assert(child:is(Elem), 'child should be of type Elem')					
				end

				self.children = arg
			end
		end
	end
end

function Rows:layoutChildren()
	local fixed_h = math.max(#self.children - 1, 0) * self.spacing.v
	local flex_rows = 0
	local row_heights = {}

	-- calculate fixed height total and flex row count
	for idx, row in ipairs(self.children) do
		row_heights[idx] = row.size

		if row.size ~= math.huge then			
			fixed_h = fixed_h + row.size
		else
			if row.child and not row.child:is(Dummy) then
				local _, rh = row.child:sizeThatFits(math.huge, row.size)
				row_heights[idx] = rh
				fixed_h = fixed_h + rh
			else
				flex_rows = flex_rows + 1
			end
		end
	end

	-- calculate flex height for each flex row
	local x, y, w, h = self.frame.x, self.frame.y, self.frame.w, self.frame.h
	local flex_h = math.floor((h - fixed_h) / flex_rows)

	-- set row frames and update child layouts
	for idx, row in ipairs(self.children) do
		local h = row_heights[idx]
		if h == math.huge then h = flex_h end
		row.frame = Rect(x, y, w, h)
		row:layoutChildren()
		y = y + h + self.spacing.v
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

function Rows:sizeThatFits(w, h)
	local rw, rh = 0, 0

	for _, row in ipairs(self.children) do
		if row.size ~= math.huge then
			rh = rh + row.size
		elseif row.child and not row.child:is(Dummy) then
			local tw, th = row.child:sizeThatFits(w, h)
			rh = rh + th
			rw = math.max(rw, tw)
		end
	end

	return math.min(w, rw), math.min(rh, h)
end

function Rows:__tostring()
	return F.describe('Rows', self)
end

--[[ LAYOUT ]]--

function Layout:new(...)
	self.size = math.huge
	self.frame = Rect(0, 0, 0, 0)
	self.child = Dummy()
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
	self.child:update(dt)
end

function Layout:draw()
	-- local l = love.graphics.getLineWidth()
	-- love.graphics.setColor(unpack(self.color))
	-- local x, y, w, h = self.frame:unpack()
	-- love.graphics.rectangle('line', x + l / 2, y + l / 2, math.max(w - l, 0), math.max(h - l, 0))

	self.child:draw()
end

function Layout:__tostring()
	return F.describe('Layout', self)
end

--[[ ELEM ]]--

function Elem:layoutChildren()
	if self.child then
		if self.child:is(Layout) then
			self.child.frame = self.frame
			self.child:layoutChildren()
		else
			-- either Control or Dummy
			local x, y, w, h = self.frame:unpack()
			self.child:setFrame(x, y, w, h)
		end
	end
end

function Elem:__tostring()
	return F.describe('Elem', self)
end

--[[ MODULE ]]--

return {
	Layout = Layout,
	Rows = Rows,
	Cols = Cols,
	Elem = Elem,
}
