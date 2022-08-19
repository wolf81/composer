local function makeButton(text)
    return Button { 
        text = text, 
        font = { 'assets/agricola-rough.otf', 24 }, 
        corner_radius = 10,
    }
end

local function makeLabel(text)
    return Label { 
        text = text, 
        font = { 'assets/agricola-rough.otf', 48 }, 
        align = 'center' 
    }
end

return Layout(HStack {
	Space(),
	VStack(300, Spacing(8), {
		makeLabel('MY AWESOME GAME'),
		makeButton('NEW GAME'),
		makeButton('CONTINUE'),
		makeButton('SETTINGS'),
		makeButton('QUIT'),
		Space(),
	}),
	Space(),
})
