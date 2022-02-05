local layout = require "src.layout.layout"

-- the default imports from the layout engine.
local DEFAULT_IMPORTS = [[
	local attr = require "src.layout.attributes"
	local Margin = attr.Margin
	local Stretch = attr.Stretch
	local MinSize = attr.MinSize
	local ID = attr.ID

	local layout = require "src.layout.layout"
	local Border = layout.Border
	local VStack = layout.VStack
	local HStack = layout.HStack
	local Elem = layout.Elem
]]

-- this pattern matches the full component directive with square hooks
local PATH_DIRECTIVE_PATTERN = "%[%[.-%]%]"
-- ignore commented out directives
local PATH_DIRECTIVE_EXCLUDE_PATTERN = "%-%-%s-%[%[.-%]%]"
-- this pattern is used to capture the path for a directive pattern match
local PATH_CAPTURE_PATTERN = "\"(.-)\""

-- all required custom controls are stored in this registry
local registry = {}

-- internal function to recursively retrieve a list of elements from a parent
-- element
local function getElements(parent, elements)
	elements = elements or {}

	for _, child in ipairs(parent.children) do
		if getmetatable(child) == layout.Elem then
			elements[#elements + 1] = child
		else
			getElements(child, elements)
		end		
	end

	return elements
end

-- add controls at given path to the internal control registry
local function require(path)
	registry[path] = true
end

-- remove controls at given path from the internal control registry
local function unrequire(path)
	registry[path] = nil
end

-- internal function to recursively load components from a file at path
local function loadComponent(path)
	print("load component: ", path)	
	local contents, _ = love.filesystem.read(path)

	while true do
		local match_s, match_e = string.find(contents, PATH_DIRECTIVE_PATTERN)
		if match_s == nil then break end

		local exc_match_s, exc_match_e = string.find(contents, PATH_DIRECTIVE_EXCLUDE_PATTERN)
		local ignore = exc_match_e == match_e and exc_match_s < match_s
		local component_text = ""
		if not ignore then
			local component_path = string.sub(contents, match_s, match_e, 1)
			local component_path = string.match(component_path, PATH_CAPTURE_PATTERN)
			component_text = loadComponent(component_path)
		end

		contents = string.gsub(contents, PATH_DIRECTIVE_PATTERN, component_text, 1)
	end

	return contents
end

-- load a layout file at given path; optionally set debug to true to log the 
-- full content including engine imports and required imports
local function load(path, debug)
	local contents = loadComponent(path)

	local custom_imports = ""
	for path, _ in pairs(registry) do
		-- TODO: probably a good idea to remove Elem require directives to 
		-- prevent layout engine Elem from being overwritten, causing bugs
		custom_imports = custom_imports .. love.filesystem.read(path)
	end

	contents = table.concat({
		DEFAULT_IMPORTS,
		custom_imports,
		" return ",
		contents,
	})

	if debug == true then
		print(contents)
	end

	local hud_contents = loadstring(contents)
	local hud = hud_contents()

	hud.resize = function(w, h)
		hud:reshape(0, 0, w, h)
	end

	-- create a list of elements for use with the eachElement() function
	local elements = getElements(hud)
	hud.eachElement = function(fn)
		for _, element in ipairs(elements) do
			fn(element)
		end
	end

	-- create a table of elements by id for use with the getElement() function
	local elements_by_id = {}
	for _, element in ipairs(elements) do
		if element.id ~= nil then
			elements_by_id[element.id.value] = element
		end
	end

	hud.getElement = function(id, fn)
		local e = elements_by_id[id]
		if e then fn(e) end
	end

	return hud
end

-- The module
return {
	require = require,
	unrequire = unrequire,
	load = load,
}