Layout({ -- Margin?
    Row(40, {
        Cell(), -- fill space 100% - 60 px
        Cell(20, Button('Title1', { id = 'button1', color_fg = {}, color_bg = {}, ... })),
        Cell(20, Button('Title2', { id = 'button2', font = '', ... })),
        Cell(20, Button()),
    }),
    Row({
        Cell(ListView()), -- fill space 50%
        Cell(ListView()), -- fill space 50%
    }),
    Row(40, {
        Cell(), -- fill space 100%
    }),    
})


Layout({
    Col(), -- fill space 50% - 50 px
    Col(100, {
        Row(), -- fill space 50% - 40 px
        Row(20, Button('NEW GAME', { ... })),
        Row(20, Button('CONTINUE', { ... })),
        Row(20, Button('SETTINGS', { ... })),
        Row(20, Button('QUIT', { ... })),
        Row(), -- fill space 50% - 40 px
    }),
    Col(), -- fill space 50% - 50 px
})


Layout({
    Col(),
    Col(100, ListView({ ... })),
    Col(100, ListView({ ... })),
    Col(100, ListView({ ... })),
    Col(),
})
