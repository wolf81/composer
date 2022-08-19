local function makeButton(text)
    return Button(50, { 
        text = text, 
        font = { 'assets/agricola-rough.otf', 24 }, 
        corner_radius = 10,
    })
end

local function makeLabel(text)
    return Label { 
        text = text, 
        font = { 'assets/agricola-rough.otf', 48 }, 
        align = 'center' 
    }
end

return Layout(VStack(Spacing(20), {
    Space(),
    HStack({
        Space(),
        makeLabel('MY AWESOME GAME'),
        Space(),
    }),
    HStack({
        Space(),
        VStack(300, Spacing(10), {
            makeButton('NEW GAME'),
            makeButton('CONTINUE'),
            makeButton('SETTINGS'),
            makeButton('QUIT'),        
        }),
        Space(),        
    }),
	Space(),
}))
