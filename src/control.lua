-- controller is a singleton object responsible for managing the controllers (keyboard and joystick input)
local control = {}

function control.new_keyboard_controller(id, left, right, up, down, buttonA, buttonB)
    return {
        id = id,
        type = "keyboard",
        connected = true,
        baton = baton.new({
            controls = {
                left = { "key:" .. left },
                right = { "key:" .. right },
                up = { "key:" .. up },
                down = { "key:" .. down },
                buttonA = { "key:" .. buttonA },
                buttonB = { "key:" .. buttonB },
            },
            pairs = {
                move = { 'left', 'right', 'up', 'down' }
            },
        })
    }
end

function control.new_controller_manager(on_connect, on_disconnect, on_reconnect)
    local manager = {
        controllers = {},
        last_joystick_id = 0,
        on_connect = on_connect or function() end,
        on_disconnect = on_disconnect or function() end,
        on_reconnect = on_reconnect or function() end
    }

    function manager:init(controllers)
        self.controllers = controllers or {}
        for _, controller in ipairs(controllers) do
            self.on_connect(controller)
            debugger:log("Controller: " .. controller.type .. " initialized with ID: " .. controller.id)
        end
    end

    function manager:update()
        -- Register new Joysticks
        for _, joystick in ipairs(love.joystick.getJoysticks()) do
            local id = joystick:getID()
            if id > self.last_joystick_id then
                self.last_joystick_id = id

                local controller = {
                    id = id,
                    type = "joystick",
                    connected = true,
                    baton = baton.new({
                        controls = {
                            left = { "axis:leftx-", "button:dpleft" },
                            right = { "axis:leftx+", "button:dpright" },
                            up = { "axis:lefty-", "button:dpup" },
                            down = { "axis:lefty+", "button:dpdown" },
                            buttonA = { "button:a" },
                            buttonB = { "button:b" },
                        },
                        pairs = {
                            move = { 'left', 'right', 'up', 'down' }
                        },
                        joystick = joystick,
                        deadzone = data.joystick_dead_zone,
                    }),
                }

                table.insert(self.controllers, controller)

                debugger:log("Controller: " .. joystick:getName() .. " initialized with ID: " .. id)

                self.on_connect(controller)
            end
        end

        -- Update existing controllers
        for _, controller in pairs(self.controllers) do
            controller.baton:update()
            if controller.type == "joystick" then
                local id, instanceid = controller.baton.config.joystick:getID()
                if not instanceid and controller.connected then
                    debugger:log("Controller: " ..
                        controller.baton.config.joystick:getName() .. " removed with ID: " .. id)
                    controller.connected = false
                    self.on_disconnect(controller)
                end
                if instanceid and not controller.connected then
                    debugger:log("Controller: " ..
                        controller.baton.config.joystick:getName() .. " re-connected with ID: " .. id)
                    controller.connected = true
                    self.on_reconnect(controller)
                end
            end
        end
    end

    function manager:draw_to(pos)
        draw.rect_fill(pos, v2(300, #self.controllers * 24), { 0, 0, 0, 0.70 })
        love.graphics.setFont(assets.fonts.default)
        for i, controller in ipairs(self.controllers) do
            color.set_player_color(i)
            love.graphics.rectangle("line", pos.x + 2, pos.y + 2 + (i - 1) * 24, 20, 20)
            love.graphics.circle("line", pos.x + 12, pos.y + 12 + (i - 1) * 24, 10)
            love.graphics.setColor(color.White)
            love.graphics.print("P" .. i, pos.x + 24, pos.y + 4 + (i - 1) * 24)
            local joy = controller.baton.config.joystick
            local name = "keyboard"
            local x, y = 0, 0
            if controller.baton:get("left") > 0 then
                x = -1
            end
            if controller.baton:get("right") > 0 then
                x = x + 1
            end
            if controller.baton:get("up") > 0 then
                y = -1
            end
            if controller.baton:get("down") > 0 then
                y = y + 1
            end
            if joy then
                name = joy:getName()
                x = controller.baton:getRaw("right") - controller.baton:getRaw("left")
                y = controller.baton:getRaw("down") - controller.baton:getRaw("up")
            end
            love.graphics.print("P" .. i .. ": " .. name, pos.x + 24, pos.y + 4 + (i - 1) * 24)
            love.graphics.print("dir: " .. x .. ":" .. y, pos.x + 24, pos.y + 15 + (i - 1) * 24)
            color.set_player_color(i)
            love.graphics.circle((controller.baton:get("buttonA") == 1) and "fill" or "line", pos.x + 12 + x * 5,
                pos.y + 12 + y * 5 + (i - 1) * 24, 5)
        end
    end

    return manager
end

return control
