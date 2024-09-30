local debug = {}

function debug.new_debugger(params)
    params = params or {}

    local debugger = {
        lines = {},
        max_lines = params.max_lines or 5,
        line_height = params.line_height or 8,
        color = params.color or color.White,
        font = params.font or assets.fonts.default,
        line_max_age = params.line_max_age or 6,
    }

    if params.top_left_pos then
        debugger.top_left_pos = params.top_left_pos
    elseif params.bottom_left_pos then
        debugger.bottom_left_pos = params.bottom_left_pos
    else
        debugger.top_left_pos = v2(0, 0)
    end

    function debugger:log(message)
        table.insert(self.lines, {
            message = message,
            inserted_at = love.timer.getTime(),
        })
    end

    function debugger:update()
        local current_time = love.timer.getTime()
        local i = 1
        while i <= #self.lines do
            local line = self.lines[i]
            local age = current_time - line.inserted_at
            if age > self.line_max_age then
                table.remove(self.lines, i)
            else
                i = i + 1
            end
        end
    end

    function debugger:draw_extra_params(extra_params, extra_params_pos, extra_params_color)
        local pos = extra_params_pos or v2()
        local color = extra_params_color or color.White
        color:set()
        love.graphics.setFont(self.font)
        local longest_name = 0
        for _, param in ipairs(extra_params) do
            local name_length = self.font:getWidth(param[1])
            if name_length > longest_name then
                longest_name = name_length
            end
        end

        for _, param in ipairs(extra_params) do
            local key = param[1]
            local key_offset = (longest_name - self.font:getWidth(key))
            local value = param[2]
            if type(value) == "function" then
                value = value()
            end
            love.graphics.print(key .. " : " .. tostring(value), pos.x + key_offset, pos.y)
            pos.y = pos.y + self.line_height
        end
    end

    function debugger:draw(extra_params, extra_params_pos, extra_params_color)
        local pos = v2()

        if self.top_left_pos then
            pos = self.top_left_pos
        elseif self.bottom_left_pos then
            pos = self.bottom_left_pos - v2(0, self.max_lines * self.line_height)
        end

        local current_time = love.timer.getTime()

        -- Calculate the starting y position for the bottom-most message
        local start_y = pos.y + (self.max_lines - 1) * self.line_height

        -- Determine the range of messages to display
        local start_index = math.max(1, #self.lines - self.max_lines + 1)
        local end_index = #self.lines
        local half_age = self.line_max_age / 2

        love.graphics.setFont(self.font)

        for i = start_index, end_index do
            local line = self.lines[i]
            local age = current_time - line.inserted_at
            local alpha = 1

            if age > half_age then
                alpha = 1 - ((age - half_age) / half_age)
            end

            local y_position = start_y - (end_index - i) * self.line_height
            self.color:set_with_alpha(alpha)

            love.graphics.print(line.message, pos.x, y_position)
        end

        if extra_params then
            self:draw_extra_params(extra_params, extra_params_pos, extra_params_color)
        end
    end

    return debugger
end

return debug
