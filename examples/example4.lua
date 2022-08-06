local function makeButton(text)
    return Button { 
        text = text, 
        font = { 'assets/agricola-rough.otf', 24 }, 
        corner_radius = 10,
    }
end

return Layout(Cols {
	Col(),
	Col(300, Rows(Spacing(8), {
		Row(Label { text = 'MY AWESOME GAME', font = { 'assets/agricola-rough.otf', 48 }, align = 'center' }),
		Row(70, makeButton('NEW GAME')),
		Row(70, makeButton('CONTINUE')),
		Row(70, makeButton('SETTINGS')),
		Row(70, makeButton('QUIT')),
		Row(),
	})),
	Col(),
})
