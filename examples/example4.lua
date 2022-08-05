Layout(Cols {
	Col(),
	Col(300, Rows {
		Row(Label({ text = 'MY AWESOME GAME' })),
		Row(70, Button({ text = 'NEW GAME' })),
        Row(10),
		Row(70, Button({ text = 'CONTINUE' })),
        Row(10),
		Row(70, Button({ text = 'SETTINGS' })),
        Row(10),
		Row(70, Button({ text = 'QUIT' })),
		Row(),
	}),
	Col(),
})
