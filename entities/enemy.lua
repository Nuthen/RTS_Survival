Enemy = class('Enemy')

function Enemy:initialize(x, y, id)
	self.x = x
	self.y = y
	self.id = id+1
	
	self.health = 5
	
	self.radius = 8
	
	self.timer = 0
	
	self.target = {11, 11} -- core
	self:findPath()
	
	self.invis = false
	self.moving = false
	
	self.delete = false
end

function Enemy:findPath()
	--self.x = math.floor(self.x)
	--self.y = math.floor(self.y)

	self.path = game.pathfind:begin(game.map, {math.floor(self.x), math.floor(self.y)}, {11, 11})
end

function Enemy:update(dt)
	if not self.path then self:findPath() end
	
	if not self.invis then
		if self.path then
			if #self.path > 0 then
				if not self.moving then
					self.target = {self.path[#self.path][1], self.path[#self.path][2]}
					self.moving = true
					tween(.6, self, {x = self.target[1], y = self.target[2]}, linear, function()
						if game.enemies[self.id] then
							game.enemies[self.id].moving = false
						end
					end)
					self.path[#self.path] = nil
				end
			elseif not self.moving then -- reached core
				game.coreHealth = game.coreHealth - 1
				self.invis = true
				self.delete = true
			end
		end
	end
end

function Enemy:draw()
	local realX = (self.x-1)*32 + 16 -- tile size
	local realY = (self.y-1)*32 + 16
	
	love.graphics.setColor(200, 100, 20)
	if not self.invis then
		love.graphics.circle('fill', realX, realY, self.radius)
	end
end