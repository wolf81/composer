Border(Margin(0), {
	VStack({
		Label("Hello", MinSize(0, 50), Stretch(1, 0), ID("test1")),
		Button("From", ID("test2")),
		Label("Me", ID("test3")),
		HStack(MinSize(0, 80), Stretch(1, 0), {
			Button("Hello", MinSize(40), Stretch(0, 1)),
			Label("From", MinSize(40), Stretch(1)),
			Button("Me", MinSize(40), Stretch(0, 1)),		
		})
	}),
})