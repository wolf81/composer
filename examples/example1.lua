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
return Layout(Margin(10), VStack(Spacing(10), {
    Elem(),
    Elem(HStack(Spacing(10), {
        Elem(),
        Elem(makeButton('BUTTON')),
        Elem(),
    })),
    Elem(HStack(Spacing(10), {
        Elem(),
        Elem(makeCheckbox()),
        Elem(),
    })),    
    Elem(HStack(Spacing(10), {
        Elem(),
        Elem(makeLabel('Label')),
        Elem(),
    })),    
    Elem(HStack(Spacing(10), {
        Elem(),
        Elem(makeImageButton('assets/sparkling-sabre.png')),
        Elem(),
    })),    
    Elem(HStack {
        Elem(),
        Elem(makeSlider()),
        Elem(),
    }),
    Elem(HStack {
        Elem(),
        Elem(makeInput('blaat')),
        Elem(),
    }),
    Elem(HStack {
        Elem(),
        Elem(makeProgress()),
        Elem(),
    }),
    Elem(),
}))
