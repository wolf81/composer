local UI = require "widgets.ui"

function TextView(text, ...)
	assert(type(text) == "string", "text is required")

	local textView = UI.TextView()
	return Elem(textView, ...)
end

function Label(text, ...)
	assert(type(text) == "string", "text is required")

	local label = UI.Label(text, { 1.0, 1.0, 1.0 }, { 0.3, 0.0, 0.0, 1.0 })
	return Elem(label, ...) 
end

function Button(title, ...)
	assert(type(title) == "string", "title is required")

	local button = UI.Button(title, { 0.0, 0.0, 0.0 }, { 0.0, 0.5, 0.6, 1.0 })
	return Elem(button, ...)
end

function ImageButton(path, ...)
	assert(type(path) == "string", "path is required")

	local imageButton = UI.ImageButton(
		path, 
		{ 1.0, 1.0, 1.0 }, 
		{ 0.0, 0.0, 0.0 }, 
		10
	)
	return Elem(imageButton, ...)
end

function FixedSpace(w, h)
	w = w or 0
	h = h or w
	return Elem(UI.Spacing(), MinSize(w, h), Stretch(0, 0))
end

function FlexibleSpace()
	return Elem(UI.Spacing(), MinSize(0, 0), Stretch(1, 1))
end