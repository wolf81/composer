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

local function makeCheckbox()
    return Checkbox {
        image = {
            normal = 'assets/checkbox_normal.png',
            hovered = 'assets/checkbox_normal.png',
            active = 'assets/checkbox_active.png',
        }
    }
end

return Layout(Margin(10), Rows {
    Row(),
    Row(300, Cols(Spacing(10), {
        Col(),
        Col(300, makeButton('BTN')),
        Col(300, makeButton('BTN')),
        Col(300, makeCheckbox()),
        Col(),
    })),
    Row(),
})
