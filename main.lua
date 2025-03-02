local world = love.physics.newWorld(0, 1000, true)
require("modules.assets")
require("modules.player")
require("modules.level")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    Sprites:LoadSprites()
    Player:Load(world)
    Level:Initialize(world)
    Level:LoadLevel(require("levels.Level1"))
end

function love.draw()
    Level:Draw()
    Player:Draw()
end

function love.update(dt)
    world:update(dt)
    Player:Update(dt)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        Player:Click()
    end
end