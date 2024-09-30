local camera = {
    pos = v2(),
    map_size = v2(2000, 1495),
    screen_size = v2(data.screen.width, data.screen.height),
    half_screen = v2(data.screen.width / 2, data.screen.height / 2).floor(),
    scroll_speed = 7
}

function camera:update(dt)
    local edge = 100
    if mouse_pos.x < edge and self.pos.x > 0 then
        local percentage = edge - mouse_pos.x
        self.pos.x = self.pos.x - (self.scroll_speed / 100) * percentage
    end
    if mouse_pos.x > data.screen.width - edge and self.pos.x < self.map_size.x - self.screen_size.x then
        local percentage = edge - (data.screen.width - mouse_pos.x)
        self.pos.x = self.pos.x + (self.scroll_speed / 100) * percentage
    end
    if mouse_pos.y < edge and self.pos.y > 0 then
        local percentage = edge - mouse_pos.y
        self.pos.y = self.pos.y - (self.scroll_speed / 100) * percentage
    end
    if mouse_pos.y > data.screen.height - edge and self.pos.y < self.map_size.y - self.screen_size.y then
        local percentage = edge - (data.screen.height - mouse_pos.y)
        self.pos.y = self.pos.y + (self.scroll_speed / 100) * percentage
    end


    -- if mouse_pos.x == 0 and self.pos.x > 0 then
    --     self.pos.x = self.pos.x - self.scroll_speed
    -- end
    -- if mouse_pos.x == self.screen_size.x - 1 and self.pos.x < self.map_size.x - self.screen_size.x then
    --     self.pos.x = self.pos.x + self.scroll_speed
    -- end
    -- if mouse_pos.y == 0 and self.pos.y > 0 then
    --     self.pos.y = self.pos.y - self.scroll_speed
    -- end
    -- if mouse_pos.y == self.screen_size.y - 1 and self.pos.y < self.map_size.y - self.screen_size.y then
    --     self.pos.y = self.pos.y + self.scroll_speed
    -- end

    local tank_pos = tanks[1].pos

    if tank_pos.x < self.pos.x then
        self.pos.x = tank_pos.x
    end
    if tank_pos.x > self.pos.x + self.screen_size.x then
        self.pos.x = tank_pos.x - self.screen_size.x
    end
    if tank_pos.y < self.pos.y then
        self.pos.y = tank_pos.y
    end
    if tank_pos.y > self.pos.y + self.screen_size.y then
        self.pos.y = tank_pos.y - self.screen_size.y
    end
end

return camera
