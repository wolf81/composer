-- hovered, active, normal, disabled

local function makeButton(title, is_enabled)
    local button = Button {
        text = title,
        font = { 12 },
        corner_radius = 3,
    }

    button:setEnabled(is_enabled ~= false)

    return button
end

local function makeCheckbox()
    return Checkbox { corner_radius = 3, checked = true }
end

return Layout(Margin(10), Rows {
    Row(),
    Row(40, Cols(Spacing(10), {
        Col(),
        Col(80, makeButton('BTN 1')),
        Col(80, makeButton('BTN 2', false)),
        Col(80, makeButton('BTN 3')),
        Col(40, makeCheckbox()),
        Col(),
    })),
    Row(),
})
