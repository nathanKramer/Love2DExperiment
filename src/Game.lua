require 'src.selection'
require 'src.utils.camera'

Game = {}
Game.selection = CGSelection:new()

function Game:init()
	World:init()
	camera:setBounds(0, 0, World.width, World.height)
	camera:lookAt(World.cameraStart.x, World.cameraStart.y)
	Hud:init()
end

function Game:update(dt)
	World:update(dt)
	GameController:update(dt)
	GameObjects:update(dt)
	Hud:update(dt)
end

function Game:draw()
	camera:set()

	World:draw()
	GameObjects:draw()
	Hud:draw()

	camera:unset()
end

function Game:centerOnSelected() 
	-- Get the current "primary" selection
	local primarySelectedId = Game.selection:getPrimarySelected()
	local newCameraPosX, newCameraPosY = GameObjects:getObjectPosition(primarySelectedId)
	camera:lookAt(newCameraPosX, newCameraPosY)
end

--
-- Checks if we've selected anything
-- If we have, adds it to the set of selected objects
--
function Game:checkForSelect(pointX, pointY)
	for gameObj = 0, (GameObjects.size-1) do

		if GameObjects[gameObj]:tryToSelect(pointX, pointY) then
			if not love.keyboard.isDown( "lshift" ) then
				Game:deselectObjects()
			end
			if love.keyboard.isDown( "lctrl" ) then
				Game:selectAllOfType(GameObjects[gameObj].class)
			end
			Game.selection:add(gameObj)
			break
		end
	end
end

function Game:selectAllOfType(c)
	for gameObj = 0, (GameObjects.size - 1) do
		if GameObjects[gameObj]:isInstanceOf(c) then
			Game.selection:add(gameObj)
		end
	end
end

function Game:recallControlGroup(ctrlGroup)
	Game.selection:recallControlGroup(ctrlGroup)
end

function Game:createControlGroup(ctrlGrp)
	Game.selection:createControlGroup(ctrlGrp)
end

function Game:addToControlGroup(ctrlGrp)
	Game.selection:addToControlGroup(ctrlGrp)
end

--
-- Checks if there are objects to select within the selection box.
-- If there are, adds all of them to the set of selected objects
--
function Game:checkForSelectInBox()

	local selectionBox = Hud.selectionBox.rectangle
	local initialDeselect = true
	for gameObj = 0, (GameObjects.size-1) do

		if GameObjects[gameObj]:tryToDragSelect(selectionBox) then
			if not love.keyboard.isDown( "lshift" ) and initialDeselect then
				Game:deselectObjects()
				initialDeselect = false
			end
			Game.selection:add(gameObj)
		end
	end

end

function Game:setFocus(state) 
	if state then
		mX, mY = love.mouse.getPosition()
		if mX >= 0 and mY >= 0 and mX <= love.graphics.getWidth() and mY <= love.graphics.getHeight() then
			love.mouse.setGrabbed(true)
		end
	end
	self.focus = state
end

function Game:checkForCameraScroll(scrollArea, scrollSpeed)
	if self.focus then
		camera:scroll(scrollArea, scrollSpeed)
	end
end

function Game:deselectObjects()
	Game.selection:deselect(GameObjects)
end

function Game:clearCommandQueue()
	for gameObj = 0, (GameObjects.size-1) do

		if Game.selection.selected[gameObj] then
			GameObjects[gameObj]:clearCommandQueue()
		end
	end
end

function Game:moveCommand(x, y)

	for gameObj = 0, (GameObjects.size-1) do
		if Game.selection.selected[gameObj] then
			GameObjects[gameObj]:addCommandToQueue(MoveCommand:new(x, y))
		end
	end
end

function Game:stopCommand()

	for gameObj = 0, GameObjects.size-1 do
		if Game.selection.selected[gameObj] then
			GameObjects[gameObj]:addCommandToQueue(StopCommand:new())
		end
	end
end