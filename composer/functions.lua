local mrandom = math.random

local function describe(name, tbl)
	local values = {}
	for k, v in pairs(tbl) do
		values[#values + 1] = k .. " = " .. tostring(v)
	end

	return name .. " { " .. table.concat(values, ", ") .. " }"
end

local function randomColor()
    return { mrandom(255) / 255, mrandom(255) / 255, mrandom(255) / 255 }
end

local function isArray(table)
	if type(table) ~= 'table' then
		return false
	end

	-- objects always return empty size
	if #table > 0 then
		return true
	end

	-- only object can have empty length with elements inside
	for k, v in pairs(table) do
		return false
	end

	-- if no elements it can be array and not at same time
	return true
end

-- the module
return {
	randomColor = randomColor,
	isArray = isArray,
	describe = describe,
}