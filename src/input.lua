
require 'src.utils/camera'
Input = {}

-------------- Love callbacks
function love.mousepressed(x, y, button)
	x, y = camera:scalePoint(x, y)
	Input.__lastMouseClickPoint = { x = x, y = y }
	if button == 'l' then
		Input.__mouse1Pressed = true
	elseif button == 'r' then
	    Input.__mouse2Pressed = true
	end
end

function love.mousereleased(x, y, button)
	x, y = camera:scalePoint(x, y)
	Input.__lastMouseReleasePoint = { x = x, y = y }
	if button == 'l' then
		Input.__mouse1Released = true
	elseif button == 'r' then
		Input.__mouse2Released = true
	end
end

-------------- Functions to do stuff
function Input:mouse1Pressed(x, y)
	Hud:startSelectionBox(x, y)
	Game:checkForSelect(x, y)

	Input.__mouse1Pressed = false
end

function Input:mouse1Released(x, y)
	Hud:endSelectionBox(x, y)
	Game:checkForSelectInBox()

	Input.__mouse1Released = false
end

function Input:mouse2Pressed(x, y)
	Game:moveCommand(x, y)

	Input.__mouse2Pressed = false
end

function Input:mouse2Released(x, y)

	Input.__mouse2Released = true
end


