require("stdlib/extras/utils")
require("stdlib/string")

local actorSystem = {
    actors = {
        require("actors/circuit-alerter-actor"),
        require("actors/rail-switch-actor"),
        require("actors/circuit-pole"),
        --require("actors/pipe-cleaner"),
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
            actor:init()
        end
        table.insert(global.actorSystem.actors, actor.name)
    end

    global.actorSystem.initialized = true
    doDebug("Actor System Initialized")
end

function actorSystem:initPlayerData(player_index)
    for _, actor in ipairs(self.actors) do
        if actor.initPlayerData then
            actor:initPlayerData(player_index)
            end
    end
end


function actorSystem:reset()
    disableTick=true
    for _, actor in ipairs(self.actors) do
        if actor.reset then
            actor:reset()
            end
    end
   disableTick=false
end


function actorSystem:tick(event)
    if disableTick then return end
    for _, actor in ipairs(self.actors) do
        if actor.tick then
            actor:tick(event)
            end
    end
end

function actorSystem:createEntity(entity, player_id)
    --local thisEntity=entity
    --local pid=player_id
    for _, actor in ipairs(self.actors) do
        if actor.class and actor.class == "entity" and (actor.name == entity.name or string.ends_with(entity.name,actor.name)) and actor.createEntity then
            --self:AddActor( class.CreateActor{entity = entity} )
            actor:createEntity(entity, player_id)
        end
    end
end


function actorSystem:destroyEntity(entity)
    for _, actor in ipairs(self.actors) do
        if actor.class and actor.class == "entity" and (actor.name == entity.name or string.ends_with(entity.name,actor.name)) and actor.destroyEntity then
            actor:destroyEntity(entity)
        end
    end
end

function actorSystem:openGui(entityName, player_index)
    for _, actor in ipairs(self.actors) do
        if actor.class and actor.class == "entity" and actor.name == entityName and actor.openGui then
            actor:openGui(entityName, player_index)
        end
    end
end


function actorSystem:closeGui(entityName, player_index)
    for _, actor in ipairs(self.actors) do
        if actor.class and actor.class == "entity" and actor.name == entityName and actor.closeGui then
            actor:closeGui(entityName, player_index)
        end
    end
end

function actorSystem:onGuiClick(event)
    for _, actor in ipairs(self.actors) do
        --if actor.class and actor.class == "entity" and actor.name == entityName and actor.closeGui then
        if actor.onGuiClick then
            actor:onGuiClick(event)
        end
    end
end

function actorSystem:onGuiChecked(event)
    for _, actor in ipairs(self.actors) do
        --if actor.class and actor.class == "entity" and actor.name == entityName and actor.closeGui then
        if actor.onGuiCheck then
            actor:onGuiCheck(event)
        end
    end
end

function actorSystem:onGuiText(event)
    for _, actor in ipairs(self.actors) do
        --if actor.class and actor.class == "entity" and actor.name == entityName and actor.closeGui then
        if actor.onGuiText then
            actor:onGuiText(event)
        end
    end
end

function actorSystem:onSelectedArea(event)
    for _, actor in ipairs(self.actors) do
        --if actor.class and actor.class == "entity" and actor.name == entityName and actor.closeGui then
        if event.item == actor.name and actor.onSelectedArea then
            actor:onSelectedArea(event)
        end
    end
end

return actorSystem


--[[
if not global.actor_system then global.actor_system = {} end
if not global.actor_system.actor_classes then global.actor_system.actor_classes = {} end

actor_system = {
    actors = {},
    actor_classes = {}
}

function actor_system:Init()
    doLog("Actor system Initializing")
    --global.actor_system={}
    --global.actor_system.actors={}
    --global.actor_system.actor_classes={}
    --global.actor_system.initialized = true
    
end

function actor_system:Save()
    --global.actors = self.actors
end

function actor_system:_afterLoad()
    for _, actor in ipairs(self.actors) do
        if actor.OnLoad then
            actor:OnLoad()
        end
    end
end

function actor_system:Load()
    if not self.has_initialised then
        if global.actors then
            for i, glob_actor in ipairs(global.actors) do
                if glob_actor.className and ((glob_actor.entity and glob_actor.entity.valid) or (not glob_actor.entity)) then
                    local class = _ENV[glob_actor.className]
                    local actor = class.CreateActor(glob_actor)
                    table.insert(self.actors, actor)
                end
            end
        end
        self.has_initialised = true
    end
end

function actor_system:Tick()
    for i = 1, #global.actor_system.actors do
        local actor = global.actor_system.actors[i]
        if actor.OnTick then
            actor:OnTick()
        end
    end
end

function actor_system:OnEntityDestroy( entity )
    for i=1, #self.actors do
        local actor = self.actors[i]
        if actor and actor.entity and actor.entity == entity then
            table.remove(self.actors, i)
            if actor.OnDestroy then
                actor:OnDestroy()
            end
            return
        end
    end
end

function actor_system:OnEntityCreate( entity )
    for index, class in ipairs(self.actor_classes) do
        if class.entity_type and class.entity_type == entity.name then
            self:AddActor( class.CreateActor{entity = entity} )
            return
        end
    end
end

function actor_system:AddActor( actor )
    table.insert(global.actor_system.actors, actor)
    if actor.Init then
        actor:Init()
    end
    return actor
end


function ActorClass( name, class )
    --_ENV[name] = class
    class.className = name
    class.CreateActor = function(existing)
        local actor = existing or {}
        actor.className = name
        setmetatable(actor, {__index = class})
        return actor
    end
    table.insert(global.actor_system.actor_classes, class)
    return class
end
--]]