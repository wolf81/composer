Layout(Cols {
    Col(300, Rows {
        Row(Cols {
            Col(100),
            Col(),
        }),
        Row(50),
        Row(50),
        Row(),
    }),
    Col(),
    Col(100, Button()),
})

--[[
Layout(Cols {
    Col(), -- fill space 50% - 50 px
    Col(300, Rows {
        Row(), -- fill space 50% - 40 px
        Row(20, Button('NEW GAME', { ... })),
        Row(20, Button('CONTINUE', { ... })),
        Row(20, Button('SETTINGS', { ... })),
        Row(20, Button('QUIT', { ... })),
        Row(), -- fill space 50% - 40 px
    }),
    Col(), -- fill space 50% - 50 px
})
]]

--[[
Layout:
    (Rows|Cols|Layout)

Rows:
    (Row[])

Cols:
    (Col[])

Col:
    (Cols|Rows|Control)

Row:
    (Cols|Rows|Control)

Control:
    ...
]]