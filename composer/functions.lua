local function sum(tbl)
	local total = 0
	for _, v in ipairs(tbl) do
		total = total + v
	end
	return total
end

-- source: https://gist.github.com/w13b3/5d8a80fae57ab9d51e285f909e2862e0
function zip(...)
	local idx, ret, args = 1, {}, {...}
	
	while true do -- loop smallest table-times
		local sub_table = {} 
		for _, table_ in ipairs(args) do
			value = table_[idx] -- becomes nil if index is out of range
			if value == nil then break end -- break for-loop
			table.insert(sub_table, value)
		end
		if value == nil then break end -- break while-loop
		table.insert(ret, sub_table) -- insert the sub result
		idx = idx + 1
	end 	

	return ret
end

local function spread(target_size, ...)
	local sizes, stretches = unpack(zip(...))
	local fixed_size = sum(sizes)
	local flexy_size = math.max(0, target_size - fixed_size)
	local num_flexy_parts = sum(stretches)

	local flexy_add = 0
	if num_flexy_parts > 0 then
		flexy_add = math.floor(flexy_size / num_flexy_parts)
	end

	local flexy_adds = {}
	for i, st in ipairs(stretches) do
		flexy_adds[#flexy_adds + 1] = st * flexy_add
	end

	local flexy_err = flexy_size - sum(flexy_adds)
	if flexy_err ~= 0 then
		local v = stretches[#stretches]

		for i = #stretches, 0, -1 do
			if i ~= 0 then
				flexy_adds[i] = flexy_adds[i] + flexy_err
				break
			end
		end

		for _, stretch in ipairs(stretches) do
			if flexy_err == 0 then break end
		end
	end

	local spreads = {}
	for _, sz_fa in ipairs(zip(sizes, flexy_adds)) do
		spreads[#spreads + 1] = sum(sz_fa)
	end
	
	return spreads
end

-- reverse ipairs
local function ripairs(tbl)	
	local iter = function(t, i)
		if i == 0 then return nil end

		i = i - 1
		return i, t[i]
	end

	return iter, tbl, #tbl
end

-- remove a value from a table if function fn returns true
local function removeMatch(tbl, fn)
	for i, value in ripairs(tbl) do
		if fn(value) then
			table.remove(tbl, i)
			return value
		end
	end
end

-- the module
return {
	zip = zip,
	spread = spread,
	removeMatch = removeMatch,
}