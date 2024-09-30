-- color provides convinient color creating functions and a translation of base palette to English names,
-- so we can refer to  our colors as: color.Black
-- Also here we have the list of the player's colors, and helper functions to get them, or set one of them as the drawing color.
local color = {}

-- create a new color from a #hexadecumal string or an "rgb(r,g,b)"" string or and rgba(r,g,b,a) string
function color.new(str, mul)
    mul = mul or 1
    local r, g, b, a
    r, g, b = str:match("#(%x%x)(%x%x)(%x%x)")

    if r then
        r = tonumber(r, 16) / 0xff
        g = tonumber(g, 16) / 0xff
        b = tonumber(b, 16) / 0xff
        a = 1
    elseif str:match("rgba?%s*%([%d%s%.,]+%)") then
        local f = str:gmatch("[%d.]+")
        r = (f() or 0) / 0xff
        g = (f() or 0) / 0xff
        b = (f() or 0) / 0xff
        a = f() or 1
    else
        error(("bad color string '%s'"):format(str))
    end

    local color = { r * mul, g * mul, b * mul, a * mul }

    function color:set()
        love.graphics.setColor(self)
    end

    function color:set_with_alpha(alpha)
        love.graphics.setColor(self[1], self[2], self[3], alpha)
    end

    function color:clone(newAlpha)
        return {
            self[1],
            self[2],
            self[3],
            newAlpha or self[4]
        }
    end

    function color:adjust(red, green, blue, alpha)
        return {
            self[1] * (red or 1),
            self[2] * (green or 1),
            self[3] * (blue or 1),
            self[4] * (alpha or 1)
        }
    end

    return color
end

-- Named colors
color.Null = color.new("#000000", 0)
color.Black = color.new("#000000")
color.White = color.new("#ffffff")

color.Red = color.new("#f53141")
color.LightRed = color.new("#eb5f6f")
color.LighterRed = color.new("#eb8793")
color.DarkRed = color.new("#9a0d27")
color.DarkerRed = color.new("#61051a")

color.Green = color.new("#15c24e")
color.LightGreen = color.new("#57db83")
color.LighterGreen = color.new("#8df397")
color.DarkGreen = color.new("#0b8a4b")
color.DarkerGreen = color.new("#074d3f")

color.Blue = color.new("#5185df")
color.LightBlue = color.new("#85b0eb")
color.LighterBlue = color.new("#84cdff")
color.DarkBlue = color.new("#37559a")
color.DarkerBlue = color.new("#1d2f55")

color.Yellow = color.new("#e69b22")
color.LightYellow = color.new("#ffcd38")
color.LighterYellow = color.new("#f3e064")
color.DarkYellow = color.new("#ce922a")
color.DarkerYellow = color.new("#8a6b28")

color.Purple = color.new("#a35dd9")
color.LightPurple = color.new("#ca7ef2")
color.LighterPurple = color.new("#e29bfa")
color.DarkPurple = color.new("#773bbf")
color.DarkerPurple = color.new("#4e278c")

color.Pink = color.new("#e35c9b")
color.LightPink = color.new("#f391ad")
color.LighterPink = color.new("#e7abc6")
color.DarkPink = color.new("#b32d7d")
color.DarkerPink = color.new("#852264")

color.Gray = color.new("#696570")
color.LightGray = color.new("#807980")
color.LighterGray = color.new("#a69a9c")
color.DarkGray = color.new("#495169")
color.DarkerGray = color.new("#0d2140")

color.Brown = color.new("#875d58")
color.LightBrown = color.new("#9e7767")
color.LighterBrown = color.new("#b58c7f")
color.DarkBrown = color.new("#6e4250")
color.DarkerBrown = color.new("#472e3e")

color.Lime = color.new("#b8e325")
color.LightLime = color.new("#ccef74")
color.LighterLime = color.new("#e2fba1")
color.DarkLime = color.new("#91b239")
color.DarkerLime = color.new("#506d19")

color.Orange = color.new("#ef7a2c")
color.LightOrange = color.new("#db8c56")
color.LighterOrange = color.new("#ebaa73")
color.DarkOrange = color.new("#ba521b")
color.DarkerOrange = color.new("#7d4230")

color.TransparentLime = color.new("#b8e325", 0.65)
color.TransparentOrange = color.new("#ef7a2c", 0.65)

-- The list of colospectrums of the players (up to 10).
color.player_colors = {
    -- pink
    { color.DarkerPink,   color.Pink,   color.LighterPink },

    -- green
    { color.DarkerGreen,  color.Green,  color.LighterGreen },

    -- blue
    { color.DarkerBlue,   color.Blue,   color.LighterBlue },

    -- brown
    { color.DarkerBrown,  color.Brown,  color.LighterBrown },

    -- yellow
    { color.DarkerYellow, color.Yellow, color.LighterYellow },

    -- purple
    { color.DarkerPurple, color.Purple, color.LighterPurple },

    -- red
    { color.DarkerRed,    color.Red,    color.LighterRed },

    -- gray
    { color.DarkerGray,   color.Gray,   color.LighterGray },

    -- orange
    { color.DarkerOrange, color.Orange, color.LighterOrange },

    -- lime
    { color.DarkerLime,   color.Lime,   color.LighterLime },
}

-- Placeholder colors for map objects
color.map_colors = {
    { color.LightPurple, color.DarkPurple }, -- air
    { color.LightGreen,  color.DarkGreen },  -- ground
    { color.LightBlue,   color.DarkBlue },   -- water
    { color.LighterBlue, color.LightBlue },  -- ice
    { color.LightRed,    color.Red },        -- spring
}

-- Get one of the player's colors (the 2th if not specified)
function color.get_player_color(id, color_num)
    return color.player_colors[id][color_num or 2]
end

-- Get a player's colors by playerindex
function color.get_player_colors(id)
    return color.player_colors[id]
end

-- Set a player's color by playerindex, as the drawing color
function color.set_player_color(id, color_num)
    color.player_colors[id][color_num or 2]:set()
end

return color
