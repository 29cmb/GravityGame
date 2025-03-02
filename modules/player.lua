Player = {}

Player.CameraData = {
    ["CameraX"] = 0,
    ["CameraY"] = 0,
    ["CameraOffsetX"] = 400,
    ["CameraOffsetY"] = 200,
    ["CamSpeed"] = 300
}

Player.MovementData = {
    ["Speed"] = 9000,
    ["MaxSpeed"] = 400,
    ["Direction"] = -1,
    ["JumpHeight"] = 1800,
    ["OnGround"] = false,
}

local movementDirections = {a = {-1,0}, d = {1,0}, space = {0,-1}}
local cX, cY = 0, 0

local function lerp(a, b, t)
    return t < 0.5 and a + (b - a) * t or b + (a - b) * (1 - t)
end

function Player:Load(world)
    self.body = love.physics.newBody(world, 0, 0, "dynamic")
    self.body:setLinearDamping(1)
    self.shape = love.physics.newRectangleShape(50, 50)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("Player")
    self.fixture:setRestitution(0)
    self.fixture:setCategory(1)
    self.fixture:setMask(2)
end

function Player:Update(dt)
    self.MovementData.OnGround = false

    if not love.keyboard.isDown("space") then
        jumped = false
    end
    
    if #self.body:getContacts() >= 1 then -- should add wall jumping
        self.MovementData.OnGround = true
    end

    for key, data in pairs(movementDirections) do 
        if love.keyboard.isDown(key) then
            local impulseX = 0
            local impulseY = 0
            
            if key == "space" and self.MovementData.OnGround and not jumped then        
                impulseY = self.MovementData.JumpHeight * data[2]

                jumped = true
            else
                impulseX = self.MovementData.Speed * data[1] * dt
                
                if key == "a" then
                    self.MovementData.Direction = 1
                elseif key == "d" then
                    self.MovementData.Direction = -1
                end
            end
            
            self.body:applyLinearImpulse(impulseX, impulseY)
        end
    end

    local velX, velY = self.body:getLinearVelocity()
    
    if velX > self.MovementData.MaxSpeed then velX = self.MovementData.MaxSpeed 
    elseif velX < -self.MovementData.MaxSpeed then velX = -self.MovementData.MaxSpeed end

    self.body:setLinearVelocity(velX, velY)

    cX = lerp(cX, self.body:getX(), 0.1)
    cY = lerp(cY, self.body:getY(), 0.1)
    
    self.CameraData.CameraX = cX - self.CameraData.CameraOffsetX
    self.CameraData.CameraY = cY - self.CameraData.CameraOffsetY

    if self.body:getY() > 800 then 
        self.body:setLinearVelocity(0, 0)
        self.body:setTransform(Level.map.Start.x, Level.map.Start.y, 0)
    end
end

function Player:Draw()
    local spriteWidth = Sprites["Player"]:getWidth()
    local spriteHeight = Sprites["Player"]:getHeight()

    love.graphics.draw(
        Sprites["Player"], 
        self.body:getX() - self.CameraData["CameraX"], 
        self.body:getY() - self.CameraData["CameraY"], 
        self.body:getAngle(),
        1.5 * self.MovementData["Direction"], 
        1.5, 
        spriteWidth / 2, 
        spriteHeight / 2
    )

    local playerScreenX = self.body:getX() - self.CameraData["CameraX"]
    local playerScreenY = self.body:getY() - self.CameraData["CameraY"]

    local mX, mY = love.mouse.getPosition()
    local angle = math.atan2(mX - playerScreenX, -(mY - playerScreenY))

    love.graphics.draw(
        Sprites["Arrow"], 
        self.body:getX() - self.CameraData["CameraX"], 
        self.body:getY() - self.CameraData["CameraY"], 
        angle,
        1.5 * self.MovementData["Direction"], 
        1.5, 
        spriteWidth / 2, 
        spriteHeight / 2
    )

    love.graphics.draw(
        Sprites["Ring"], 
        self.body:getX() - self.CameraData["CameraX"], 
        self.body:getY() - self.CameraData["CameraY"], 
        self.body:getAngle(),
        1.5 * self.MovementData["Direction"], 
        1.5, 
        spriteWidth / 2, 
        spriteHeight / 2
    )
    
    love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end