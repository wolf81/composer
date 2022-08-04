local PATH = (...):match('(.-)[^%.]+$') 
local layout = require(PATH .. 'layout')
local controls = require(PATH .. 'controls')

local LAYOUT_IMPORTS = [[
local Layout = layout.Layout
local Cols = layout.Cols
local Col = layout.Col
local Rows = layout.Rows
local Row = layout.Row
]]

local CONTROL_IMPORTS = [[
local Button = controls.Button
]]

-- this pattern matches the full component directive with square hooks
local PATH_DIRECTIVE_PATTERN = '%[%[.-%]%]'
-- ignore commented out directives
local PATH_DIRECTIVE_EXCLUDE_PATTERN = '%-%-%s-%[%[.-%]%]'
-- this pattern is used to capture the path for a directive pattern match
local PATH_CAPTURE_PATTERN = '\"(.-)\"'

-- internal function to recursively retrieve a list of elements from a parent
-- element
local function getControls(parent, controls)
	controls = controls or {}

	for _, child in ipairs(parent.children) do
		if child:is(controls.Control) then
			controls[#controls + 1] = child
		else
			getControls(child, controls)
		end
	end

	return controls
end

-- internal function to recursively load components from a file at path
local function loadComponent(path)
	if love.filesystem.getInfo(path, 'file') == nil then
		error('file does not exist: ' .. path)
	end

	local contents, _ = love.filesystem.read(path)

	while true do
		local match_s, match_e = string.find(contents, PATH_DIRECTIVE_PATTERN)
		if match_s == nil then break end

		local exc_match_s, exc_match_e = string.find(contents, PATH_DIRECTIVE_EXCLUDE_PATTERN)
		local ignore = exc_match_e == match_e and exc_match_s < match_s
		local component_text = ''
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
local function load(path, is_debug)
	local contents = loadComponent(path)

	local layout_path = PATH .. 'layout'
	local controls_path = PATH .. 'controls'

	local imports = {
		'--[[ ' .. layout_path .. ' ]]--',
		'local layout = require \'' .. layout_path .. '\'',		
		LAYOUT_IMPORTS,
		'--[[ ' .. controls_path .. ' ]]--',
		'local controls = require \'' .. controls_path .. '\'',		
		CONTROL_IMPORTS,
	}

	imports[#imports + 1] = '--[[ ' .. path .. ' ]]--'
	imports[#imports + 1] = 'return ' .. contents

	contents = table.concat(imports, '\n\n')

	if is_debug == true then
		print(contents)
	end

	local ui = loadstring(contents)()

	-- create a list of elements for use with the eachElement() function
	-- create a list of wdgets
	local controls_list = getControls(ui)

	-- create a table of elements by id for use with the getElement() function
	local controls_by_id = {}
	for _, control in ipairs(controls_list) do
		if control.id ~= nil then
			controls_by_id[control.id] = control
		end
	end

	ui.getControl = function(id, fn)
		local control = controls_by_id[id]
		if control then fn(control) end
	end

	ui.eachControl = function(fn)
		for _, control in ipairs(controls_list) do
			fn(control)
		end
	end

	return ui
end

return load
