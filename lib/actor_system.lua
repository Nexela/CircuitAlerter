require("lib.utils")
require("stdlib.string")

local actorSystem = {
    actors = {
        require("actors.circuit-alerter-actor"),
        require("actors.circuit-pole"),
    },
}

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
    global.initialized=false
    for _, actor in ipairs(self.actors) do
        if actor.reset then
            actor.reset()
        end
    end
    global.initialized=true
end


function actorSystem:tick(event)
    for _, actor in ipairs(self.actors) do
        if actor.tick then
            actor.tick(event)
        end
    end
end

function actorSystem:createEntity(entity, player_id)
    for _, actor in ipairs(self.actors) do
        if actor.class and actor.class == "entity" and (actor.name == entity.name or string.ends_with(entity.name,actor.name)) and actor.createEntity then
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

function actorSystem:openGui(event)
    for _, actor in ipairs(self.actors) do
        if actor.class and actor.class == event.type and actor.name == event.entity.name and actor.openGui then
            actor.openGui(event)
        end
    end
end


function actorSystem:closeGui(event)
    for _, actor in ipairs(self.actors) do
        if actor.class and actor.class == event.type --[[and actor.name == event.entity.name]] and actor.closeGui then
            actor.closeGui(event)
        end
    end
end

function actorSystem:onGuiClick(event)
    for _, actor in ipairs(self.actors) do
        if actor.onGuiClick then
            actor.onGuiClick(event)
        end
    end
end

function actorSystem:onGuiChecked(event)
    for _, actor in ipairs(self.actors) do
        if actor.onGuiCheck then
            actor.onGuiCheck(event)
        end
    end
end

function actorSystem:onGuiText(event)
    for _, actor in ipairs(self.actors) do
        if actor.onGuiText then
            actor.onGuiText(event)
        end
    end
end

function actorSystem:onSelectedArea(event)
    for _, actor in ipairs(self.actors) do
        if event.item == actor.name and actor.onSelectedArea then
            actor.onSelectedArea(event)
        end
    end
end

return actorSystem
