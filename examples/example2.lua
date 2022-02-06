Border(Margin(0), {
	VStack({
		Label("TOP", MinSize(0, 50), Stretch(1, 0), ID("test1")),
		Button("press G to see next layout", ID("test2")),
		Label("BOTTOM", ID("test3")),
		[[ "examples/shared.lua" ]],
	}),
})