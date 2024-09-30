local draw = {}

function draw.px(position, color)
    color = color or color.White
    love.graphics.setColor(color)
    love.graphics.points(position.x, position.y)
end

function draw.line(position1, position2, color)
    color = color or color.White
    love.graphics.setColor(color)
    love.graphics.line(position1.x, position1.y, position2.x, position2.y)
end

function draw.rect(position, size, color)
    if size.x < 0.1 or size.y < 0.1 then
        return
    end

    color = color or color.White
    love.graphics.setColor(color)
    love.graphics.rectangle("line", position.x + 0.01, position.y + 0.01, size.x - 0.01, size.y - 0.01)
end

function draw.rect_fill(position, size, color)
    if size.x < 0.1 or size.y < 0.1 then
        return
    end

    color = color or color.White
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", position.x + 0.01, position.y + 0.01, size.x - 0.1, size.y - 0.1)
end

function draw.circ(position, radius, color)
    color = color or color.White
    love.graphics.setColor(color)
    love.graphics.circle("line", position.x, position.y, radius)
end

function draw.circ_fill(position, radius, color)
    color = color or color.White
    love.graphics.setColor(color)
    love.graphics.circle("fill", position.x, position.y, radius)
end

return draw
