local function makeButton(title)
    return Button(100, {
        text = title,
        font = { 20 },
        corner_radius = 3,
    })
end

return Layout(VStack {
	Space(),
	HStack(400, {
		Space(),
		VStack(400, Spacing(10), {
			makeButton('BUTTON 1'),
			makeButton('BUTTON 2'),
			makeButton('BUTTON 3'),
		}),
		Space(),
	}),
	Space(),
})
