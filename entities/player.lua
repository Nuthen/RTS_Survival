Player = class('Player')

function Player:initialize()
	self.x = 10
	self.y = 10
	
	self.radius = 10
	
	self.target = {}
	self.path = {}
	
	self.enemyTarget = {}
	
	self.moving = false
	
	self.fireRate = .15 -- seconds
	self.fireTimer = 0
end

function Player:mousepressed(x, y, button)
	if button == 'l' and not self.moving then
		if x >= 0 and y >= 0 and x <= game.map.realWidth and y <= game.map.realHeight then -- not sure if it goes to 0 or to the width/height
			local tileX = math.ceil(x / game.map.tileWidth)
			local tileY = math.ceil(y / game.map.tileHeight)
			
			if self.x ~= tileX and self.y ~= tileY then
				self.target = {tileX, tileY}
				self.path = game.pathfind:begin(game.map, {self.x, self.y}, {tileX, tileY})
				-- bug: cannot move vertically or horizontally
				--error(dump(self.path))
			end
		end
	end
end

function Player:update(dt)
	self.fireTimer = self.fireTimer + dt

	if self.path then
		if #self.path > 0 and not self.moving then
			self.target = {self.path[#self.path][1], self.path[#self.path][2]}
			self.moving = true
			tween(.3, self, {x = self.target[1], y = self.target[2]}, 'linear', function()
				game.player.moving = false
			end)
			self.path[#self.path] = nil
		end
	end
	
	local dist, targetEnemy, index = 1000, nil, 0
	
	for i = 1, #game.enemies do
		local enemy = game.enemies[i]
		if enemy then
			if math.dist(self.x, self.y, enemy.x, enemy.y) < 2 and not enemy.invis and not enemy.delete then -- in range
				if #enemy.path < dist then -- finds enemy closest to the core
					dist = #enemy.path
					targetEnemy = enemy
					index = i
				end
			end
		end
	end
	
	if targetEnemy then
		self.targetEnemy = targetEnemy
		
		if self.fireTimer > self.fireRate then
			self.fireTimer = 0
			table.insert(game.bullets, Bullet:new(self.x, self.y, index))
		end
	else
		self.targetEnemy = nil
	end
end

function Player:draw()
	local realX = (self.x-1)*32 + 16 -- tile size
	local realY = (self.y-1)*32 + 16
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle('fill', realX, realY, self.radius)
	
	love.graphics.setLineWidth(2)
	
	
	if self.targetEnemy then
		love.graphics.line(realX, realY, (self.targetEnemy.x-1)*32+16, (self.targetEnemy.y-1)*32+16)
	end
	
	love.graphics.setColor(255, 0, 0)
	
	love.graphics.circle('line', realX, realY, 2*32)
	
end