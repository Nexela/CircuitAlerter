--control.lua : Scripts are ran when starting or joining a world.

require("lib.utils") --Need to tweak utils :)

--Require Logger and Config
local configs = require("config")
local Config=require("stdlib.config.config")
local Logger = require("stdlib.log.logger")

--MOD: Global Constants for mod use
MOD = {}
MOD["name"] = "CircuitAlerter"
MOD["n"] = "CA"
MOD["config"] = Config.new(configs)
MOD["debug"] = true
MOD["fileheader"] = "vvvvvvvvvvvvvvvvvvvvvvv--CircuitAlerter: Logging Started:--vvvvvvvvvvvvvvvvvvvvvvv"
MOD["forcereset"] = false
MOD["logfile"] = Logger.new(MOD.name, "info", true, {log_ticks = true})

local Game=require("stdlib.game")
local actorSystem = require("lib.actor_system")
local events = require("lib.events")
--------------------------------------------------------------------------------------
function doDebug(msg, alert)
    local level = MOD.config.get("LOGLEVEL", 1)
    if level == 0 and not alert then return end

    if (level >= 1 or alert) and type(msg) == "table" then
                MOD.logfile.log("vvvvvvvvvvvvvvvvvvvvvvv--Begin Serpent Block--vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv")
                MOD.logfile.log(serpent.block(msg))
                MOD.logfile.log("^^^^^^^^^^^^^^^^^^^^^^^--End   Serpent Block--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
            else
                MOD.logfile.log(tostring(msg))
            end
    if (level >= 2 or alert) and game then
        Game.print_all(MOD.n .. ":" .. table.tostring(msg))
    end
end
doDebug(MOD.fileheader) --Start the debug log with a header

------------------------------------------------------------------------------------------
--[[INIT FUNCTIONS]]--
local function globalVarInit()
    global= {
    ticks = 0,
    config = configs
}
    MOD.config = Config.new(global.config) -- We have global init, move config handler to global config
end

local function newPlayerInit(player, reset) -- initialize or update per player globals of the mod, player and forces
    if reset or global.playerData == nil then global.playerData = {} end
    if reset or global.forceData == nil then global.forceData = {} end
    
    if reset == true or (not global.playerData[player.index] or global.playerData[player.index].name ~= player.name) then
        global.playerData[player.index] = {
            opened = nil,  --TODO move to events.init?
            name = player.name --use for flavor, not all players might have a name...
        }
        actorSystem:initPlayerData(player.index) --Init any actor player data player
        doDebug("newPlayerInit: Created player: " .. player.index ..":".. player.name)
    end
        
    if not global.forceData[player.force.name] then
        global.forceData[player.force.name] ={}
        doDebug("NewPlayerInit: Created force: " .. player.force.name)
    end
end


local function playerInit(reset)
    for _, player in pairs(game.players) do
        newPlayerInit(player, reset)
        doDebug("playerInit: Looking for new players")
    end
end

local function OnGameInit() --Called when mod is first added to a new game
    doDebug("OnGameInit: Initial Setup Started")
    globalVarInit() -- Initialize and set any default values for base
    playerInit() -- Initialize all players and forces
    events.init() --
    actorSystem:init() -- Initialize all data for actors
    global.initialized = true
    doDebug("OnGameInit: Initial Setup Complete")
end


local function OnGameLoad()-- Called when game is loaded. Can cause Desyncs if used incorrectly
    MOD.config = Config.new(global.config) -- We have global init, move config handler to global config
    doDebug("OnGameLoad: Game Loaded")
end


local function OnGameChanged(data)--Called whenever Game Version or any mod Version changes, or when any mods are added or removed.
    doDebug("OnGameChanged: = Changes Detected")
        if data.mod_changes ~= nil then
        local changes = data.mod_changes[MOD.name]
        if changes ~= nil then -- THIS Mod has changed
            doDebug(MOD.name .."  Updated from ".. tostring(changes.old_version) .. " to " .. tostring(changes.new_version), true)
            --Do Stuff Here if needed
        end
    end
end

script.on_init(OnGameInit)
script.on_load(OnGameLoad)
script.on_configuration_changed(OnGameChanged)


------------------------------------------------------------------------------------------
--[[PLAYER FUNCTIONS]]--
local function OnPlayerCreated(player_index)--Called Everytime a new player is created
    local player = game.players[player_index]
    doDebug("OnPlayerCreated = ".. player.index ..":".. player.name)
    newPlayerInit(player)
end


local function OnPlayerJoined(event)--Called when players join
    local player = game.players[event.player_index]
    doDebug("OnPlayerJoined = ".. player.index ..":".. player.name)
    newPlayerInit(player)
end

local function OnPlayerRespawned(event)
    local player = game.players[event.player_index]
    doDebug("OnPlayerRespawned = " .. player.index ..":" .. player.name)
end

local function OnPlayerLeft(event)
    local player = game.players[event.player_index]
    doDebug("OnPlayerLeft = " .. player.index ..":".. player.name)
end


script.on_event(defines.events.on_player_created, function(event) OnPlayerCreated(event.player_index) end)
script.on_event(defines.events.on_player_joined_game, function(event) OnPlayerJoined(event) end)
script.on_event(defines.events.on_player_respawned, function(event) OnPlayerRespawned(event) end)
script.on_event(defines.events.on_player_left_game, function(event) OnPlayerLeft(event) end)


------------------------------------------------------------------------------------------
--[[ENTITY FUNCTIONS]]--
local function OnBuiltEntity(event)--Called when entities are built by player...
    local entity = event.created_entity
    local player_index = event.player_index
    actorSystem:createEntity(entity, player_index)
end


local function OnEntityDestroy(event)--Called when entities are destroyed
    local entity = event.entity
    actorSystem:destroyEntity(entity)
end

script.on_event(defines.events.on_built_entity, OnBuiltEntity)
script.on_event(defines.events.on_robot_built_entity, OnBuiltEntity )

script.on_event(defines.events.on_entity_died, function(event) OnEntityDestroy(event) end)
script.on_event(defines.events.on_preplayer_mined_item, function(event) OnEntityDestroy(event) end)
script.on_event(defines.events.on_robot_pre_mined, function(event) OnEntityDestroy(event) end)


--script.on_event(defines.events.on_player_selected_area,function(event) actorSystem:onSelectedArea(event) end)
--script.on_event(defines.events.on_player_selected_area,function(event) actorSystem:onAltSelectedArea(event) end)

------------------------------------------------------------------------------------------
--[[TICK FUNCTIONS]]--  60 ticks per second, keep code light or it can have a dramatic effect on updates per second
local function OnTick(event)
    if event.tick % 30 then
        actorSystem:tick(event)
        --csgui.on_tick(event)
    end  --Run tick event for actors every .5 seconds
    events.raiseEvents(event)  --Raise custom events on every tick.
end

script.on_event(defines.events.on_tick, OnTick)


------------------------------------------------------------------------------------------
--[[OPEN/CLOSE FUNCTIONS]]-- Custom Events from events.lua used to open and close custom GUI's
local function OnPlayerOpened(event)
    actorSystem:openGui(event.entity_name, event.player_index)
    doDebug(game.players[event.player_index].name .. " Opened " .. event.entity_name)
end


local function OnPlayerClosed(event)
    actorSystem:closeGui(event.entity_name, event.player_index)
    doDebug(game.players[event.player_index].name .. " Closed " .. event.entity_name)
end

script.on_event(events.on_player_closed, OnPlayerClosed)
script.on_event(events.on_player_opened, OnPlayerOpened)

------------------------------------------------------------------------------------------
--[[GUI HOOKS]]-- Used for detecting GUI actions, click, textbox changed, checkbox state changed[[
script.on_event(defines.events.on_gui_click, function(event)
    actorSystem:onGuiClick(event)
 end)

script.on_event(defines.events.on_gui_checked_state_changed, function(event)
    actorSystem:onGuiChecked(event)
 end)

-- script.on_event(defines.events.on_gui_text_changed, function(event)
--     actorSystem:onGuiText(event)
-- end)


------------------------------------------------------------------------------------------
--[[REMOTE INTERFACES]]-- Command Line and access from other mods is enabled here.
local interface = {}
--local csgui=require("actors/alerter-alert-expando")
function interface.printGlob(name, constant)  --Dumps the global to player and logfile
          if name then
        doDebug(global[name], "debug")
        if constant then doDebug(MOD[name], "debug") end
      else
        doDebug(global, "debug")
        if constant then doDebug(MOD, "debug") end
      end
end

function interface.config(key, value)
    if key then
        key=string.upper(key)
        if MOD.config.get(key) ~= nil then
            if value ~= nil then
                MOD.config.set(key, value)
                local val=MOD.config.get(key)
                Game.print_all(MOD.n .. ": New value for '" .. key .. "' is " .. "'" .. tostring(val) .."'")
                return val-- all is well
            else --value nil
                local val = MOD.config.get(key)
                Game.print_all(MOD.n .. ": Current value for '" .. key .. "' is " .. "'" .. tostring(val) .."'")
                return val
            end
        else --key is nill
            Game.print_all(MOD.n ..": Config '" .. key .. "' does not exist")
        return nil
        end
    else
        Game.print_all(MOD.n .. ": Config requires a key name")
        return nil
    end
end

function interface.resetMod()
    doDebug(MOD.name .. " Reset in progress")
    OnGameInit()
    actorSystem:reset()
    doDebug(MOD.name .. " Reset Complete", true)
end

function interface.resetPlayer(player_name_or_index)
    doDebug("Resetting Player:" ..player_name_or_index)
    local player=game.players[player_name_or_index]
    if player then newPlayerInit(player, true) end

end

function interface.hide_expando(player_name_or_index)
    local player = game.players[player_name_or_index]
    if global.playerData[player.index].expandoed then
        if player.gui.left.CS_root then
            local expandoElement = player.gui.left.CS_root.buttons.CS_expando
            game.raise_event(defines.events.on_gui_click, {player_index=player.index, element=expandoElement})
        end
        
        --csgui.on_click.CS_expando({player_index=player.index})
        return true
    end
    
    return false
end

function interface.show_expando(player_name_or_index)
    local player = game.players[player_name_or_index]
    if not global.playerData[player.index].expandoed then
        if player.gui.left.CS_root then
            local expandoElement = player.gui.left.CS_root.buttons.CS_expando
            game.raise_event(defines.events.on_gui_click, {player_index=player.index, element=expandoElement})
        end
        return false
    end
     return true
end

if MOD.config.get("LOGLEVEL", 0) >= 1 then  -- Use short name for interface if we are debugging
     remote.add_interface(MOD.n, interface)
end
remote.add_interface(MOD.name, interface)

