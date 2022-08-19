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

-- remove a value from a table if function fn returns true
local function removeMatch(tbl, fn)
	for i = #tbl, 1, -1 do
		local value = tbl[i]
		if fn(value) then			
			return table.remove(tbl, i)
		end
	end
end

-- the module
return {
	randomColor = randomColor,
	removeMatch = removeMatch,
	isArray = isArray,
	describe = describe,
}