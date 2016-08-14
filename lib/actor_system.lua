require("lib.utils")
require("stdlib.string")

local actorSystem = {
    actors = {
        require("actors.circuit-alerter-actor"),
        require("actors.circuit-pole"),
        --require("actors.alerter-alert-expando")
    },
}

local disableTick = false

function actorSystem:init()
    global.actorSystem = {
        actors = {},
        initialized = false
    }

    for _, actor in ipairs(self.actors) do
        if actor.init then
            actor.init()
        end
        table.insert(global.actorSystem.actors, actor.name)
    end

    global.actorSystem.initialized = true
    doDebug("Actor System Initialized")
end

function actorSystem:initPlayerData(player_index)
    for _, actor in ipairs(self.actors) do
        if actor.initPlayerData then
            actor.initPlayerData(player_index)
            end
    end
end


function actorSystem:reset()
    disableTick=true
    for _, actor in ipairs(self.actors) do
        if actor.reset then
            actor.reset()
            end
    end
   disableTick=false
end


function actorSystem:tick(event)
    if disableTick then return end
    for _, actor in ipairs(self.actors) do
        if actor.tick then
            actor.tick(event)
            end
    end
end

function actorSystem:createEntity(entity, player_id)
    --local thisEntity=entity
    --local pid=player_id
    for _, actor in ipairs(self.actors) do
        if actor.class and actor.class == "entity" and (actor.name == entity.name or string.ends_with(entity.name,actor.name)) and actor.createEntity then
            --self:AddActor( class.CreateActor{entity = entity} )
            actor.createEntity(entity, player_id)
        end
    end
end


function actorSystem:destroyEntity(entity)
    for _, actor in ipairs(self.actors) do
        if actor.class and actor.class == "entity" and (actor.name == entity.name or string.ends_with(entity.name,actor.name)) and actor.destroyEntity then
            actor.destroyEntity(entity)
        end
    end
end

function actorSystem:openGui(entityName, player_index)
    for _, actor in ipairs(self.actors) do
        if actor.class and actor.class == "entity" and actor.name == entityName and actor.openGui then
            actor.openGui(entityName, player_index)
        end
    end
end


function actorSystem:closeGui(entityName, player_index)
    for _, actor in ipairs(self.actors) do
        if actor.class and actor.class == "entity" and actor.name == entityName and actor.closeGui then
            actor.closeGui(entityName, player_index)
        end
    end
end

function actorSystem:onGuiClick(event)
    for _, actor in ipairs(self.actors) do
        --if actor.class and actor.class == "entity" and actor.name == entityName and actor.closeGui then
        if actor.onGuiClick then
            actor.onGuiClick(event)
        end
    end
end

function actorSystem:onGuiChecked(event)
    for _, actor in ipairs(self.actors) do
        --if actor.class and actor.class == "entity" and actor.name == entityName and actor.closeGui then
        if actor.onGuiCheck then
            actor.onGuiCheck(event)
        end
    end
end

function actorSystem:onGuiText(event)
    for _, actor in ipairs(self.actors) do
        --if actor.class and actor.class == "entity" and actor.name == entityName and actor.closeGui then
        if actor.onGuiText then
            actor.onGuiText(event)
        end
    end
end

function actorSystem:onSelectedArea(event)
    for _, actor in ipairs(self.actors) do
        --if actor.class and actor.class == "entity" and actor.name == entityName and actor.closeGui then
        if event.item == actor.name and actor.onSelectedArea then
            actor.onSelectedArea(event)
        end
    end
end

return actorSystem
