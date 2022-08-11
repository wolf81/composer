-- hovered, active, normal, disabled

local function makeButton(title)
    return ImageButton {
        image = {
            normal = 'assets/btn_brown_normal.png',
            hovered = 'assets/btn_brown_normal.png',
            active = 'assets/btn_brown_active.png',            
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
            active = 'assets/checkbox_check.png',
        }
    }
end

return Layout(Margin(10), Rows {
    Row(),
    Row(300, Cols(Spacing(10), {
        Col(),
        Col(100, makeButton('BTN')),
        Col(100, makeButton('BTN')),
        Col(100, makeCheckbox()),
        Col(),
    })),
    Row(),
})
