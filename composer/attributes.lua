local _PATH = (...):match("(.-)[^%.]+$") 
local F = require(_PATH .. "functions")

--[[
--	ID
--	Use the ID attribute to assign an identifier to an element. This identifier
--	can be used to easily retrieve an element from the layout.
--]]

local ID = {}

function ID:new(value)
	return setmetatable({ 
		value = value 
	}, ID)
end

function ID:__tostring()
	return F.describe("ID", self)
end

setmetatable(ID, {
	__call = ID.new
})

--[[
--	Margin
--	The Margin attribute is only used by the Border element and defines spacing
--	between the Border and it's child element. The arguments are defined in 
--	order left, top, right, bottom.
--
--	Examples:
--	* Margin()				=> Margin(0, 0, 0, 0)
--	* Margin(5)				=> Margin(5, 5, 5, 5)
--	* Margin(5, 10)			=> Margin(5, 10, 5, 10)
--	* Margin(5, 10, 8)		=> Margin(5, 10, 8, 0)
--	* Margin(5, 10, 8, 6)
--]]

local Margin = {}

function Margin:new(l, t, r, b)
	l = l or 0
	r = r or l
	t = t or r
	b = b or t

	return setmetatable({
		l = l,
		r = r,
		t = t,
		b = b,
	}, Margin)
end

function Margin:__tostring()
	return F.describe("Margin", self)
end

setmetatable(Margin, {
	__call = Margin.new
})

--[[
--	MinSize
--	Use the MinSize attribute to specify a minimum size of an element in pixels.
--
--	Examples:
--	* MinSize()				=> MinSize(0, 0)
--	* MinSize(10) 			=> MinSize(10, 10)
--	* MinSize(10, 50)
--]]

local MinSize = {}

function MinSize:new(x, y)
	x = x or 0
	y = y or x
	
	return setmetatable({
		x = x,
		y = y,
	}, MinSize)
end

function MinSize:__tostring()
	return F.describe("MinSize", self)
end

setmetatable(MinSize, {
	__call = MinSize.new
})

--[[
--	ExpSize
--	The ExpSize attribute is only meant for internal use. This attribute 
--	represents the expanded size of the element taking into account MinSize, 
--	Stretch and Margin attributes.
--]]

local ExpSize = {}

function ExpSize:new(x, y)
	return setmetatable({
		x = x,
		y = y,
	}, ExpSize)
end

function ExpSize:__tostring()
	return F.describe("ExpSize", self)
end

setmetatable(ExpSize, {
	__call = ExpSize.new
})

--[[
--	Size
]]

local Size = {}

function Size:new(x)
	return setmetatable({
		value = x or math.huge
	}, Size)
end

function Size:__tostring()
	return F.describe('Size', self)
end

setmetatable(Size, {
	__call = Size.new
})

--[[
--	Spacing
]]

local Spacing = {}

function Spacing:new(x)
	return setmetatable({
		value = x or 0
	}, Spacing)
end

function Spacing:__tostring()
	return F.describe('Spacing', self)
end

setmetatable(Spacing, {
	__call = Spacing.new
})

--[[
--	Stretch
--	The Stretch attribute defines how an element stretches inside its container. 
--	The x and y value should either be 0 to not expand MinSize or 1 to stretch 
--	to expand to the full size of the container. 
--
--	Examples:
--	* Stretch()				=> Stretch(0, 0)
--	* Stretch(1)			=> Stretch(1, 1)
--	* Stretch(0, 1)
--]]

local Stretch = {}

function Stretch:new(x, y)
	x = x or 0
	y = y or x

	return setmetatable({
		x = x,
		y = y,
	}, Stretch)
end

function Stretch:__tostring()
	return F.describe("Stretch", self)
end

setmetatable(Stretch, {
	__call = Stretch.new
})

--[[
--	Module
--]]

return {
	ID = ID,
	Margin = Margin,
	MinSize = MinSize,
	ExpSize = ExpSize,
	Stretch = Stretch,
	Spacing = Spacing,
	Size = Size,
}

-- 