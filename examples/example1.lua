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

local function makeInput(text)
    return Input { corner_radius = 3, text = text, font = { 20 }, align = 'left' }
end

local function makeSlider()
    return Slider { corner_radius = 3, value = 3, step = 10 }
end

local function makeProgress()
    return Progress { corner_radius = 3, value = 0.1 }
end

return Layout(Margin(10), Rows(Spacing(10), {
    Row(),
    Row(40, Cols(Spacing(10), {
        Col(),
        Col(80, makeButton('BTN 1')),
        Col(80, makeButton('BTN 2', false)),
        Col(80, makeButton('BTN 3')),
        Col(40, makeCheckbox()),
        Col(),
    })),
    Row(40, Cols {
        Col(),
        Col(210, makeSlider()),
        Col(),
    }),
    Row(40, Cols {
        Col(),
        Col(210, makeInput('blaat')),
        Col(),
    }),
    Row(40, Cols {
        Col(),
        Col(210, makeProgress()),
        Col(),
    }),
    Row(),
}))
