local function makeButton(image_path)
    return ImageButton { 
        image = image_path,
        corner_radius = 40,
    }
end

return Layout(Margin(10), VStack {
    HStack(80, Spacing(5), {
        Elem(Label { text = 'MENU', font = { 'assets/agricola-rough.otf', 20 }, align = 'center' }),
        Elem(),
        Elem(80, makeButton('assets/crossbow.png')),
        Elem(80, makeButton('assets/sparkling-sabre.png')),
        Elem(80, makeButton('assets/switch-weapon.png')),
    }),
    Elem(),
    Elem(80),
})
