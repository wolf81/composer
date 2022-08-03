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

local Size = {}

function Size:new(x, y)
	x = x or 0
	y = y or x
	
	return setmetatable({
		x = x,
		y = y,
	}, Size)
end

function Size:__tostring()
	return F.describe("Size", self)
end

setmetatable(Size, {
	__call = Size.new
})

--[[
--	Module
--]]

return {
	ID = ID,
	Margin = Margin,
	Size = Size,
}

-- 