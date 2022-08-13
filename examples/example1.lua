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

local function makeImageButton(image_path)
    return ImageButton { 
        image = image_path,
        corner_radius = 30,
    }
end

local function makeCheckbox()
    return Checkbox { corner_radius = 3, checked = true }
end

local function makeLabel(text)
    return Label { text = text, font = { 16 }, align = 'left' }
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
        Col(150, makeButton('BUTTON')),
        Col(),
    })),
    Row(40, Cols(Spacing(10), {
        Col(),
        Col(150, makeLabel('Label')),
        Col(),
    })),    
    Row(40, Cols(Spacing(10), {
        Col(),
        Col(150, makeCheckbox()),
        Col(),
    })),    
    Row(40, Cols(Spacing(10), {
        Col(),
        Col(makeImageButton('assets/crossbow.png')),
        Col(),
    })),
    Row(40, Cols(Spacing(10), {
        Col(),
        Col(makeSlider()),
        Col(),
    })),
    Row(40, Cols(Spacing(10), {
        Col(),
        Col(makeInput('blaat')),
        Col(),
    })),
    Row(40, Cols {
        Col(),
        Col(210, makeProgress()),
        Col(),
    }),
    Row(),
}))
