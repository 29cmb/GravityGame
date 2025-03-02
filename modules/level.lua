Level = {}
Level.map = {}

function Level:Initialize(world)
    self.world = world
end

function Level:LoadLevel(data)
    if data.Start then self.map.Start = data.Start end
    for _,platform in pairs(data.Platforms) do 
        local body = love.physics.newBody(self.world, platform.x + (platform.w / 2), platform.y + (platform.h / 2), "static")
        local shape = love.physics.newRectangleShape(platform.w, platform.h)
        local fixture = love.physics.newFixture(body, shape)
        fixture:setUserData("Platform")

        table.insert(self.map, {
            ["body"] = body,
            ["shape"] = shape,
            ["fixture"] = fixture,
            ["transform"] = {platform.x, platform.y, platform.w, platform.h},
            ["color"] = {R = platform.color.R, G = platform.color.G, B = platform.color.B},
            ["type"] = "Platform"
        })
    end

    for _,button in pairs(data.Buttons) do 
        local body = love.physics.newBody(self.world, button.x + (45 / 2), button.y + 35, "static")
        local shape = love.physics.newRectangleShape(45, 20)
        local fixture = love.physics.newFixture(body, shape)
        fixture:setUserData("Button")

        table.insert(self.map, {
            ["body"] = body,
            ["shape"] = shape,
            ["fixture"] = fixture,
            ["transform"] = {button.x, button.y},
            ["type"] = "Button",
            ["active"] = false
        })
    end

    for _,crate in pairs(data.Crates) do 
        local body = love.physics.newBody(self.world, crate.x + (50 / 2), crate.y + (50 / 2), "dynamic")
        local shape = love.physics.newRectangleShape(50, 50)
        local fixture = love.physics.newFixture(body, shape)
        body:setGravityScale(0.5)
        body:setLinearDamping(1)
        fixture:setRestitution(0)
        fixture:setUserData("Crate")

        table.insert(self.map, {
            ["body"] = body,
            ["shape"] = shape,
            ["fixture"] = fixture,
            ["transform"] = {crate.x, crate.y},
            ["type"] = "Crate"
        })
    end
end

function Level:Draw()
    if #self.map == 0 then return end

    for _,v in pairs(self.map) do 
        if v.type == "Platform" then 
            love.graphics.setColor(v.color.R, v.color.G, v.color.B)
            love.graphics.rectangle("fill", v.transform[1] - Player.CameraData.CameraX, v.transform[2] - Player.CameraData.CameraY, v.transform[3], v.transform[4])
            love.graphics.polygon("line", v.body:getWorldPoints(v.shape:getPoints()))
            love.graphics.setColor(1, 1, 1)
        end

        if v.type == "Button" then 
            local color = v.active == true and {0,1,0} or {1,0,0}
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill", (v.transform[1] - Player.CameraData.CameraX) + 2.25, (v.transform[2] - Player.CameraData.CameraY) + 25, 40, 10)
            love.graphics.polygon("line", v.body:getWorldPoints(v.shape:getPoints()))
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(Sprites["ButtonBase"], (v.transform[1] - Player.CameraData.CameraX), v.transform[2] - Player.CameraData.CameraY, 0, 1.4, 1.4)
        end

        if v.type == "Crate" then 
            love.graphics.setColor(0,0,1)
            love.graphics.polygon("line", v.body:getWorldPoints(v.shape:getPoints()))
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(Sprites["Crate"], (v.body:getX() - Player.CameraData.CameraX) - (50/2), (v.body:getY() - Player.CameraData.CameraY) - (40/2), 0, 1.4, 1.4)
        end
    end
end

function Level:ActivateButton(body)
    for _,v in pairs(self.map) do 
        if v.type == "Button" and v.body == body then 
            v.active = true
        end
    end
end