# COMPOSER

## Introduction

Composer is a simple layout engine for UI widgets. Composer doesn't include 
any widgets, but should be easy to use with most UI widget libraries.

With composer the idea is to create a Lua-like layout file. The layout file 
can be loaded and resized to fit a target area (e.g. the window).

*PLEASE NOTE:*
_While the layout file is Lua-like, the file should conform to a 
certain structure, otherwise the layout loader will not be able to parse the 
file properly._

## Layouts

Composer exposes the following layouts for use in a layout file:

* `Border`: a layout that can contain a margin and a single child element
* `VStack`: a layout that arranges its child elements vertically.
* `HStack`: a layout that arranges its child elements horizontally.
* `Elem`: an layout that can be associated with a widget.

## Attributes

Composer exposes the following attributes for use in a layout file:

* `Margin`: can only be used with a `Border` layout; adds spacing between `Border` and
its child element. A `Margin` has 4 arguments, left, top, right & bottom.
* `MinSize`: the minimum horizontal & vertical size of the layout in pixels.
* `Stretch`: control whether the layout stretches horizontally or vertically to 
fill its container. 
* `ID`: can only be used with an `Elem` layout and is used to easily lookup any 
element in a loaded layout file.

## Layout file

Layouts are defined in a layout file. A layout file is based on Lua, but more 
restricted. A layout file might look as such:

```lua
Border(Margin(10), {
	VStack({
		Elem(Stretch(1, 1), MinSize(0, 50)),
		Elem(Stretch(1, 0), MinSize(0, 50)),
	}),
})
```

_In the above example we see a layout that has a border margin of 10 on all 
sides. The `Border` contains a vertical stack with 2 child elements. The top 
element has a minimum widget of 0 and height of 50, but stretches horizontally & 
vertically. The bottom element has a similar size but only stretches horizontally._

A layout file *SHOULD* return a single root layout and *NOT* contain any require 
statements. 

Optionally a layout file may include other layout files as follows:

```lua
Border(Margin(10), {
	VStack({
		Elem(Stretch(1, 1), MinSize(0, 50)),
		Elem(Stretch(1, 0), MinSize(0, 50)),
		[[ "ui/action_bar.lua" ]],
	}),
})
```

## Loading layout files

Use the Loader to load a layout file from a path. Loading can be achieved as 
follows:

```lua
local layout = LayoutLoader.load("layouts/loading.lua")
```

After loading the layout needs to be resized to a target area. In order to 
resize to the window size we could do the following:

```lua
local w_width, w_height = love.window.getMode()
layout.resize(w_width, w_height)
layout.eachElement(function(e)
	e.widget.setFrame(e.rect.x, e.rect.y, e.rect.w, e.rect.h)
end)
```

*PLEASE NOTE:*
_In the above code the resizing involves 2 steps:

1. Resize the layout to a target size.
2. Resize each element widget to the element rect._

## Using Custom Widgets

In order to use custom widgets in a layout file, the `Loader` needs to know 
function names use to retrieve a widget type. We can define a file in the 
project that defines all widget functions and load this file in the `Loader`.

A simple widget file might look as such:

```lua
local UI = require "src.ui"

function Label(text, ...)
	assert(type(text) == "string", "text is required")

	local label = UI.Label(text)
	return Elem(label, ...)
end

function Button(title, ...)
	assert(type(title) == "string", "title is required")

	local button = UI.Button(title)
	return Elem(button, ...)
end
```

Every function should return an `Elem` layout that contains a widget.

In the above code we defined a `Button` and `Label` widget. We can add this file to
the required imports in the Loader as follows:

```
LayoutLoader.require("hud/widgets.lua")
```

If widgets are shared across the project, we can require the widgets just once 
when the app starts. Use the `unrequire(path)` function to remove any previously 
required widgets from the `Loader`.

Based on the above widgets, a layout file might now look as follows:

```
Border(Margin(10), {
	VStack({
		Label("Hello", ID("title"), Stretch(1), MinSize(0, 50)),
		Label("Welcome", ID("message"), Stretch(1, 0), MinSize(0, 50)),
		Button("Press", MinSize(30), Stretch(1))
	}),
})
```

