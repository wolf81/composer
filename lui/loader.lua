local _PATH = (...):match("(.-)[^%.]+$") 

local layout = require(_PATH .. "layout")
local widgets = require(_PATH .. "widgets")
local attr = require(_PATH .. "attributes")

local Elem = layout.Elem

local function cleanPath(path)
	-- Remove leading/trailing whitespace
	path = path:match("^%s*(.-)%s*$")

	-- Remove surrounding double or single quotes, if present
	path = path:match('^"(.*)"$') or path:match("^'(.*)'$") or path

	return path
end

-- internal function to load components from a file at path
local function loadComponent(path)
	path = cleanPath(path)

	if love.filesystem.getInfo(path, "file") == nil then
		error("file does not exist: " .. path)
	end

    local chunk = assert(love.filesystem.load(path))	

	setfenv(chunk, {
		Margin = attr.Margin,
		Stretch = attr.Stretch,
		MinSize = attr.MinSize,
		ID = attr.ID,

		Border = layout.Border,
		VStack = layout.VStack,
		HStack = layout.HStack,
		Elem = layout.Elem,

		TextView = widgets.TextView,
		Button = widgets.Button,
		Label	= widgets.Label,
		ImageButton = widgets.ImageButton,
		FixedSpace = widgets.FixedSpace,
		FlexibleSpace = widgets.FlexibleSpace,
	}) 

	return chunk()
end

-- internal function to recursively retrieve a list of elements from a parent
-- element
local function getElements(parent, elements)
	elements = elements or {}

	for k, child in ipairs(parent.children) do
		if type(child) == 'string' then
			-- dynamically replace string with component
			local component = loadComponent(child)
			parent.children[k] = component
			getElements(component, elements)
		elseif getmetatable(child) == layout.Elem then
			elements[#elements + 1] = child
		else
			getElements(child, elements)
		end		
	end

	return elements
end

-- load a layout file at given path; optionally set debug to true to log the 
-- full content including engine imports and required imports
local function load(path, is_debug)
	local contents = loadComponent(path)

	if is_debug == true then
		print(contents)
	end

	-- create a list of elements for use with the eachElement() function
	local elements = getElements(contents)

	contents.resize = function(w, h, fn)
		fn = fn or function() end
		
		contents:reshape(0, 0, w, h)
		for _, e in ipairs(elements) do
			fn(e)
		end
	end

	-- create a table of elements by id for use with the getElement() function
	local elements_by_id = {}
	for _, element in ipairs(elements) do
		if element.id ~= nil then
			elements_by_id[element.id.value] = element
		end
	end

	contents.getElement = function(id, fn)
		local e = elements_by_id[id]
		if e then fn(e) end
	end

	return contents
end

-- The module
return {
	load = load,
}
