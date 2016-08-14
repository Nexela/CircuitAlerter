--All functions for the circuit alerter

require("stdlib/extras/utils")
local alerterEditor=require("guilib/alerter-msg-editor")
local circuit = require("stdlib/extras/circuit")
--local Game = require("stdlib/game")
--local csgui = require("guilib/alerter-alert-expando")

local circuitAlerter={
    name = "circuit-alerter",
    class = "entity"
}


function circuitAlerter:init()
    if not global.alerters then
        global.alerters = {}
    end
    for _, force in pairs (game.forces) do
        if force.technologies["circuit-network"].researched == true then
            force.recipe["circuit-alerter"].enabled = true
        end
    end
    doDebug("Actor: circuitAlerter Initialized")
end

function circuitAlerter:reset() -- Reset all alerters to default values.
    for _, surface in pairs(game.surfaces) do
        for _, orphan in pairs(surface.find_entities_filtered{type="lamp", name="circuit-alerter"}) do
            self:createEntity(orphan)
        end
    end
end

function circuitAlerter:initPlayerData(player_index)
    alerterEditor.initPlayerData(player_index)
end


function circuitAlerter:createEntity(entity, player_index)

    local pos = entity.position
    local unitnum = entity.unit_number

    self.alerter =
    {
        mapmark = nil,
        usemapmark = true,
        playsound = false,
        entity = entity,
        playerID = player_index or entity.built_by.index, -- Who built this alerter?
        uniqueID = unitnum,
        alert=false, -- Run alert on next update? type:bool
        message = "",
        expandedmsg = "",
        color = {r = 1, g = 1, b = 1},
        target_force = 1,       -- 1: Same force only, 2: All force
        target_distance = 3,    -- 1: Nearby, 2: Same surface, 3: All players
        method = 1              -- 1: Console, 2: Flying text, 3: Popup, 4: Goal, TODO: Implement Goal
    }

    --Alerter Created, Now update globals
    table.insert( global.alerters, self.alerter )
    doDebug("createAlerter: #".. unitnum ..", x=".. pos.x .. " y=".. pos.y)
end


function circuitAlerter:destroyEntity(entity)
    --local thisEntity=.entity
    for k, alerter in ipairs(global.alerters) do
        if alerter.entity == entity then
            if alerter.mapmark and alerter.mapmark.valid then
                alerter.mapmark.destroy()
            end
            doDebug("destroyAlerter: #" .. alerter.uniqueID .. ", x=".. alerter.entity.position.x .. " y=".. alerter.entity.position.y)
            --if alerter.alert.active TODO: need to clear if it has an active alert?
            table.remove(global.alerters,k)
            break
        end
    end
end



function circuitAlerter:tick()
    if #global.alerters > 0 then
        for index, alerter in ipairs(global.alerters) do
            self.update(alerter,index)
        end
    end
end
-------------------------------------------------------------------------------
--[[Message Helpers]]
local function FormatTicksToTime( ticks )
    local seconds = ticks / 60
    local minutes = seconds / 60
    local hours = minutes / 60
    return string.format("%02d:%02d:%02d",
        math.floor(hours + 0.5),
        math.floor(minutes + 0.5) % 60,
        math.floor(seconds + 0.5) % 60)
end

local function _getGameSpeed()
    return string.format("%.2f", game.speed)
end

local function _getResearch(force)
    return string.format("%.2f%%", force.research_progress)
end

local function _getDayTime(surface)
    return string.format("%.2f", surface.daytime)
end

local function _getPlayTime()
    local time = game.tick
    return FormatTicksToTime(time)
end

local function _getEvolution()
    return string.format("%.2d", game.evolution_factor)
end

local function _getPollution(entity)
    return entity.surface.get_pollution(entity.position)
end

local function _getLocation(entity)
    return string.format("[%.1d, %.1d]", entity.position.x, entity.position.y)
end

local function _getWriter(alerter)
    local player = game.players[alerter.playerID] or alerter.entity.built_by
    if player and player.name then
        return player.name
    else
        return ""
    end


end


-------------------------------------------------------------------------------

function circuitAlerter.expandMessage(alerter)
    -- "$s : game speed",
    -- "$r : current research progress",
    -- "$t : time of day",
    -- "$T : time of alert (in minutes:secs since world creation)",
    -- "$A : first signal name",
    -- "$B : second signal name",
    -- "$C : comparator (<, =, >)",
    -- "$I : all connected signals as name:count",
    -- "$e : evolution factor",
    -- "$p : pollution level",
    -- "$P : player who made the alert",
    -- "$F : force the alerter is on",
    -- "$S : surface the alerter is on.",
    -- "$L : position of the alerter.",
    local msg = alerter.message
    local entity = alerter.entity
    local signalOne, signalOneAmt, signalTwo, signalTwoAmt, comparator = circuit.getConditions(entity)

    local subs = {
        ["$A"] = signalOne,
        ["$1"] = signalOneAmt,
        ["$B"] = signalTwo,
        ["$2"] = signalTwoAmt,
        ["$C"] = comparator,
        ["$T"] = _getPlayTime(),
        ["$t"] = _getDayTime(entity.surface),
        ["$p"] = _getPollution(entity),
        ["$e"] = _getEvolution(),
        ["$R"] = _getResearch(entity.force),
        ["$L"] = _getLocation(entity),
        ["$s"] = _getGameSpeed(),
        ["$P"] = _getWriter(alerter),
        ["$S"] = entity.surface.name,
        ["$F"] = entity.force.name
    }

    msg = string.gsub(msg, "($%w)", function(match)
        local result = subs[match]
        if result then
            return result
        else
            return match
        end
    end)

 return msg
end

function circuitAlerter.addMapMark(alerter)
    local ent = alerter.entity
    local mapmark = ent.surface.create_entity({name = "circuit-alerter-mapmark", force = game.forces.neutral, position = ent.position})
    mapmark.operable = false
    mapmark.active = false
    mapmark.backer_name=alerter.expandedmsg
    alerter.mapmark = mapmark
end


function circuitAlerter.update(alerter, index)
    local entity = alerter.entity
    --if entity and entity.valid and entity.energy >= 1 then
        --local fulfilled, condition = circuit.getConditionFulfilled(entity)

        if entity.valid and entity.energy >= 1 and circuit.fulfilled(entity) then
            if alerter.alert == false then  -- Fulfilled but no alert yet. We only want to alert once.
                if alerter.message then
                    alerter.expandedmsg=circuitAlerter.expandMessage(alerter)
                    if alerter.usemapmark then circuitAlerter.addMapMark(alerter) end
                    if alerter.playsound then circuitAlerter.playSound(alerter) end
                    alerterEditor.broadcast_message_from_entity(alerter)
                end
                alerter.alert=true
            end
            global.alerters[index]=alerter --Save our updated alerter
        elseif alerter.alert == true then  -- No longer fulfilled or has no energy.
            if alerter.mapmark and alerter.mapmark.valid then
                alerter.mapmark.destroy()
            end
            alerter.alert = false
            global.alerters[index]=alerter --Save our updated alerter
        elseif not entity.valid then  --Entity no longer valid, remove mapmark and delete from table.
            if alerter.mapmark and alerter.mapmark.valid then
                alerter.mapmark.destroy()
            end
            table.remove(global.alerters,index)
        end
end


function circuitAlerter.getAlerter(entity)
    for k, alerter in ipairs(global.alerters) do
        if alerter.entity == entity then
            return global.alerters[k], k
        end
    end
    return nil, nil
end


function circuitAlerter:openGui(entityName, player_index) --Display our GUI
    --Display our GUI here.
    local player = game.players[player_index]
    local entity = player.opened
    local alerter, index = self.getAlerter(entity)
    
    if alerter then
        global.playerData[player_index].curGui=alerter
        alerterEditor.open_message_broadcaster_gui_for_player(player, alerter)
        doDebug("Open Custom Alerter Edit Gui")
    end
end

function circuitAlerter:closeGui(entityName, player_index)--Close our GUI
        --if global.playerData[player_index].currentGui and self.alerterEditGui then self.alerterEditGui.destroy() end
            --global.playerData[player_index].currentGui=nil
            local player=game.players[player_index]
            alerterEditor.close_message_broadcaster_gui_for_player(player)
end



function circuitAlerter:onGuiClick(event)
    alerterEditor.onGuiClick(event)
end

function circuitAlerter:onGuiCheck(event)
    alerterEditor.onGuiChecked(event)
end

function circuitAlerter:onGuiText(event)
    alerterEditor.onGuiText(event)
end



return circuitAlerter
