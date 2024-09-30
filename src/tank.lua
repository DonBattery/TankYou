local tank = {}

function tank.new(joy, pos, dir, colors)
    local default_colorA = color.get_player_color(1, 1)
    local default_colorB = color.get_player_color(1, 3)
    local new_tank = {
        joy = joy,
        colors = colors or { default_colorA, default_colorA, default_colorA, default_colorB, default_colorB },
        pos = pos or v2(64, 64),
        dir = dir or v2(1, 0),
        speed = 45,
        length = 100,
        segments = {},
        dead = false,
        tick = 0,
        anim = 1
    }

    function new_tank:respawn()
        self.pos = fortune.rand_v2_int(20, data.screen.width - 20, 20, data.screen.height - 20)
        self.dir = v2(1, 0):nrotated(math.random())
        self.speed = 45
        self.length = 100
        self.segments = {}
        self.dead = false
    end

    function new_tank:get_rotated_corners()
        local angle = self.dir.angle
        local cos_angle = math.cos(angle)
        local sin_angle = math.sin(angle)
        local hw = 18 / 2
        local hh = 14 / 2

        -- Corner offsets before rotation
        local corners = {
            { -hw, -hh }, -- top-left
            { hw,  -hh }, -- top-right
            { hw,  hh },  -- bottom-right
            { -hw, hh }   -- bottom-left
        }

        -- Rotate corners
        for i = 1, 4 do
            local cx = corners[i][1]
            local cy = corners[i][2]
            corners[i][1] = self.pos.x + cx * cos_angle - cy * sin_angle
            corners[i][2] = self.pos.y + cx * sin_angle + cy * cos_angle
        end

        return corners
    end

    function new_tank:collide_with_box(box)
        local tank_corners = self:get_rotated_corners()

        -- Get axes to project onto (normals of rectangle edges)
        local axes = {
            { 1, 0 }, -- x-axis for AABB
            { 0, 1 }, -- y-axis for AABB
        }

        -- Add tank rectangle axes (normals of its edges)
        for i = 1, 4 do
            local j = (i % 4) + 1
            local edge_x = tank_corners[j][1] - tank_corners[i][1]
            local edge_y = tank_corners[j][2] - tank_corners[i][2]
            table.insert(axes, { -edge_y, edge_x }) -- Normal to the edge
        end

        -- Function to project a point onto an axis
        local function project_point_to_axis(px, py, axis)
            return px * axis[1] + py * axis[2]
        end

        -- Function to get min and max projections of a rectangle on an axis
        local function project_rect_to_axis(corners, axis)
            local min_proj = project_point_to_axis(corners[1][1], corners[1][2], axis)
            local max_proj = min_proj
            for i = 2, 4 do
                local proj = project_point_to_axis(corners[i][1], corners[i][2], axis)
                min_proj = math.min(min_proj, proj)
                max_proj = math.max(max_proj, proj)
            end
            return min_proj, max_proj
        end

        -- Function to project box onto an axis
        local function project_box(box, axis)
            local points = {
                { box.pos.x,              box.pos.y },
                { box.pos.x + box.size.x, box.pos.y },
                { box.pos.x,              box.pos.y + box.size.y },
                { box.pos.x + box.size.x, box.pos.y + box.size.y }
            }
            local min_proj = project_point_to_axis(points[1][1], points[1][2], axis)
            local max_proj = min_proj
            for i = 2, 4 do
                local proj = project_point_to_axis(points[i][1], points[i][2], axis)
                min_proj = math.min(min_proj, proj)
                max_proj = math.max(max_proj, proj)
            end
            return min_proj, max_proj
        end

        -- Check each axis
        for i = 1, #axes do
            local axis = axes[i]
            local min_tank, max_tank = project_rect_to_axis(tank_corners, axis)
            local min_aabb, max_aabb = project_box(box, axis)
            if max_tank < min_aabb or max_aabb < min_tank then
                return false -- No overlap on this axis, so no collision
            end
        end

        return true -- Overlap on all axes, so collision
    end

    function new_tank:update(dt)
        if self.dead then return end

        local is_rot = false
        if self.joy:get("left") > 0 then
            is_rot = true
            self.dir = self.dir:nrotated(-0.01)
        end
        if self.joy:get("right") > 0 then
            is_rot = true
            self.dir = self.dir:nrotated(0.01)
        end

        if self.joy:get("up") > 0 then
            self.speed = self.speed + 1
            if self.speed > 100 then
                self.speed = 100
            end
        elseif self.joy:get("down") > 0 then
            self.speed = self.speed - 2
            if self.speed < -50 then
                self.speed = -50
            end
        else
            self.speed = self.speed * 0.97
            if math.abs(self.speed) < 0.5 then
                self.speed = 0
            end
        end

        if is_rot or math.abs(self.speed) > 5 then
            self.tick = self.tick + dt
        end
        if self.tick >= 0.065 then
            self.tick = 0
            if self.speed > 0 then
                self.anim = self.anim + 1
                if self.anim > 3 then
                    self.anim = 1
                end
            else
                self.anim = self.anim - 1
                if self.anim < 1 then
                    self.anim = 3
                end
            end
        end

        self.pos = self.pos + self.dir * self.speed * dt
        local prev_segment = self.segments[#self.segments]
        if not prev_segment or prev_segment.pos:dist(self.pos) > 0.75 then
            table.insert(self.segments, {
                pos = self.pos:copy(),
                dir = self.dir:copy()
            })
            if #self.segments > self.length then
                table.remove(self.segments, 1)
            end
        end

        -- if self.pos.x < 1 or self.pos.x > data.screen.width or self.pos.y < 1 or self.pos.y > data.screen.height then
        --     self.dead = true
        -- end
        -- if self.pos.x < 0 then
        --     self.pos.x = data.screen.width
        -- end
        -- if self.pos.x > data.screen.width then
        --     self.pos.x = 0
        -- end
        -- if self.pos.y < 0 then
        --     self.pos.y = data.screen.height
        -- end
        -- if self.pos.y > data.screen.height then
        --     self.pos.y = 0
        -- end

        -- local len = #self.segments
        -- for index, segment in pairs(self.segments) do
        --     if index < len - 2 and segment:dist(self.pos) < 2.5 then
        --         self.dead = true
        --     end
        -- end

        for _, tank in pairs(tanks) do
            if tank ~= self then
                for index, segment in pairs(tank.segments) do
                    if segment.pos:dist(self.pos) < 1 then
                        self.dead = true
                    end
                end
            end
        end

        -- for w in all(tanks) do
        --     if w ~= self then
        --         for index, segment in pairs(w.segments) do
        --             if segment:dist(self.pos) < 1 then
        --                 self.dead = true
        --             end
        --         end
        --     end
        -- end

        -- for f in all(foods) do
        --     if f.pos:dist(self.pos) < f.size + 1 then
        --         self.length += f.size * 3
        --         del(foods, f)
        --         new_food(randint(3, 7))
        --     end
        -- end
    end

    function new_tank:draw()
        local number_of_segments = #self.segments

        -- for i, segment in pairs(self.segments) do
        --     if i < (number_of_segments - 3) and i % 5 == 0 then
        --         spr["tanks:body_3"]:draw(segment.pos, segment.dir, v2(1, 1), v2(6, 6), color.White)
        --     end
        -- end

        -- for i = number_of_segments, 1, -1 do
        --     local s = self.segments[i]
        --     -- draw.circ_fill(s, 1, self.colors[i % #self.colors + 1])
        --     if i < (number_of_segments - 6) and i % 4 == 0 then
        --         spr["tanks:body_3"]:draw(s.pos, s.dir, v2(1, 1), v2(6, 6), color.White)
        --     end
        -- end

        local pos = self.pos - cam.pos
        local mouse_dir = mouse_pos - pos
        local tower_origin = pos + self.dir.normalized * 2

        draw.line(tower_origin, mouse_pos, color.TransparentOrange)

        -- spr["tanks:tankbody"]:draw(self.pos, self.dir, v2(1, 1), v2(10, 8), color.White)
        spr["tanks:tankbody_" .. self.anim]:draw(pos + v2(0, 2), self.dir, v2(1, 1), v2(10, 8), color.White)
        spr["tanks:tankbody_" .. self.anim]:draw(pos + v2(0, 1), self.dir, v2(1, 1), v2(10, 8), color.White)
        spr["tanks:tankbody_" .. self.anim]:draw(pos, self.dir, v2(1, 1), v2(10, 8), color.White)



        spr["tanks:tanktower"]:draw(tower_origin + v2(0, 1), mouse_dir, v2(1, 1), v2(7, 6), color.White)
        spr["tanks:tanktower"]:draw(tower_origin, mouse_dir, v2(1, 1), v2(7, 6), color.White)

        if self.dead then
            draw.circ_fill(pos, 3, color.Red)
        end

        -- draw.px(pos, color.LightYellow)
        -- draw.px(tower_origin, color.LightBlue)
    end

    return new_tank
end

return tank
