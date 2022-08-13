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
        corner_radius = 0,
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
--[[
if row no height:
    if row no children: fill
    if row children: calc total height of children & make row same size
else use row height

if col no height
    if col no children: fill
    if col children: calc total width of children and make col same size
else use col height

]]
return Layout(Margin(10), Rows(Spacing(10), {
    Row(),
    Row(40, Cols(Spacing(10), {
        Col(),
        Col(100, makeButton('BUTTON')),
        Col(),
    })),
    Row(40, Cols(Spacing(10), {
        Col(),
        Col(20, makeCheckbox()),
        Col(),
    })),    
    Row(40, Cols(Spacing(10), {
        Col(),
        Col(100, makeLabel('Label')),
        Col(),
    })),    
    Row(40, Cols(Spacing(10), {
        Col(),
        Col(makeImageButton('assets/sparkling-sabre.png')),
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
