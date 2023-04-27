--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{__includes = GameObject}

function Projectile:init(object, direction)
    self.texture = object.texture
    self.frame = object.frame or 1
    self.x = object.x
    self.y = object.y
    self.width = object.width
    self.height = object.height
    self.throwSpeed = 100
    self.maxThrowDistance = TILE_SIZE * 4

    self.dx, self.dy = 0, 0
    self.thrownDistance = 0
    self.destroy = false

    if direction == 'left' then
        self.dx = -self.throwSpeed
    elseif direction == 'right' then
        self.dx = self.throwSpeed
    elseif direction == 'up' then
        self.dy = -self.throwSpeed
    elseif direction == 'down' then
        self.dy = self.throwSpeed
    end
end

function Projectile:update(dt)
    self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

    self.thrownDistance = self.thrownDistance + math.abs(self.dy + self.dx) * dt
	if self.thrownDistance > self.maxThrowDistance or
		self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE / 4 or
		self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE or
		self.y < MAP_RENDER_OFFSET_Y + TILE_SIZE - 22 --[[Player height - not sure best way to reference it from here--]] 
														/ 2 - self.height or
		self.y + self.height / 4 >= VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE) 
            + MAP_RENDER_OFFSET_Y - TILE_SIZE then

		self.destroy = true
	end
end

function Projectile:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end