--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1
    self.frames = def.frames
    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end

    self.isConsumable = def.isConsumable or false
    self.canBeLifted = def.canBeLifted or false
    self.lifted = false
end

function GameObject:update(dt)
    
end

function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:lift(player)
    Timer.tween(0.465, {[self] = {y = player.y - self.height + 2, x = player.x}})
end

function GameObject:fire()

end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    if self.states then
        self.frame = self.states[self.state].frame
    end
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end