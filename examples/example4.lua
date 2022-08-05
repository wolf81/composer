Layout(Cols {
	Col(),
	Col(300, Rows(Spacing(8), {
		Row(Label { text = 'MY AWESOME GAME', font = { 'assets/agricola-rough.otf', 48 }}),
		Row(70, Button { text = 'NEW GAME', font = { 'assets/agricola-rough.otf', 24 }}),
		Row(70, Button { text = 'CONTINUE', font = { 'assets/agricola-rough.otf', 24 }}),
		Row(70, Button { text = 'SETTINGS', font = { 'assets/agricola-rough.otf', 24 }}),
		Row(70, Button { text = 'QUIT', font = { 'assets/agricola-rough.otf', 24 }}),
		Row(),
	})),
	Col(),
})
