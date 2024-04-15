local Grid = {}

Grid.new = function(row_defs, col_defs)
    local row_defs = row_defs or { math.huge }
    local col_defs = col_defs or { math.huge }
    local children = {}

    local rows, cols = {}, {}

    local frame = { 0, 0, 0, 0 }

    local addChild = function(self, child, row_idx, col_idx, row_span, col_span)        
        assert(col_idx > 0 and col_idx <= #col_defs, 'col_idx out of range: 1 - ' .. #col_defs)
        assert(row_idx > 0 and row_idx <= #row_defs, 'row_idx out of range: 1 - ' .. #row_defs)

        local row_span = row_span or 1
        local col_span = col_span or 1

        children[child] = { 
            row_idx     = row_idx, 
            col_idx     = col_idx, 
            row_span    = row_span, 
            col_span    = col_span, 
        }

        if rows[row_idx] and cols[col_idx] then
            local row = rows[row_idx]
            local col = cols[col_idx]
            child:setFrame(col.x, row.y, col.w, row.h)
        end
    end

    local setFrame = function(self, x, y, w, h)
        frame = { x, y, w, h }

        rows, cols = {}, {}

        -- determine row size

        local remaining_h = h

        local flex_rows = {}
        for idx, h in ipairs(row_defs) do
            rows[idx] = { y = 0, h = h }

            if h == math.huge then
                flex_rows[#flex_rows + 1] = idx
            else
                remaining_h = remaining_h - h
            end
        end

        local flex_h = math.ceil(remaining_h / #flex_rows)
        local last_h = flex_h + remaining_h % #flex_rows
        while remaining_h > 0 do
            local row_idx = table.remove(flex_rows)
            rows[row_idx] = { h = flex_h, y = 0 }
            
            if remaining_h == last_h then
                flex_h = last_h
            end
            
            remaining_h = remaining_h - flex_h
            flex_h = math.min(remaining_h, flex_h)
        end

        -- determine col size

        local remaining_w = w

        local flex_cols = {}
        for idx, w in ipairs(col_defs) do
            cols[idx] = { x = 0, w = w }

            if w == math.huge then
                flex_cols[#flex_cols + 1] = idx
            else
                remaining_w = remaining_w - w
            end
        end

        local flex_w = math.floor(remaining_w / #flex_cols)
        local last_w = flex_w + remaining_w % #flex_cols
        while remaining_w > 0 do
            local col_idx = table.remove(flex_cols)
            cols[col_idx] = { w = flex_w, x = 0 }

            if remaining_w == last_w then
                flex_w = last_w
            end

            remaining_w = remaining_w - flex_w
            flex_w = math.min(remaining_w, flex_w)
        end

        -- update y coords
        print('rows')
        local y = 0
        for _, row in ipairs(rows) do
            row.y = y
            y = y + row.h
            print('', row.y, row.h)
        end

        -- update x coords
        print('cols')
        local x = 0
        for _, col in ipairs(cols) do
            col.x = x
            x = x + col.w
            print('', col.x, col.w)
        end

        for child, info in pairs(children) do
            local row = rows[info.row_idx]
            local col = cols[info.col_idx]
            child:setFrame(col.x, row.y, col.w, row.h)
        end
    end

    local resize = function(self, w, h)
        self:setFrame(0, 0, w, h)
    end

    local update = function(self, dt)
        for child, _ in pairs(children) do
            child:update(dt)
        end
    end

    local draw = function(self)
        for child, _ in pairs(children) do
            child:draw()
        end
    end

    return setmetatable({
        addChild = addChild,
        setFrame = setFrame,
        resize = resize,

        update = update,
        draw = draw,
    }, Grid)
end

return setmetatable(Grid, {
    __call = function(_, ...) return Grid.new(...) end,
})
