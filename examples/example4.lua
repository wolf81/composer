local function makeButton(text)
    return Button { 
        text = text, 
        font = { 'assets/agricola-rough.otf', 24 }, 
        corner_radius = 10,
    }
end

return Layout(HStack {
	Elem(),
	VStack(300, Spacing(8), {
		Elem(Label { text = 'MY AWESOME GAME', font = { 'assets/agricola-rough.otf', 48 }, align = 'center' }),
		Elem(70, makeButton('NEW GAME')),
		Elem(70, makeButton('CONTINUE')),
		Elem(70, makeButton('SETTINGS')),
		Elem(70, makeButton('QUIT')),
		Elem(),
	}),
	Elem(),
})
