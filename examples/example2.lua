Border(Margin(0), {
	VStack({
		Label("TOP", ID("test1")),
		Button("press G to see next layout", ID("test2")),
		Label("BOTTOM", ID("test3")),
		[[ "examples/shared.lua" ]],
	}),
})