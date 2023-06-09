Powerup = Class{}

function Powerup:init(skin)
    -- simple positional and dimensional variables
    self.x = math.random(VIRTUAL_WIDTH) / 2 - 2
    self.y = 0

    self.width = 16
    self.height = 16

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the Powerup can move in two dimensions
    self.dx = 0
    self.dy = 35

    -- this will effectively be the color of our Powerup, and we will index
    -- our table of Quads relating to the global block texture using this
    self.skin = skin
    self.inPlay = false
end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    self.inPlay = false
    return true
end

function Powerup:update(dt)
    if math.random(100) < 20 then  -- % chance of getting a powerup
        if math.random(100) < 25 then -- if powerup, 25 % chance it's a key
            self.inPlay = true
        else
            self.inPlay = true --random powerup
        end
    end


    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Powerup:reset()
    self.x = math.random(200, VIRTUAL_WIDTH) / 2 - 2
    self.y = 2
    self.dx = 0
    self.dy = 35
end

function Powerup:render()
    -- gTexture is our global texture for all blocks
    -- gPowerupFrames is a table of quads mapping to each individual Powerup skin in the texture
    if self.inPlay == true then
        love.graphics.draw(gTextures['main'], gFrames['powerups'][self.skin],
        self.x, self.y)
    end
end