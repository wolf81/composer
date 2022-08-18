return Layout(VStack {
	Elem(),
	Elem(400, HStack {
		Elem(),
		Elem(400, VStack(Spacing(10), {
			Elem(100, Button { text = 'BUTTON 1', font = 20 }),
			Elem(100, Button { text = 'BUTTON 2', font = 20 }),
			Elem(100, Button { text = 'BUTTON 3', font = 20 }),
		})),
		Elem(),
	}),
	Elem(),
})
