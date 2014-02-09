-- The game world

World = {}

function World:init()
	self.width = 4096
	self.height = 4096
	self.cameraStart = { x = self.width/2, y = self.height/2 }
	self.gridScale = 16
	self.gridSquareWidth = self.width/self.gridScale
	self.gridSquareHeight = self.height/self.gridScale
end

function World:update()

end

function World:draw()
	love.graphics.setLineWidth(1)
	for row = 0, self.gridScale do
		local offset = row*self.gridSquareHeight
		love.graphics.line(0, offset, self.width, offset)
	end

	for col = 0, self.gridScale do
		local offset = col*self.gridSquareWidth
		love.graphics.line(offset, 0, offset, self.height)
	end
end