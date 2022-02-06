Border(Margin(0), {
	VStack({
		Label("Hello", MinSize(0, 50), Stretch(1, 0), ID("test1")),
		Button("From", ID("test2")),
		Label("Me", ID("test3")),
		[[ "examples/shared.lua" ]],
	}),
})