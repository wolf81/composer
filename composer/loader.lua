local _PATH = (...):match("(.-)[^%.]+$") 
local layout = require(_PATH .. "layout")
local controls = require(_PATH .. 'controls')

local ATTRIBUTE_IMPORTS = [[
local Margin = attr.Margin
local Stretch = attr.Stretch
local MinSize = attr.MinSize
local ID = attr.ID
]]

local LAYOUT_IMPORTS = [[
local VStack = layout.VStack
]]

local CONTROLS_IMPORTS = [[
local Label = controls.Label
]]

-- this pattern matches the full component directive with square hooks
local PATH_DIRECTIVE_PATTERN = "%[%[.-%]%]"
-- ignore commented out directives
local PATH_DIRECTIVE_EXCLUDE_PATTERN = "%-%-%s-%[%[.-%]%]"
-- this pattern is used to capture the path for a directive pattern match
local PATH_CAPTURE_PATTERN = "\"(.-)\""

-- internal function to recursively retrieve a list of elements from a parent
-- element
local function getWidgets(parent, widgets)
	widgets = widgets or {}

	for _, child in ipairs(parent.children) do
		if child:is(controls.Control) then
			widgets[#widgets + 1] = child
		else
			getWidgets(child, widgets)			
		end
	end

	return widgets
end

-- internal function to recursively load components from a file at path
local function loadComponent(path)
	if love.filesystem.getInfo(path, "file") == nil then
		error("file does not exist: " .. path)
	end

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

--[[

-- load a layout file at given path; optionally set debug to true to log the 
-- full content including engine imports and required imports
local function load(path, is_debug)
	local contents = loadComponent(path)

	local attr_path = _PATH .. "attributes"
	local layout_path = _PATH .. "layout"

	local imports = {
		"local attr = require \"" .. attr_path .. "\"",
		ATTRIBUTE_IMPORTS,
		"local layout = require \"" .. layout_path .. "\"",		
		LAYOUT_IMPORTS,
	}

	imports[#imports + 1] = "return " .. contents

	contents = table.concat(imports, "\n\n")

	if is_debug == true then
		print(contents)
	end

	local hud_contents = loadstring(contents)
	local hud = hud_contents()

	-- create a list of elements for use with the eachElement() function
	-- create a list of wdgets
	local elements, widgets = getElementsAndWidgets(hud)

	hud.resize = function(w, h, fn)
		fn = fn or function() end
		
		hud:reshape(0, 0, w, h)
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

	hud.getElement = function(id, fn)
		local e = elements_by_id[id]
		if e then fn(e) end
	end

	hud.eachElement = function(fn)
		for _, e in ipairs(elements) do
			fn(e)
		end
	end

	hud.getWidget = function(element_id, fn)
		local e = elements_by_id[element_id]
		if e and e.widget ~= nil then fn(e.widget) end
	end

	hud.eachWidget = function(fn)
		for _, w in ipairs(widgets) do
			fn(w)
		end
	end

	return hud
end
--]]

local function getPath(module_name)
	return _PATH .. module_name
end

function load(path, is_debug)
	print('load: ' .. path)

	local contents = loadComponent(path)

	local imports = {
		'local attr = require "' .. getPath('attributes') .. '"',
		ATTRIBUTE_IMPORTS,
		'local layout = require "' .. getPath('layout') .. '"',		
		LAYOUT_IMPORTS,
		'local controls = require "' .. getPath('controls') .. '"',		
		CONTROLS_IMPORTS,
	}

	imports[#imports + 1] = "return " .. contents

	contents = table.concat(imports, "\n\n")

	if is_debug == true then
		print(contents)
	end

	local layout = loadstring(contents)()
	print('LAYOUT LOADED', layout)

	local widgets = getWidgets(layout)

	local widgets_by_id = {}
	for _, widget in ipairs(widgets) do
		if widget.id ~= nil then
			widgets_by_id[widget.id.value] = widget
		end
	end

	local resize = function(w, h)
		layout:resize(0, 0, w, h)
	end

	local update = function(dt)
		for _, widget in ipairs(widgets) do
			widget:update(dt)
		end
	end

	local draw = function()		
		for _, widget in ipairs(widgets) do
			widget:draw()
		end
	end

	local getWidget = function(widget_id, fn)
		print('get widget', widget_id)
		local widget = widgets_by_id[widget_id]
		if widget then fn(widget) end
	end	

	return {
		resize = resize,
		getWidget = getWidget,
		update = update,
		draw = draw,
	}
end

-- The module
return {
	load = load,
}