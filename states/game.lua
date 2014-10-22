game = {}

function game:enter()
    self.map = Map:new(21, 21)
	self.pathfind = Pathfind:new()
	
	self.player = Player:new()
	
	self.coreHealth = 10
	
	self.timer = 0
	
	self.enemies = {}
	self.bullets = {}
	--table.insert(self.enemies, Enemy:new(11, 1))
end

function game:update(dt)
	self.player:update(dt)
	
	self.timer = self.timer + dt
	if self.timer > 1 then
		self.timer = 0
		table.insert(self.enemies, Enemy:new(1, 1, #self.enemies))
	end
	
	for k, bullet in pairs(self.bullets) do
		bullet:update(dt)
	end
	
	for k, enemy in pairs(self.enemies) do
		enemy:update(dt)
	end
	
	
	
	for i = #self.enemies, 1, -1 do
		local enemy = self.enemies[i]
		
		if enemy and enemy.delete then
			self.enemies[i].invis = true
		end
	end
	
	
	for i = #self.bullets, 1, -1 do
		local bullet = self.bullets[i]
		
		if bullet and bullet.delete then
			--self.bullets[i] = nil
			table.remove(self.bullets, i)
		end
	end
end

function game:mousepressed(x, y, button)
	if button == 'r' or button == 'm' then
		self.map:mousepressed(x, y, button)
		
		for k, enemy in pairs(self.enemies) do
			enemy:findPath()
		end
	end
	--if self.pathfind.state ~= 'init' then
	--	self.pathfind:begin(self.map)
	--end
	
	self.player:mousepressed(x, y, button)
end

function game:keypressed(key, isrepeat)
	if key == ' ' then
		if self.pathfind.state == 'init' then
			self.pathfind:begin(self.map)
		--elseif self.pathfind.state == 'ongoing' then
		--	self.pathfind:advance()
		end
	end
end

function game:draw()
    love.graphics.setFont(fontBold[16])
	
	self.map:draw()
	--self.pathfind:draw()
	
	for k, bullet in pairs(self.bullets) do
		bullet:draw()
	end
	
	for k, enemy in pairs(self.enemies) do
		enemy:draw()
	end
	
	self.player:draw()
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(love.timer.getFPS(), 5, 5)
	love.graphics.print('Core: '..self.coreHealth..'/10', 5, 25)
end