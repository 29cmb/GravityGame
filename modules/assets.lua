Sprites = {
    ["Player"] = "assets/player.png",
    ["Arrow"] = "assets/arrow.png",
    ["Ring"] = "assets/ring.png",
    ["ButtonBase"] = "assets/ButtonBase.png",
    ["Crate"] = "assets/Crate.png"
}

function Sprites:LoadSprites()
    for i,v in pairs(self) do 
        if type(v) ~= "string" then goto continue end
        if not love.filesystem.getInfo(v) then
            print("Error: File '"..v.."' not found.")
            goto continue
        end

        self[i] = love.graphics.newImage(v)

        ::continue::
    end
end
