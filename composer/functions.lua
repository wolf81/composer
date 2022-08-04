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

-- the module
return {
	randomColor = randomColor,
	removeMatch = removeMatch,
	describe = describe,
}