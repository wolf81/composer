# COMPOSER

## Introduction

Composer is both a layout engine & widget library.

With composer the idea is to create a Lua-like layout file. The layout file 
can be loaded and resized to fit a target area (e.g. the window).

_*PLEASE NOTE:*
While the layout file is Lua-like, the file should conform to a 
certain structure, otherwise the layout loader will not be able to parse the 
file properly._

## Layouts

Composer exposes the following layouts for use in a layout file:

* `Layout`: the root node of a layout file.
* `VStack`: a node that arranges its child elements vertically.
* `HStack`: a node that arranges its child elements horizontally.
* `Elem`: the elem object is a container for a widget.

## Attributes

Composer exposes the following attributes for use in a layout file:

* `Margin`: can only be used with a `Border` layout; adds spacing between 
`Border` and its child element. A `Margin` has 4 arguments, left, top, right & 
bottom.
* `ID`: can only be used with an `Elem` layout and is used to easily lookup any 
element in a loaded layout file.

Additionally, providing a numeric value to a `VStack`, `HStack` or `Elem` will 
use the provided value as it's size value. Please be aware that the 
meaning of the size value is dependent on it's context:

* Since a `VStack` always fills it's parent vertically, the size value 
corresponds to the width of the stack.
* Since a `HStack` always fills it's parent horizontally, the size value 
corresponds to the height of the stack.
* In case of a child `Elem`ent, the meaning of the size value depends on the 
container. If the container is a `VStack`, the size value corresponds to the 
height. If the container is a `HStack`, the size value corresponds to the width.

## Layout file

Layouts are defined in a layout file. A layout file is based on Lua and might look as such:

```lua
return Layout(Margin(10), HStack {
	Space(),
	VStack(Spacing(10), {
		Space(),
		Button({ text = 'Button 1' }),
		Button({ text = 'Button 2' }),
		Button({ text = 'Button 3' }),
		Space(),
	}),
	Space(),
})
```

With regards to the above file, please note the following:

* A valid layout file should always return a root `Layout`.
* Widgets (`Button`, `Slider`, `Label`, ...), layout elements (`VStack`, `HStack`, `Layout`) & attributes (`Spacing`, `Margin`) are imported automatically.
* The `Space` widget is used to add flexible spacing.
* As such, in this example 3 buttons are created of equal size in the middle of the view. 

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

## Initialization

Composer needs to hook up with several LÖVE 2D functions in order to properly handle mouse & keyboard interactions. As such, prior to loading a layout, one should call the `init()` method. A good place to do this might be at the start of the app.

```lua
local composer = require 'composer'

function love.load(args)		
	composer.init()
end
```

## Loading layout files

Use the `load(path)` function to load a layout file from a path. Loading 
can be achieved as follows:

```lua
local layout = composer.load("layouts/loading.lua")
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
Layout(Margin(10), {
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
