local function makeButton(image_path)
    return ImageButton { 
        image = image_path,
        corner_radius = 30,
    }
end

return Layout(Margin(10), Rows {
    Row(80, Cols(Spacing(1), {
        Col(Label { text = 'MENU', font = { 'assets/agricola-rough.otf', 20 }, align = 'center' }),
        Col(),
        Col(80, makeButton('assets/crossbow.png')),
        Col(80, makeButton('assets/sparkling-sabre.png')),
        Col(80, makeButton('assets/switch-weapon.png')),
    })),
    Row(),
    Row(80),
})
