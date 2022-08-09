-- hovered, active, normal, disabled

local function makeButton(title)
    return ImageButton {
        image = {
            normal = 'assets/btn_gray_normal.png',
            hovered = 'assets/btn_gray_hovered.png',            
            active = 'assets/btn_gray_hovered.png',            
        },
        text = title,
        font = { 12 },
    }
end

return Layout(Margin(10), Rows {
    Row(),
    Row(300, Cols(Spacing(10), {
        Col(),
        Col(300, makeButton('BUTTON 1')),
        Col(300, makeButton('BUTTON 2')),
        Col(300, makeButton('BUTTON 3')),
        Col(),
    })),
    Row(),
})
