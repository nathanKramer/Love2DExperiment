require 'src.units.square'
require 'src.units.Entity'
require 'src.units.Light'
require 'src.units.Wall'
require 'src.units.Player'

Entities = {}
Entities.size = 0

-- Key value pairs using the same ID
Entities.GameObjects = {} 
Entities.Lights = {}
Entities.Enemies = {}
Entities.Player = nil
Entities.PlayerControlled = {}
Entities.toAdd = {}

function Entities:init(entities)
	--World:nRandomLights(20)
	for _, entity in pairs(entities) do
		print ("Adding a " .. entity.type)
		if entity.type == "wall" then
			self:addWall(entity.x, entity.y, entity.dimensions.width, entity.dimensions.height)
		elseif entity.type == "light" then
			self:addLight(entity.x, entity.y, entity.radius, { entity.colour.r, entity.colour.g, entity.colour.b })
		elseif entity.type == "player" then
			self:addPlayer(entity.x, entity.y, entity.dimensions.width, entity.dimensions.height, 'fill', entity.color)
		end
	end
end

function Entities:update(dt)
    self.isUpdating = true

    Entities:resolveCollisions(dt)
    for e = 0, (Entities.size-1) do
        self[e]:update(dt)
    end

    self.isUpdating = false
end

function Entities:draw()
	-- love.graphics.setBlendMode('alpha')
	for e = 0, (Entities.size-1) do
		self[e]:draw()
	end
end

function Entities.isColliding(ent1, ent2)
    radius = ent1.collisionRadius + ent2.collisionRadius
    return ent1.origin:dist(ent2.origin) < (radius)
end

function Entities:resolveCollisions(dt)
    for id, enemy in pairs(Entities.Enemies) do

        -- Collisions with other enemies
        for id2, enemy2 in pairs(Entities.Enemies) do
            if id ~= id2 then
                if Entities.isColliding(enemy, enemy2) then
                    -- enemy:handleCollision(enemy2)
                    -- enemy2:handleCollision(enemy)
                    distance = enemy.origin:dist(enemy2.origin)
                    overlap = distance - (enemy.collisionRadius + enemy2.collisionRadius)

                    dir = enemy.origin - enemy2.origin
                    dir:normalize_inplace()
                    local newPos = enemy.origin + (-dir * overlap / 2)
                    if World:canMoveTo(enemy, newPos) then
                        enemy.origin = newPos
                    else 
                        enemy.origin = World:suggestedPosition(enemy, newPos)
                    end

                    newPos = enemy2.origin + (dir * overlap / 2)
                    if World:canMoveTo(enemy2, newPos) then
                        enemy2.origin = newPos
                    else
                        enemy2.origin = World:suggestedPosition(enemy, newPos)
                    end
                end
            end
        end

        -- Collisions with the player
        if Entities.isColliding(enemy, Entities.Player) then
            Entities.Player:kill()
        end
    end

    for id, playerControlled in pairs(Entities.PlayerControlled) do

    end
end

function Entities:add(entity) 
    if not self.isUpdating then
        self:addEntity(entity)
    else
        table.insert(self.toAdd, entity)
    end
end

-- Intended to be private
function Entities:addEntity(entity)
    local id = self.size
    print ("Adding an entity")
    self[id] = entity
    if entity:isInstanceOf(Player) then
    	self.Player = entity
        self.PlayerControlled[id] = entity
    elseif entity:isInstanceOf(Light) then
        self.Lights[id] = entity
	elseif entity:isInstanceOf(BaseEnemy) then
    	self.Enemies[id] = entity
    else
    	self.GameObjects[id] = entity
    end
    self.size = self.size + 1 
end

function Entities:addWall(x, y, width, height)
	local toAdd = Wall:new(x, y, width, height)
	Entities:add(toAdd)
end

function Entities:addSquare(x, y, width, height, mode, colorTable)
	local toAdd = Square:new(x, y, width, height, mode, colorTable)
	toAdd:addLight(700, {0.9, 0.9, 0.9})
	Entities:add(toAdd)
end

function Entities:addPlayer(x, y, width, height, mode, colorTable)
	local toAdd = Player:new(x, y, width, height, mode, colorTable)
	toAdd:addLight(300, {0.9, 0.5, 0.5})
	Entities:add(toAdd)
end

function Entities:getObjectPosition(objId)
	return self[objId]:getX(), self[objId]:getY()
end

function Entities:addLight(x, y, radius, colour)
	local toAdd = Light:new(x, y, radius, colour, 5)
	Entities:add(toAdd)
end

function Entities:addLightInstance(light)
	local id = self.size
	self[id] = light
	self.Lights[id] = light
	self.size = self.size + 1
end