# COMPOSER

## Introduction

Composer is a simple layout engine for UI widgets. Composer doesn't include 
any widgets, but should be easy to use with most UI widget libraries.

With composer the idea is to create a Lua-like layout file. The layout file 
can be loaded and resized to fit a target area (e.g. the window).

_*PLEASE NOTE:*
While the layout file is Lua-like, the file should conform to a 
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

_*PLEASE NOTE:*
In the above example we see a layout that has a border margin of 10 on all 
sides. The `Border` contains a vertical stack with 2 child elements. The top 
element has a minimum width of 0 and height of 50, but stretches horizontally & 
vertically. The bottom element has the same size but only stretches horizontally._

A layout file *MUST* return a single root layout and *NOT* contain any require 
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

Use the `load(path)` function to load a layout file from a path. Loading 
can be achieved as follows:

```lua
local layout = Composer.load("layouts/loading.lua")
```

_In the above example we load the layout file at path: layouts/loading.lua_

After loading the layout needs to be resized to a target area. In order to 
resize to the window size we could do the following:

```lua
local w_width, w_height = love.window.getMode()
layout.resize(w_width, w_height, function(e) 
	e.widget.setFrame(e.rect.x, e.rect.y, e.rect.w, e.rect.h)
end)
```

Using the `resize(w, h, fn)` function we set the size of the layout. We also
loop through each element and for each element we set the widget size to the
element rect.

Different widget libraries might have different methods for setting the frame. 
The callback allows us to use whatever code we need to set a widget frame.

## Using Custom Widgets

In order to use custom widgets in layout files we can expose our own widget 
factory functions to Composer. For each widget we want to add, we return an 
`Elem` object that contains the widget.

A simple widget loading file might look as such:

```lua
-- we assume the widgets are imported from: src.ui
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

In the above code we defined a `Button` and `Label` widget. We can use the 
widgets with Composer by calling the `require(path)` function. 

```lua
Composer.require("ui/widgets.lua")
```

If widgets are shared across the project, we can require the widgets just once 
when the app starts. Use the `unrequire(path)` function to remove any previously 
required widgets from the `Loader`.

Based on the above widgets, a layout file might now look as follows:

```lua
Border(Margin(10), {
	VStack({
		Label("Hello", ID("title"), Stretch(1), MinSize(0, 50)),
		Label("Welcome", ID("message"), Stretch(1, 0), MinSize(0, 50)),
		Button("Press", MinSize(30), Stretch(1))
	}),
})
```

## Credits

This library has been based on a Python project by fips as described [here](fips).

I've also taken some inspiration on layouts as used by Xamarin Forms, mainly in 
the way attributes are constructed.

[fips]: https://forums.4fips.com/viewtopic.php?f=3&t=6896
