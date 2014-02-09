require 'src.input'

CommandStack = {}

GameController = {}
GameController.lastKeyboardInput = 0 -- time of last successful keyboard action, for example adding to control group
GameController.currTime = 0
GameController.keyPresses = {
	
} -- map from key to last time it was pressed

function GameController:update(dt)

	--- set currTime
	currTime = love.timer.getTime()

	GameController:mouseEvents()
	GameController:keyboardEvents(dt)
	GameController:checkForCameraScroll(dt)
end

function GameController:mouseEvents(dt)
	if Input.__mouse1Pressed then
		Input:mouse1Pressed(Input.__lastMouseClickPoint.x, Input.__lastMouseClickPoint.y)
	end

	if Input.__mouse1Released then
		Input:mouse1Released(Input.__lastMouseReleasePoint.x, Input.__lastMouseReleasePoint.y)
	end

	if Input.__mouse2Pressed then
		Input:mouse2Pressed(Input.__lastMouseClickPoint.x, Input.__lastMouseClickPoint.y)
	end

	if Input.__mouse2Released then
		Input:mouse2Released(Input.__lastMouseReleasePoint.x, Input.__lastMouseReleasePoint.y)
	end
end

function GameController:keyboardEvents(dt)

	local timeSinceKeyboardAction = (currTime - GameController.lastKeyboardInput) * 1000

	if timeSinceKeyboardAction > 100 then
		if love.keyboard.isDown( "lctrl" ) or love.keyboard.isDown( "lshift" ) then
			GameController.checkForModifierAction(dt)
		end

	    GameController:checkForNormalAction(dt)
		
	end
end

function GameController:checkForNormalAction(dt)

	if not love.keyboard.isDown( "lshift" ) then
		GameController:checkForControlGroupRecall(dt)
	end
	GameController:checkForStopCommand(dt)
end

function GameController:checkForStopCommand(dt)
	if love.keyboard.isDown( "s" ) then
		Game:stopCommand()
	end
end

function GameController:checkForCameraScroll(dt)
	scrollArea = 75
	scrollSpeed = 1000
	mPosX, mPosY = Game:checkForCameraScroll(scrollArea, scrollSpeed * dt)
end

function GameController:checkForControlGroupRecall(dt)
	for ctrlGroup = 0, 9 do
		if love.keyboard.isDown( tostring(ctrlGroup) ) then
			Game:recallControlGroup(ctrlGroup)
			GameController.lastKeyboardInput = love.timer.getTime()
		end
	end

	return sentAction
end

function GameController:checkForModifierAction(dt)
	local ctrlIsPressed = love.keyboard.isDown( 'lctrl' )
	local shiftIsPressed = love.keyboard.isDown( 'lshift' )
	GameController:checkForControlGroup(dt, ctrlIsPressed, shiftIsPressed)
	GameController:checkForScreenCenter(dt, ctrlIsPressed)
end

function GameController:checkForScreenCenter(dt, ctrlPressed)
	local fIsPressed = love.keyboard.isDown( 'f' )
	if fIsPressed then
		Game:centerOnSelected()
	end
end

function GameController:checkForControlGroup(dt, ctrlPressed, shiftPressed)
	for ctrlGroup = 0, 9 do
		if love.keyboard.isDown( tostring(ctrlGroup) ) then
			if ctrlPressed then
				Game:createControlGroup(ctrlGroup)
			elseif shiftPressed then
			    Game:addToControlGroup(ctrlGroup)
			end
			GameController.lastKeyboardInput = love.timer.getTime()
		end
	end
end