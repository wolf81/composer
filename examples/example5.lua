local function makeLabel(text)
    return Label { text = text, font = { 16 }, align = 'left' }
end

local function makeButton(text)
    return Button { 
        text = text, 
        font = { 'assets/agricola-rough.otf', 24 }, 
        corner_radius = 10,
    }
end

return Layout(Rows {
    Row(),
    Row(Rows {
        Row(makeButton('BLAAT')),
        Row(100, Rows {
            Row(),
            Row(makeButton('BOTTOM')),
            Row(),
        }),
        Row(makeLabel('HI')),
    }),
    Row(),
})
