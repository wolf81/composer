return Layout(VStack {
	Space(),
	HStack(400, {
		Space(),
		VStack(400, Spacing(10), {
			Elem(100, Button { text = 'BUTTON 1', font = 20 }),
			Elem(100, Button { text = 'BUTTON 2', font = 20 }),
			Elem(100, Button { text = 'BUTTON 3', font = 20 }),
		}),
		Space(),
	}),
	Space(),
})
