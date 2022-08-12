return Layout(Rows {
	Row(),
	Row(400, Cols {
		Col(),
		Col(400, Rows(Spacing(10), {
			Row(100, Button { text = 'BUTTON 1', font = 20 }),
			Row(100, Button { text = 'BUTTON 2', font = 20 }),
			Row(100, Button { text = 'BUTTON 3', font = 20 }),
		})),
		Col(),
	}),
	Row(),
})
