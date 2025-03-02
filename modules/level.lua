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
    end
end