local function makeButton(image_path)
    return ImageButton { 
        image = image_path,
        corner_radius = 40,
    }
end

local function makeLabel(text)
    return Label { 
        text = text, 
        font = { 'assets/agricola-rough.otf', 20 }, 
        align = 'center' 
    }
end

return Layout(Margin(10), VStack {
    HStack(80, Spacing(5), {
        makeLabel('MENU'),
        Space(),
        Elem(80, makeButton('assets/crossbow.png')),
        Elem(80, makeButton('assets/sparkling-sabre.png')),
        Elem(80, makeButton('assets/switch-weapon.png')),
    }),
    Space(40),
    HStack(80, { 
        Elem(80, makeButton('assets/crossbow.png'))
    })
})
