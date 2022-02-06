local imageButton = function(image_path, fg_color, bg_color, ix, iy)
	local frame = { 0, 0, 0, 0 }
	local bg_color = bg_color or { 0.0, 0.0, 0.0, 0.0 }
	local fg_color = fg_color or { 1.0, 1.0, 1.0, 1.0 }
	local drawable = love.graphics.newImage(image_path)

	local image_w, image_h = drawable:getDimensions()
	local sx, sy = 1, 1
	local ix = ix or 0
	local iy = iy or ix

	local is_highlight = false

	local setFrame = function(x, y, w, h)
		w, h = w - 1, h - 1
		frame = { x, y, w, h }
		sx = (w - ix) / image_w
		sy = (h - iy) / image_h
	end

	local update = function(dt)
		local mouse_x, mouse_y = love.mouse.getPosition()
		local x, y, w, h = unpack(frame)		
		
		is_highlight = (
			mouse_x > x and mouse_x < x + w and
			mouse_y > y and mouse_y < y + h
		)
	end

	local draw = function()
		local x, y, w, h = unpack(frame)

		local fg_color = is_highlight and { 0.0, 1.0, 1.0 } or fg_color

		love.graphics.setColor(unpack(bg_color))
		love.graphics.rectangle("fill", x, y, w, h)

		-- draw the drawable
		love.graphics.setColor(unpack(fg_color))
		love.graphics.draw(
			drawable, 
			x + math.floor(ix / 2), 
			y + math.floor(iy / 2), 
			0, 
			sx, 
			sy
		)

		love.graphics.rectangle("line", x, y, w, h)
	end

	return {
		setFrame = setFrame,
		update = update,
		draw = draw,
	}
end

local label = function(text, fg_color, bg_color)
	local frame = { 0, 0, 0, 0 }
	local fg_color = fg_color or { 1.0, 1.0, 1.0, 1.0 }
	local bg_color = bg_color or { 1.0, 1.0, 1.0, 0.0 }
	local text = text or ""

	local font = love.graphics.getFont()
	local text_w = font:getWidth(text)
	local text_h = font:getHeight()

	local setFrame = function(x, y, w, h)
		frame = { x, y, w - 1, h - 1 }
	end

	local setText = function(new_text)
		text = new_text or ""
		text_w = font:getWidth(text)
		text_h = font:getHeight()
	end

	local setFont = function(new_font)
		font = new_font
		text_w = font:getWidth(text)
		text_h = font:getHeight()
	end

	local update = function(dt)
		-- body
	end

	local draw = function()
		local x, y, w, h = unpack(frame)

		-- draw background
		love.graphics.setColor(unpack(bg_color))
		love.graphics.rectangle("fill", x, y, w, h)

		-- draw text
		love.graphics.setFont(font)
		love.graphics.setColor(unpack(fg_color))
		love.graphics.print(
			text, 
			math.floor(x + w / 2), 
			math.floor(y + h / 2), 
			0, 1, 1, 
			math.ceil(text_w / 2), 
			math.ceil(text_h / 2)
		)
	end

	return {
		setFrame = setFrame,
		update = update,
		draw = draw,
		--
		setText = setText,
		setFont = setFont,
	}
end

local button = function(title, fg_color, bg_color)
	local frame = { 0, 0, 0, 0 }
	local fg_color = fg_color or { 0.0, 0.0, 0.0, 1.0 }
	local bg_color = bg_color or { 1.0, 1.0, 1.0, 1.0 }
	local title = title or ""

	local font = love.graphics.getFont()
	local text_w = font:getWidth(title)
	local text_h = font:getHeight()

	local is_highlight = false

	local setFrame = function(x, y, w, h)
		frame = { x, y, w, h }
	end

	local update = function(dt)
		local mouse_x, mouse_y = love.mouse.getPosition()
		local x, y, w, h = unpack(frame)		
		
		is_highlight = (
			mouse_x > x and mouse_x < x + w and
			mouse_y > y and mouse_y < y + h
		)
	end

	local draw = function()
		local x, y, w, h = unpack(frame)

		local fg_color = is_highlight and { 0.0, 1.0, 1.0 } or fg_color

		-- draw background
		love.graphics.setColor(unpack(bg_color))
		love.graphics.rectangle("fill", x, y, w, h)

		-- draw title
		love.graphics.setColor(unpack(fg_color))
		love.graphics.print(
			title, 
			math.floor(x + w / 2), 
			math.floor(y + h / 2), 
			0, 1, 1, 
			math.ceil(text_w / 2), 
			math.ceil(text_h / 2)
		)
	end

	return {
		setFrame = setFrame,
		update = update,
		draw = draw,
	}
end

local spacing = function()
	return {
		setFrame = function() end,
		update = function() end,
		draw = function() end,
	}
end

local textView = function(fg_color, bg_color)
	local frame = { 0, 0, 0, 0 }
	local bg_color = bg_color or { 0.0, 0.0, 0.0, 0.8 }
	local fg_color = fg_color or { 1.0, 1.0, 1.0, 1.0 }
	local btn_size = 30

	local font = love.graphics.getFont()
	local text_h = font:getHeight()
	local text_margin = 10

	local line_buffer = {}

	local button_up = imageButton(
		"gfx/controls/arrow_up.png", 
		fg_color, 
		bg_color,
		8
	)

	local button_down = imageButton(
		"gfx/controls/arrow_down.png", 
		fg_color, 
		bg_color,
		8
	)

	local addText = function(text)
		line_buffer[#line_buffer + 1] = love.graphics.newText(font, text)
		while #line_buffer > 5 do
			table.remove(line_buffer, 1)
		end
	end

	local setFont = function(new_font)
		font = new_font
		text_h = font:getHeight()
	end

	local setFrame = function(x, y, w, h)
		frame = { x, y, w - 1, h - 1 }

		btn_size = math.min(h / 2, 24)
		local btn_y = y + h - btn_size * 2
		local btn_x = x + w - btn_size

		button_up.setFrame(btn_x, btn_y, btn_size, btn_size)
		button_down.setFrame(btn_x, btn_y + btn_size, btn_size, btn_size)
	end

	local update = function(dt)
		button_up.update(dt)
		button_down.update(dt)
	end

	local draw = function()
		local x, y, w, h = unpack(frame)

		local bg_w = w - btn_size

		love.graphics.setColor(unpack(bg_color))
		love.graphics.rectangle("fill", x, y, bg_w, h)

		button_up.draw()
		button_down.draw()

		love.graphics.setColor(unpack(fg_color))
		love.graphics.rectangle("line", x, y, bg_w, h)

		x, y = x + text_margin, y + text_margin
		for _, line in ipairs(line_buffer) do
			love.graphics.draw(line, x + 0.5, y + 0.5)
			y = y + text_h
		end
	end

	return {
		setFrame = setFrame,
		update = update,
		draw = draw,
		--
		addText = addText,
		setFont = setFont,
	}
end

return {
	Label = label,
	Button = button,
	ImageButton = imageButton,
	TextView = textView,
	Spacing = spacing,
}