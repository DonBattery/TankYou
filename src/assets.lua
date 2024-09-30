local assets = {
    images = {},
    fonts = {},
    quads = {},
}

assets.load_all = function()
    assets.register_images(data.sprite_sheets)
    assets.register_quads(data.quads)
    assets.register_fonts(data.fonts)

    _G.spr = {}
    for quad_name, quad in pairs(data.quads) do
        spr[quad.sprite_sheet .. ":" .. quad_name] = assets.new_sprite(quad.sprite_sheet, quad_name,
            color.white)
    end
end

assets.register_font = function(font_name, font_path, font_size)
    assets.fonts[font_name] = love.graphics.newFont(font_path, font_size)
end

assets.register_fonts = function(fonts)
    for font_name, font in pairs(fonts) do
        assets.register_font(font_name, font.path, font.size)
    end
end

assets.register_image = function(image_name, image_path)
    assets.images[image_name] = love.graphics.newImage(image_path)
end

assets.register_images = function(images)
    for image_name, image_path in pairs(images) do
        assets.register_image(image_name, image_path)
    end
end

assets.register_quad = function(image_name, quad_name, pos, size)
    assets.quads[quad_name] = love.graphics.newQuad(pos.x, pos.y, size.x, size.y,
        assets.images[image_name]:getDimensions())
end

assets.register_quads = function(quads)
    for quad_name, quad in pairs(quads) do
        assets.register_quad(quad.sprite_sheet, quad_name, quad.pos, quad.size)
    end
end

-- Create a new Sprite object based on an image and a quad name. We can later use this Sprite to draw to the screen.
assets.new_sprite = function(image_name, quad_name, color)
    local new_sprite = {
        image = assets.images[image_name],
        quad = assets.quads[quad_name],
        color = color,
    }

    function new_sprite:draw_to(pos, color)
        if color then
            love.graphics.setColor(color)
        elseif self.color then
            love.graphics.setColor(self.color)
        end
        love.graphics.draw(self.image, self.quad, pos.x, pos.y)
    end

    function new_sprite:draw(pos, direction, scale, origin, color)
        if color then
            love.graphics.setColor(color)
        elseif self.color then
            love.graphics.setColor(self.color)
        end
        local orientation = math.atan2(direction.y, direction.x)
        love.graphics.draw(self.image, self.quad, pos.x, pos.y, orientation, scale.x, scale.y, origin.x, origin.y)
    end

    return new_sprite
end

assets.new_sprite_batch = function(image_name, size)
    local new_sprite_batch = {
        batch = love.graphics.new_spriteBatch(assets.images[image_name], size),
    }

    new_sprite_batch.clear = function(self)
        self.batch:clear()
    end

    new_sprite_batch.add = function(self, quad_name, pos, scale, color)
        scale = scale or v2(1, 1)
        if color then
            self.batch:setColor(color[1], color[2], color[3], color[4])
        end
        self.batch:add(assets.quads[quad_name], pos.x, pos.y, 0, scale.x, scale.y)
    end

    new_sprite_batch.draw = function(self, color)
        if color then
            love.graphics.setColor(color)
        end
        love.graphics.draw(self.batch, 0, 0)
    end

    new_sprite_batch.draw_to = function(self, pos, color)
        if color then
            love.graphics.setColor(color)
        end
        love.graphics.draw(self.batch, pos.x, pos.y)
    end

    return new_sprite_batch
end

return assets
