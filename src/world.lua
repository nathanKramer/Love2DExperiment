-- The game world
require 'src.utils.shader'
require 'src.units.Light'
require 'src.Entities'
JSON = require 'src.libs.JSON'
LEVEL = love.filesystem.read( "src/levels/test.json" )
ROFL_BACKGROUND_IMAGE_LOL = love.graphics.newImage( "resources/levels/test.jpg" )

World = {}

function World:init()
	local lua_value = JSON:decode('{"test": "hello"}')
	print("Testing: " .. lua_value.test)

	self:loadWorld(LEVEL)
	self.cameraStart = { x = self.width/2, y = self.height/2 }
	self.gridScale = 16
	self.gridSquareWidth = self.width/self.gridScale
	self.gridSquareHeight = self.height/self.gridScale
	--self.gridIncrement = 5
end

function World:loadWorld(worldFile)
	local worldObj = JSON:decode(worldFile)
	print ("Loaded a level called: " .. worldObj.levelName)
	self.width = worldObj.dimensions.width
	self.height = worldObj.dimensions.height
	Entities:init(worldObj.entities)
end

function World:update(dt)
	-- self.gridScale = self.gridScale + (dt* self.gridIncrement)
	-- if self.gridScale >= 32 then
	-- 	self.gridIncrement = self.gridIncrement * -1
	-- end
	-- self.gridSquareWidth = self.width/self.gridScale
	-- self.gridSquareHeight = self.height/self.gridScale
end

function World:nRandomLights(n)
	for i = 1, n do
		Entities:addLight(love.math.random(0, self.width), love.math.random(0, self.height), love.math.random(300, 800), { love.math.random(), love.math.random(), love.math.random() })
	end
end

function World:draw()
	local mode = love.graphics.getBlendMode()
	love.graphics.setBlendMode('multiplicative')
	love.graphics.draw(ROFL_BACKGROUND_IMAGE_LOL, 0, 0)
	love.graphics.setColor({ 100, 100, 250})
	love.graphics.setLineWidth(1)
	-- for row = 0, self.gridScale do
	-- 	local offset = row*self.gridSquareHeight
	-- 	love.graphics.line(0, offset, self.width, offset)
	-- end

	-- for col = 0, self.gridScale do
	-- 	local offset = col*self.gridSquareWidth
	-- 	love.graphics.line(offset, 0, offset, self.height)
	-- end

	love.graphics.setBlendMode(mode)
end