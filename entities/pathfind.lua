Pathfind = class('Pathfind')

function Pathfind:initialize()
	self.frontier = {}
	self.state = 'init'
	self.count = 1
	
	self.path = {}
	
	self.map = nil
end

function Pathfind:begin(map, start, finish)
	self.frontier = {}
	self.state = 'init'
	self.count = 1
	
	self.path = {}
	
	self.map = nil


	self.map = map
	self.state = 'ongoing'

	self.start = start or {}
	self.finish = finish or {}
	
	self.nodes = {}

	for iy = 1, map.height do
		for ix = 1, map.width do
			local tile = map.tiles[iy][ix]
			if tile.tile == 1 and #self.start == 0 then self.start = {ix, iy} end
			if tile.tile == 2 and #self.finish == 0 then self.finish = {ix, iy} end
			
			tile.state = 'none'
			tile.number = -1
			tile.from = 0
			
			tile.x = ix
			tile.y = iy
		end
	end
	
	if #self.start == 0 then fx.text(3, 'No start point', 5, love.window.getHeight()-120, {255, 0, 0}) 
	elseif #self.finish == 0 then fx.text(3, 'No end point', 5, love.window.getHeight()-120, {255, 0, 0})
	else
		table.insert(self.frontier, {x = self.start[1], y = self.start[2]})
		self.map.tiles[self.start[2]][self.start[1]].number = self.count
		self.map.tiles[self.start[2]][self.start[1]].state = 'frontier'
		--self:pathfindingCheck(frontier[1])
	end
	
	
	while self.state ~= 'finished' do
		local path = self:advance()
		if path then return path end
		
		if #self.frontier == 0 then -- no path
			return false
		end
	end
end

function Pathfind:advance()
	local add = {}

	for i = #self.frontier, 1, -1 do
		local tile = self.frontier[i]
		self.map.tiles[tile.y][tile.x].state = 'visited'
		
		table.insert(self.nodes, self.map.tiles[tile.y][tile.x])
		
		if tile.x == self.finish[1] and tile.y == self.finish[2] then -- found the end
			self.state = 'finished'
			local path = {}
			local tile = self.map.tiles[tile.y][tile.x]
			table.insert(path, {tile.x, tile.y})
			local done = false
			while not done do
				local nextTile = nil
				for iy = 1, self.map.width do
					for ix = 1, self.map.height do
						if self.map.tiles[iy][ix].number == tile.from then
							table.insert(path, {ix, iy})
							nextTile = self.map.tiles[iy][ix]
						end
					end
				end
				
				tile = nextTile
				if tile.from == 0 then
					--table.insert(path, {tile.x, tile.y})
					done = true
				end
			end
			--[[
			table.insert(path, tile)
			local tile2 = self.nodes[tile.from]
			while not done do
				table.insert(path, tile2)
				if tile2.from == 0 then
					done = true
				else
					tile2 = self.nodes[tile2.from]
				end
			end
			]]
			self.path = path
			return path
		end
		
		
		
		if self.map.tiles[tile.y] and self.map.tiles[tile.y][tile.x+1] and self.map.tiles[tile.y][tile.x+1].state == 'none' then
			table.insert(add, {tile.x+1, tile.y, self.map.tiles[tile.y][tile.x].number})
		end
		
		if self.map.tiles[tile.y] and self.map.tiles[tile.y][tile.x-1] and self.map.tiles[tile.y][tile.x-1].state == 'none' then
			table.insert(add, {tile.x-1, tile.y, self.map.tiles[tile.y][tile.x].number})
		end
		
		if self.map.tiles[tile.y+1] and self.map.tiles[tile.y+1][tile.x] and self.map.tiles[tile.y+1][tile.x].state == 'none' then
			table.insert(add, {tile.x, tile.y+1, self.map.tiles[tile.y][tile.x].number})
		end
		
		if self.map.tiles[tile.y-1] and self.map.tiles[tile.y-1][tile.x] and self.map.tiles[tile.y-1][tile.x].state == 'none' then
			table.insert(add, {tile.x, tile.y-1, self.map.tiles[tile.y][tile.x].number})
		end
	end
	self.frontier = {}
	
	for i = 1, #add do
		local pass = true
		for j = 1, #self.frontier do
			if self.frontier[j].x == add[i][1] and self.frontier[j].y == add[i][2] then
				pass = false
			end
		end
		
		if pass then
			local x = add[i][1]
			local y = add[i][2]
			
			if self.map.tiles[y][x].tile == 3 then
				self.map.tiles[y][x].state = 'wall' -- should be when map is first looped through in pathfinding
			else
				self.count = self.count+1
				table.insert(self.frontier, {x = add[i][1], y = add[i][2]})
				self.map.tiles[add[i][2]][add[i][1]].state = 'frontier'
				self.map.tiles[add[i][2]][add[i][1]].from = add[i][3]
				self.map.tiles[add[i][2]][add[i][1]].number = self.count
			end
		end
	end
end


function Pathfind:draw()
--[[
	if self.state ~= 'init' then
		for iy = 1, self.map.height do
			for ix = 1, self.map.width do
			
				local realX = (ix-1)*self.map.tileWidth
				local realY = (iy-1)*self.map.tileHeight
				
				love.graphics.setColor(128, 128, 128, 0)
				if self.map.tiles[iy][ix].state == 'visited' then
					love.graphics.setColor(255, 0, 0, 128)
				elseif self.map.tiles[iy][ix].state == 'frontier' then
					love.graphics.setColor(128, 128, 200, 128)
				end
				
				love.graphics.rectangle('fill', realX, realY, self.map.tileWidth, self.map.tileHeight)
				love.graphics.print(self.map.tiles[iy][ix].number, realX, realY)
			end
		end
	end
	]]
	if self.state == 'finished' then
		--if self.redo then error(dump(self.path)) end
		for i = 1, #self.path do
			local tile = self.map.tiles[self.path[i][2]][self.path[i][1]]
			local realX = (tile.x-1)*self.map.tileWidth
			local realY = (tile.y-1)*self.map.tileHeight
			
			love.graphics.setColor(255, 0, 0)
			love.graphics.rectangle('fill', realX, realY, self.map.tileWidth, self.map.tileHeight)
		end
	end
end

function Pathfind:drawTile()
	love.graphics.rectangle('fill', self.realX, self.realY, self.width, self.height)
end