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

local function getControls(element, control_list)
	local control_list = control_list or {}

	if element:is(controls.Control) then
		control_list[#control_list + 1] = element
	else
		if element.child then
			return getControls(element.child, control_list)
		elseif element.children then
			for _, child in ipairs(element.children) do
				getControls(child, control_list)
			end	
		end
	end

	return control_list
end

-- load a layout file at given path; optionally set debug to true to log the 
-- full content including engine imports and required imports
local function load(path, is_debug)
	-- first load the layout file
	local contents = loadComponent(path)

	-- combine layout file with composer modules into one file
	local contents = table.concat({
		'local controls = require \'' .. PATH .. 'controls\'',		
		'local layout = require \'' .. PATH .. 'layout\'',		
		LAYOUT_IMPORTS,
		CONTROL_IMPORTS,
		'return ' .. contents,
	}, '\n\n')

	-- log file if debug flag is set to true
	if is_debug == true then print(contents) end	

	-- load combined file
	local ui = loadstring(contents)()

	-- get list of controls
	local controls = getControls(ui)
	print('controls: ' .. #controls)

	-- return a facade 
	return {
		draw = function() ui:draw() end,
		update = function(dt) ui:update(dt) end,
		getControl = function() end,
		eachControl = function(fn) 
			for _, control in ipairs(controls) do
				fn(control)
			end
		end,
		resize = function(w, h) ui:resize(w, h) end
	}
end

return load
