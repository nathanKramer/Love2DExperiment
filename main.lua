-- Main --
require 'src.Game'
require 'src.input'
require 'src.units.square'

-- stuff that needs updating and drawing
require 'src.world'
require 'src.resource'
require 'src.commands.MoveCommand'
require 'src.commands.StopCommand'
require 'src.commands.Command'
require 'src.GameController'
require 'src.Gameobjects'
require 'src.hud'

-- Called when the game gains or loses focus. 
-- True if gained, false otherwise.
function love.focus(bool)
	Game:setFocus(bool)
end

-- Run at game start --
function love.load()
	GameObjects:addSquare(400, 300, 50, 50, 'fill', { r = 255, g = 128, b = 128 })
	GameObjects:addSquare(200, 200, 50, 50, 'fill', { r = 128, g = 255, b = 128 })
	GameObjects:addSquare(300, 200, 50, 50, 'fill', { r = 128, g = 128, b = 255 })
	love.graphics.setBackgroundColor(0, 25, 51)
	love.graphics.setColor(0, 0, 0)

	resources:init()
	Game:init()
end

-- Do most of the logic here --
function love.update(dt)
	Game:update(dt)
end

-- Draw what we updated in love.update() --
function love.draw()
	-- love.graphics.reset()
	-- love.graphics.draw(resources.myImage, 100, 100)
	Game:draw()
end

-- Game Quit --
function love.quit()

end