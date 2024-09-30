return {
    screen = {
        width = 480,
        height = 270
    },
    -- screen = {
    --     width = 320,
    --     height = 200
    -- },

    tile_size = v2(16, 16),

    map_size = {
        width = 100,
        height = 100,
    },

    -- Keyboard and joystick controlls
    joystick_dead_zone = 0.25,

    controls = {
        player1 = {
            left = "left",
            right = "right",
            up = "up",
            down = "down",
            buttonA = "n",
            buttonB = "m",
        },
        player2 = {
            left = "a",
            right = "d",
            up = "w",
            down = "s",
            buttonA = "1",
            buttonB = "2",
        }
    },

    sprite_sheets = {
        ui = "assets/graphics/ui.png",
        tanks = "assets/graphics/tanks.png",
        background1 = "assets/graphics/background1.png",
        tiles = "assets/graphics/tiles.png",
    },

    quads = {
        -- Tile Quads
        ground_1 = {
            sprite_sheet = "tiles",
            pos = v2(0, 0),
            size = v2(16, 16),
        },

        ground_2 = {
            sprite_sheet = "tiles",
            pos = v2(16, 0),
            size = v2(16, 16),
        },

        ground_3 = {
            sprite_sheet = "tiles",
            pos = v2(32, 0),
            size = v2(16, 16),
        },

        ground_4 = {
            sprite_sheet = "tiles",
            pos = v2(48, 0),
            size = v2(16, 16),
        },

        ground_5 = {
            sprite_sheet = "tiles",
            pos = v2(64, 0),
            size = v2(16, 16),
        },

        wall_1 = {
            sprite_sheet = "tiles",
            pos = v2(0, 16),
            size = v2(16, 16),
        },

        wall_2 = {
            sprite_sheet = "tiles",
            pos = v2(16, 16),
            size = v2(16, 16),
        },

        wall_3 = {
            sprite_sheet = "tiles",
            pos = v2(32, 16),
            size = v2(16, 16),
        },

        stone_1 = {
            sprite_sheet = "tiles",
            pos = v2(0, 32),
            size = v2(16, 16),
        },

        stone_2 = {
            sprite_sheet = "tiles",
            pos = v2(16, 32),
            size = v2(16, 16),
        },

        stone_3 = {
            sprite_sheet = "tiles",
            pos = v2(32, 32),
            size = v2(16, 16),
        },

        stone_4 = {
            sprite_sheet = "tiles",
            pos = v2(48, 32),
            size = v2(16, 16),
        },

        stone_5 = {
            sprite_sheet = "tiles",
            pos = v2(64, 32),
            size = v2(16, 16),
        },

        -- Background Quads
        -- bg1 = {
        --     sprite_sheet = "background1",
        --     pos = v2(0, 0),
        --     size = v2(2000, 1495),
        -- },

        -- Spritesheet Quads
        head_1 = {
            sprite_sheet = "tanks",
            pos = v2(0, 0),
            size = v2(9, 9),
        },
        head_2 = {
            sprite_sheet = "tanks",
            pos = v2(16, 0),
            size = v2(11, 11),
        },
        head_3 = {
            sprite_sheet = "tanks",
            pos = v2(32, 0),
            size = v2(13, 13),
        },
        body_3 = {
            sprite_sheet = "tanks",
            pos = v2(0, 16),
            size = v2(16, 11),
        },

        -- Tank Quads
        tankbody_1 = {
            sprite_sheet = "tanks",
            pos = v2(0, 32),
            size = v2(21, 17),
        },

        tankbody_2 = {
            sprite_sheet = "tanks",
            pos = v2(32, 32),
            size = v2(21, 17),
        },

        tankbody_3 = {
            sprite_sheet = "tanks",
            pos = v2(64, 32),
            size = v2(21, 17),
        },
        -- tankbody_1 = {
        --     sprite_sheet = "tanks",
        --     pos = v2(48, 16),
        --     size = v2(21, 15),
        -- },

        -- tankbody_2 = {
        --     sprite_sheet = "tanks",
        --     pos = v2(80, 16),
        --     size = v2(21, 15),
        -- },

        -- tankbody_3 = {
        --     sprite_sheet = "tanks",
        --     pos = v2(112, 16),
        --     size = v2(21, 15),
        -- },

        tankbody = {
            sprite_sheet = "tanks",
            pos = v2(0, 32),
            size = v2(21, 17),
        },

        -- tanktower = {
        --     sprite_sheet = "tanks",
        --     pos = v2(32, 16),
        --     size = v2(16, 11),
        -- },

        tanktower = {
            sprite_sheet = "tanks",
            pos = v2(0, 64),
            size = v2(25, 13),
        },

        -- UI Quads
        hamburger_off = {
            sprite_sheet = "ui",
            pos = v2(0, 0),
            size = v2(8, 8)
        },

        hamburger_on = {
            sprite_sheet = "ui",
            pos = v2(8, 0),
            size = v2(8, 8)
        },

        sprite_sheet_off = {
            sprite_sheet = "ui",
            pos = v2(16, 0),
            size = v2(8, 8),
        },

        sprite_sheet_on = {
            sprite_sheet = "ui",
            pos = v2(24, 0),
            size = v2(8, 8),
        },

        sprite_off = {
            sprite_sheet = "ui",
            pos = v2(32, 0),
            size = v2(8, 8),
        },

        sprite_on = {
            sprite_sheet = "ui",
            pos = v2(40, 0),
            size = v2(8, 8),
        },

        data_off = {
            sprite_sheet = "ui",
            pos = v2(48, 0),
            size = v2(8, 8),
        },

        data_on = {
            sprite_sheet = "ui",
            pos = v2(56, 0),
            size = v2(8, 8),
        },

        anim_off = {
            sprite_sheet = "ui",
            pos = v2(64, 0),
            size = v2(8, 8),
        },

        anim_on = {
            sprite_sheet = "ui",
            pos = v2(72, 0),
            size = v2(8, 8),
        },

        import_off = {
            sprite_sheet = "ui",
            pos = v2(80, 0),
            size = v2(8, 8),
        },

        import_on = {
            sprite_sheet = "ui",
            pos = v2(88, 0),
            size = v2(8, 8),
        },

        fullscreen_off = {
            sprite_sheet = "ui",
            pos = v2(96, 0),
            size = v2(8, 8),
        },

        fullscreen_on = {
            sprite_sheet = "ui",
            pos = v2(104, 0),
            size = v2(8, 8),
        },

        shutdown_off = {
            sprite_sheet = "ui",
            pos = v2(112, 0),
            size = v2(8, 8),
        },

        shutdown_on = {
            sprite_sheet = "ui",
            pos = v2(120, 0),
            size = v2(8, 8),
        },

        export_off = {
            sprite_sheet = "ui",
            pos = v2(128, 0),
            size = v2(8, 8),
        },

        export_on = {
            sprite_sheet = "ui",
            pos = v2(136, 0),
            size = v2(8, 8),
        },
    },

    fonts = {
        default = {
            path = "assets/fonts/55.ttf",
            size = 5
        }
    }
}
