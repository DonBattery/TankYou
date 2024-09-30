local collide = {}

function collide.rect(x, y, w, h)
    return {
        pos = v2(x, y),
        size = v2(w, h)
    }
end

function collide.v2rect(pos, size)
    return {
        pos = pos:copy(),
        size = size:copy()
    }
end

function collide.circ(x, y, r)
    return {
        pos = v2(x, y),
        size = r
    }
end

function collide.v2circ(pos, size)
    return {
        pos = pos:copy(),
        size = size
    }
end

function collide.rect_vs_point(rect, point)
    if point.x < rect.pos.x then
        return false
    end
    if point.y < rect.pos.y then
        return false
    end
    if point.x > rect.pos.x + rect.size.x - 1 then
        return false
    end
    if point.y > rect.pos.y + rect.size.y - 1 then
        return false
    end
    return true
end

function collide.rect_vs_rect(rect1, rect2)
    if rect1.pos.x > rect2.pos.x + rect2.size.x - 1 then
        return false
    end
    if rect1.pos.y > rect2.pos.y + rect2.size.y - 1 then
        return false
    end
    if rect1.pos.x + rect1.size.x - 1 < rect2.pos.x then
        return false
    end
    if rect1.pos.y + rect1.size.y - 1 < rect2.pos.y then
        return false
    end
    return true
end

function collide.circ_vs_point(circ, point)
    local dx = circ.pos.x - point.x
    local dy = circ.pos.y - point.y
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance < circ.size
end

function collide.rect_vs_circ(rect, circ)
    local test_pos = circ.pos:copy()

    if circ.pos.x < rect.pos.x then
        test_pos.x = rect.pos.x
    elseif circ.pos.x > rect.pos.x + rect.size.x - 1 then
        test_pos.x = rect.pos.x + rect.size.x - 1
    end

    if circ.pos.y < rect.pos.y then
        test_pos.y = rect.pos.y
    elseif circ.pos.y > rect.pos.y + rect.size.y - 1 then
        test_pos.y = rect.pos.y + rect.size.y - 1
    end

    local dx = circ.pos.x - test_pos.x
    local dy = circ.pos.y - test_pos.y
    local distance = math.sqrt(dx * dx + dy * dy)

    return distance < circ.size
end

function collide.circ_vs_circ(circ1, circ2)
    local dx = circ1.pos.x - circ2.pos.x
    local dy = circ1.pos.y - circ2.pos.y
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance < circ1.size + circ2.size
end

return collide
