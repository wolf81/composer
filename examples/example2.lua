local function makeButton(image_path)
    return ImageButton { 
        image = image_path,
        corner_radius = 0,
    }
end

return Layout(Margin(10), Rows {
    Row(80, Cols(Spacing(1), {
        Col(Label { text = 'MENU', font = { 'assets/agricola-rough.otf', 40 }, align = 'right' }),
        Col(80, makeButton('assets/crossbow.png')),
        Col(80, makeButton('assets/sparkling-sabre.png')),
        Col(80, makeButton('assets/switch-weapon.png')),
    })),
    Row(),
    Row(80),
})
