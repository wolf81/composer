return Layout(Rows {
	Row(),
	Row(400, Cols {
		Col(),
		Col(400, Rows(Spacing(10), {
			Row(40, Checkbox {}),
			Row(Button {}),
			Row(Button {}),
		})),
		Col(),
	}),
	Row(),
})
