local map = {}

function map.new_world(size)
    local world = {
        size = size,
        tiles = {},
        walls = {},
    }

    for x = 1, size.x do
        world.tiles[x] = {}
        for y = 1, size.y do
            world.tiles[x][y] = fortune.rand_int(1, 5)

            if fortune.rand_int(1, 10) == 1 then
                table.insert(world.walls, {
                    pos = v2(x, y),
                    type = fortune.rand_int(1, 3),
                })
            end
        end
    end

    function world:draw()
        tiles_drawn = 0
        local number_of_horizontal_tiles = math.ceil(data.screen.width / data.tile_size.x) + 2
        local number_of_vertical_tiles = math.ceil(data.screen.height / data.tile_size.y) + 2
        local top_left_tile = v2(math.max(1, math.floor(cam.pos.x / data.tile_size.x) - 1),
            math.max(1, math.floor(cam.pos.y / data.tile_size.y) - 1))
        local bottom_right_tile = v2(math.min(data.map_size.width, top_left_tile.x + number_of_horizontal_tiles),
            math.min(data.map_size.height, top_left_tile.y + number_of_vertical_tiles))
        for x = top_left_tile.x, bottom_right_tile.x do
            for y = top_left_tile.y, bottom_right_tile.y do
                local pos = v2((x - 1) * 16, (y - 1) * 16) - cam.pos
                pos.x = math.floor(pos.x)
                pos.y = math.floor(pos.y)
                -- spr["tiles:ground_" .. self.tiles[x][y]]:draw_to(pos)
                spr["tiles:stone_" .. self.tiles[x][y]]:draw_to(pos)

                tiles_drawn = tiles_drawn + 1
            end
        end

        for _, wall in pairs(self.walls) do
            local pos = v2((wall.pos.x - 1) * 16, (wall.pos.y - 1) * 16) - cam.pos
            pos.x = math.floor(pos.x)
            pos.y = math.floor(pos.y)
            spr["tiles:wall_" .. wall.type]:draw_to(pos)
            -- spr["tiles:wall_" .. wall.type]:draw_to(pos + v2(0, -1))
            -- spr["tiles:wall_" .. wall.type]:draw_to(pos + v2(0, -2))
        end
    end

    return world
end

return map
