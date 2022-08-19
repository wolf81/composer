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

return Layout(VStack {
    Space(),
    VStack {
        makeButton('BLAAT'),
        VStack(100, {
            Space(),
            makeButton('BOTTOM'),
            Space(),
        }),
        makeLabel('HI'),
    },
    Space(),
})
