Layout(Margin(10), Rows {
    Row(80, Cols(Spacing(1), {
        Col(Label { text = 'MENU', font = { 'assets/agricola-rough.otf', 40 }}),
        Col(80, ImageButton { image = 'assets/crossbow.png' }),
        Col(80, ImageButton { image = 'assets/sparkling-sabre.png' }),
        Col(80, ImageButton { image = 'assets/switch-weapon.png' }),
    })),
    Row(),
    Row(80),
})
