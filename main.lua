-- Import the Love 2D library
_G.love = require("love")

-- Import 3th party libraries
-- Import Push for virtual resolution
_G.push = require("lib.push")
-- Import Brinevector for 2D vector math
_G.v2 = require("lib.brinevector")
-- Import Baton for button and joystick handling
_G.baton = require("lib.baton")

-- Import our own modules
-- Import the constant data
_G.data = require("data")
_G.fortune = require("src.fortune")
_G.color = require("src.color")
_G.draw = require("src.draw")
_G.assets = require("src.assets")
_G.collide = require("src.collide")
_G.control = require("src.control")
_G.tank = require("src.tank")
_G.map = require("src.map")
_G.cam = require("src.camera")


_G.debug = require("src.debug")

function love.load()
    tiles_drawn = 0

    assets.load_all()

    world = map.new_world(v2(data.map_size.width, data.map_size.height))

    -- setup the Debugger, position its logger to the bottom left corner
    _G.debug_mode = true
    _G.debugger = debug.new_debugger({
        max_lines = 10,
        line_max_age = 10,
        bottom_left_pos = v2(2, data.screen.height)
    })

    -- setup Graphics
    love.mouse.setVisible(false)
    love.graphics.setLineWidth(1)
    love.graphics.setLineStyle("rough")
    love.graphics.setDefaultFilter("nearest")
    love.graphics.setFont(assets.fonts.default)

    -- setup Push with the virtual resolution based on data screen width and height
    local window_width, window_height = love.graphics.getDimensions()
    push:setupScreen(data.screen.width, data.screen.height, window_width, window_height, {
        fullscreen = false,
        resizable = true,
        highdpi = false,
        canvas = true,
        pixelperfect = false,
    })

    _G.mouse_pos = v2()

    _G.tanks = {}
    _G.next_player_index = 1

    -- Setup the control manager
    _G.control_man = control.new_controller_manager(function(controller)
        local colors = color.get_player_colors(next_player_index)
        next_player_index = next_player_index + 1
        table.insert(_G.tanks,
            tank.new(controller.baton, fortune.rand_v2_int(20, data.screen.width - 20, 20, data.screen.height - 20),
                v2(1, 0), {
                    colors[1],
                    colors[1],
                    colors[2],
                    colors[2],
                    colors[3] }))
    end)
    -- Init with keyboard1 and keyboard2
    _G.control_man:init({
        control.new_keyboard_controller("keyboard1",
            _G.data.controls.player1.left,
            _G.data.controls.player1.right,
            _G.data.controls.player1.up,
            _G.data.controls.player1.down,
            _G.data.controls.player1.buttonA,
            _G.data.controls.player1.buttonB),
        -- control.new_keyboard_controller("keyboard2",
        --     _G.data.controls.player2.left,
        --     _G.data.controls.player2.right,
        --     _G.data.controls.player2.up,
        --     _G.data.controls.player2.down,
        --     _G.data.controls.player2.buttonA,
        --     _G.data.controls.player2.buttonB),
    })
end

function love.resize(width, height)
    debugger:log("Window resized to width:" .. width .. " height:" .. height)

    push:resize(width, height)
end

function love.mousepressed(x, y, button)
    debugger:log("Mouse button: " .. button .. " pressed at: " .. mouse_pos.x .. ":" .. mouse_pos.y)
end

function love.mousereleased(x, y, button)
    debugger:log("Mouse button: " .. button .. " released at: " .. mouse_pos.x .. ":" .. mouse_pos.y)
end

function love.wheelmoved(x, y)
    debugger:log("Mouse wheel moved X:" .. x .. " Y:" .. y)
end

function love.keypressed(key)
    debugger:log("Key pressed:" .. key)

    if key == "escape" then
        love.event.quit()
    elseif key == "f1" then
        push:switchFullscreen()
    elseif key == "f2" then
        _G.debug_mode = not _G.debug_mode
    elseif key == "f3" then
        for _, tank in pairs(tanks) do
            tank:respawn()
        end
    end
end

function love.keyreleased(key)
    debugger:log("Key released:" .. key)
end

function love.update(dt)
    cam:update(dt)

    control_man:update()

    for _, tank in pairs(tanks) do
        for _, wall in ipairs(world.walls) do
            if tank:collide_with_box({
                    pos = v2((wall.pos.x - 1) * 16, (wall.pos.y - 1) * 16),
                    size = data.tile_size
                }) then
                tank.speed = tank.speed * -0.75
                break
            end
        end

        tank:update(dt)
    end

    -- update the mouse position
    local next_mouse_pos = mouse_pos:copy()
    local mouse_x, mouse_y = love.mouse.getPosition()
    local push_mouse_x, push_mouse_y = push:toGame(mouse_x, mouse_y)
    if push_mouse_x then
        next_mouse_pos.x = math.floor(push_mouse_x)
    end
    if push_mouse_y then
        next_mouse_pos.y = math.floor(push_mouse_y)
    end
    if mouse_pos:neq(next_mouse_pos) then
        mouse_pos = next_mouse_pos
        debugger:log("Mouse moved to: " .. mouse_pos.x .. ":" .. mouse_pos.y)
    end

    if debug_mode then
        debugger:update()
    end
end

function love.draw()
    push:apply("start")

    -- -- Calculate the camera position to center the tank
    -- local cameraPos = tanks[1].pos - (v2(data.screen.width, data.screen.height) / 2)

    -- -- Clamp the camera position so it doesn't scroll beyond the background
    -- cameraPos.x = math.max(0, math.min(cameraPos.x, 2000 - 480))
    -- cameraPos.y = math.max(0, math.min(cameraPos.y, 1495 - 270))


    world:draw()

    for _, tank in pairs(tanks) do
        tank:draw()
    end

    if debug_mode then
        local culsor = cam.pos + mouse_pos
        -- Draw the debugger's log messages and also an arbitary list of extra parameters that we want to see
        debugger:draw({
            { "FPS",         love.timer.getFPS },
            -- { "Push", function()
            --     local width, height = push:getDimensions()
            --     return width .. ":" .. height
            -- end },
            -- { "Window", function()
            --     local width, height = love.graphics.getDimensions()
            --     return width .. ":" .. height
            -- end },
            -- { "Scale",  string.format("%.2f", push._SCALE.x) },
            { "Tank",        tanks[1].pos.x .. ":" .. tanks[1].pos.y },
            { "Angle",       tanks[1].dir.angle },
            { "Sin",         math.sin(tanks[1].dir.angle) },
            { "Mouse",       mouse_pos.x .. ":" .. mouse_pos.y },
            { "Camera",      cam.pos.x .. ":" .. cam.pos.y },
            { "Culsor",      culsor.x .. ":" .. culsor.y },
            { "tiles drawn", tiles_drawn },
        }, v2(10, 10), color.Yellow)

        control_man:draw_to(v2(200, 10))
    end

    push:apply("end")
end
