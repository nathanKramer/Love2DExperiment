local class = require 'src.utils.middleclass'
require 'src.utils.queue'

BaseUnit = class('BaseUnit')

function BaseUnit:initialize(x, y, box)
	self.x = x -- origin x
	self.y = y -- origin y
	self.boundingBox = box
	self.commandQueue = Queue.new()
end

function BaseUnit:refreshBoundingBox(dt)
	self.boundingBox = BoundingBox:new(
		self.x - (self.boundingBox.width / 2), 
		self.y - (self.boundingBox.height / 2),
		self.x + (self.boundingBox.width / 2),
		self.y + (self.boundingBox.height / 2)
	)
end

function BaseUnit:update(dt)
	if Queue.empty( self.commandQueue ) then
		return
	end
	
	self.commandQueue[self.commandQueue.first]:update(dt)

	if self.commandQueue[self.commandQueue.first]:doCommand(self) then
		Queue.pop( self.commandQueue )
	end

	self:refreshBoundingBox(dt)

end

function BaseUnit:draw(x, y)
	if Queue.empty( self.commandQueue ) then
		return
	end


	local cmdQ = self.commandQueue[self.commandQueue.first]
	love.graphics.setColor(0, 102, 204, 64)
	love.graphics.setLineStyle('smooth')
	love.graphics.setLineWidth(1)
	while cmdQ do
		cmdQ:draw(x, y)
		if not (cmdQ.next == nil) then
			x = cmdQ.x or x
			y = cmdQ.y or y
		end
		cmdQ = cmdQ.next

	end
end

function BaseUnit:tryToSelect(x, y)
	return self.boundingBox:pointWithinSquare(x, y)
end

function BaseUnit:tryToDragSelect(rect)
	return self.boundingBox:objectWithinSquare(rect)
end

function BaseUnit:clearCommandQueue()
	self.commandQueue = Queue.new()
end

function BaseUnit:addCommandToQueue(cmd)
	if not love.keyboard.isDown( "lshift" ) then
		self:clearCommandQueue()
	end

	Queue.push( self.commandQueue, cmd )
end