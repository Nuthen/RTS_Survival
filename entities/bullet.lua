Bullet = class('Bullet')

function Bullet:initialize(x, y, targetIndex) -- targetIndex must refer to an enemy
	self.x = x
	self.y = y
	
	self.targetIndex = targetIndex
	
	self.speed = 4 -- tiles per second
	
	self.delete = false
end

function Bullet:update(dt)
	local enemy = game.enemies[self.targetIndex]
	if not game.enemies[self.targetIndex] or game.enemies[self.targetIndex].delete then -- not doing anything
	--	self.delete = true
		self.targetIndex = nil
	else
		
		local angle = math.angle(self.x, self.y, enemy.x, enemy.y)
		
		self.x = self.x + math.cos(angle)*self.speed*dt
		self.y = self.y + math.sin(angle)*self.speed*dt
		
		if math.dist(self.x, self.y, enemy.x, enemy.y) < .2 then
			game.enemies[self.targetIndex].health = enemy.health - 1
			if game.enemies[self.targetIndex].health <= 0 then
				game.enemies[self.targetIndex].delete = true
			end
			
			self.delete = true
		end
	end
end

function Bullet:draw()
	local realX = (self.x-1)*32 + 16 -- tile size
	local realY = (self.y-1)*32 + 16

	love.graphics.setColor(0, 0, 255)
	love.graphics.circle('line', realX, realY, 5)
end