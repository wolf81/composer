Border(Margin(40, 40, 0, 0), {
	VStack({
		Button("TOP", MinSize(100, 50), Stretch(1, 0)),
		[[ "examples/shared.lua" ]],
		Label("Hello", MinSize(100, 50), Stretch(1, 0)),
		FlexibleSpace(),
		Label("press G to see next layout", MinSize(100, 50), Stretch(1, 0)),
		[[ "examples/shared.lua" ]],		
		Button("...", MinSize(100, 50), Stretch(1, 0)),
		HStack(Stretch(1, 0), {
			FlexibleSpace(),
			ImageButton("gfx/ankh.png", MinSize(60), Stretch(0)),
			ImageButton("gfx/crossed-swords.png", MinSize(60), Stretch(0)),
			ImageButton("gfx/high-shot.png", MinSize(60), Stretch(0)),
			ImageButton("gfx/cultist.png", MinSize(60), Stretch(0)),
			ImageButton("gfx/hand.png", MinSize(60), Stretch(0)),
			FlexibleSpace(),
		})
	})
})