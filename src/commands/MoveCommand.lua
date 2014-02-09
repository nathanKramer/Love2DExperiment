local class = require 'src.utils.middleclass'
require 'src.commands.Command'
require 'src.utils.geometry'
vector = require 'src.utils.vector'

MoveCommand = class('MoveCommand', Command)

function MoveCommand:initialize(pointX, pointY, dt)
	self.x = pointX
	self.y = pointY
	self = Command.initialize(self, dt)
end

function MoveCommand:update(dt)
	Command.update(self, dt)
end

function MoveCommand:draw(unitX, unitY)
	-- dotted line here
	--lineStipple(self.x, self.y, unitX, unitY, 3, 3)

	-- normal line
	love.graphics.line(self.x, self.y, unitX, unitY)
end

function MoveCommand:doCommand(gameObj)
	local destPoint = vector(self.x, self.y)
	local objPoint = vector(gameObj.x, gameObj.y)
	local distance = objPoint:dist(destPoint)

	local dv = destPoint - objPoint
	dv:normalize_inplace()

	local constant = (self.multiplier * 200)
	local distanceToMove = distance < constant and distance or constant
	local newPos = objPoint + (distanceToMove * dv)

	gameObj.x = newPos.x
	gameObj.y = newPos.y

	return newPos == destPoint
end