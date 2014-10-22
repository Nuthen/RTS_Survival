Map = class('Map')

function Map:initialize(width, height)
	self.width = width
	self.height = height
	
	self.tileWidth = 32
	self.tileHeight = 32
	
	self.realWidth = self.width*self.tileWidth
	self.realHeight = self.height*self.tileHeight

	self.tiles = {}
	for iy = 1, self.height do
		self.tiles[iy] = {}
		for ix = 1, self.width do
			self.tiles[iy][ix] = Tile:new(ix, iy, self.tileWidth, self.tileHeight)
		end
	end
	
	self.core = {x = 11, y = 11}
end

function Map:draw()
	for iy = 1, self.height do
		for ix = 1, self.width do
			self.tiles[iy][ix]:draw()
		end
	end
end

function Map:mousepressed(x, y, button)
	if x >= 0 and y >= 0 and x <= self.realWidth and y <= self.realHeight then -- not sure if it goes to 0 or to the width/height
		local tileX = math.ceil(x / self.tileWidth)
		local tileY = math.ceil(y / self.tileHeight)
		
		if tileX == 1 and tileY == 1 then
		elseif tileX == 11 and tileY == 11 then
		elseif button == 'l' then
			self:setTile(tileX, tileY, 1)
		elseif button == 'x2' then
			self:setTile(tileX, tileY, 2)
		elseif button == 'r' then
			self:setTile(tileX, tileY, 3)
		elseif button == 'm' then
			self:setTile(tileX, tileY, 0)
		end
	end
end

function Map:setTile(x, y, tile)
	self.tiles[y][x].tile = tile -- tile is a number representing the tile's type
end


Tile = class('Tile')

function Tile:initialize(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	
	self.tile = 0
	if x == 11 and y == 11 then -- core
		self.tile = 4
	end
	
	if x == 1 and y == 1 then -- spawner
		self.tile = 5
	end
	
	self.realX = (self.x-1)*self.width
	self.realY = (self.y-1)*self.height
end

function Tile:draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle('line', self.realX, self.realY, self.width, self.height)
	love.graphics.setColor(255, 255, 255)
	if self.tile == 1 then love.graphics.setColor(0, 0, 255) end
	if self.tile == 2 then love.graphics.setColor(0, 255, 0) end
	if self.tile == 3 then love.graphics.setColor(0, 255, 255) end
	if self.tile == 4 then love.graphics.setColor(128, 128, 128) end
	if self.tile == 5 then love.graphics.setColor(255, 255, 0) end
	love.graphics.rectangle('fill', self.realX, self.realY, self.width, self.height)
end