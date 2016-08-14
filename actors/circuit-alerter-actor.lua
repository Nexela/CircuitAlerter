--All functions for the circuit alerter

require("lib.utils")
--local alerterEditor=require("lib.alerter-msg-editor")
local circuit = require("lib.circuit")
--local Game = require("stdlib/game")
--local csgui = require("guilib/alerter-alert-expando")

local circuitAlerter={
    name = "circuit-alerter",
    class = "entity",
    alerter = {},
}
local alerterEditor = {
    gui_names = {},
    gui_captions = {}
}

-------------------------------------------------------------------------------
--[[CIRCUIT ALERTER]]
-------------------------------------------------------------------------------
function circuitAlerter.init()
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

function circuitAlerter.reset() -- Reset all alerters to default values.
    for _, surface in pairs(game.surfaces) do
        for _, orphan in pairs(surface.find_entities_filtered{type="lamp", name="circuit-alerter"}) do
            circuitAlerter.createEntity(orphan)
        end
    end
end

function circuitAlerter.initPlayerData(player_index)
    alerterEditor.initPlayerData(player_index)
end

function circuitAlerter.onGuiClick(event)
    alerterEditor.onGuiClick(event)
end

function circuitAlerter.onGuiCheck(event)
    alerterEditor.onGuiChecked(event)
end

function circuitAlerter.onGuiText(event)
    alerterEditor.onGuiText(event)
end

function circuitAlerter.createEntity(entity, player_index)

    local pos = entity.position
    local unitnum = entity.unit_number

    circuitAlerter.alerter =
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
    table.insert( global.alerters, circuitAlerter.alerter )
    doDebug("createAlerter: #".. unitnum ..", x=".. pos.x .. " y=".. pos.y)
end


function circuitAlerter.destroyEntity(entity)
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


function circuitAlerter.tick()
    if #global.alerters > 0 then
        for index, alerter in ipairs(global.alerters) do
            circuitAlerter.update(alerter,index)
        end
    end
end

-------------------------------------------------------------------------------

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
                    alerter.expandedmsg=alerterEditor.expandMessage(alerter)
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


function circuitAlerter.openGui(entityName, player_index) --Display our GUI
    --Display our GUI here.
    local player = game.players[player_index]
    local entity = player.opened
    local alerter, _ = circuitAlerter.getAlerter(entity)
    
    if alerter then
        global.playerData[player_index].curGui=alerter
        alerterEditor.open_message_broadcaster_gui_for_player(player, alerter)
        doDebug("Open Custom Alerter Edit Gui")
    end
end

function circuitAlerter.closeGui(entityName, player_index)--Close our GUI
        --if global.playerData[player_index].currentGui and self.alerterEditGui then self.alerterEditGui.destroy() end
            --global.playerData[player_index].currentGui=nil
            local player=game.players[player_index]
            alerterEditor.close_message_broadcaster_gui_for_player(player)
end

-------------------------------------------------------------------------------
--[[ALERTER MESSAGE EDITOR]]
-------------------------------------------------------------------------------

-- Defines. Mostly GUI element names.
alerterEditor.gui_names.settings_container = "message-broadcaster.settings_container"

alerterEditor.gui_names.settings_subcontainer_right = "message-broadcaster.settings_subcontainer_right"

alerterEditor.gui_names.settings_frame = "message-broadcaster.settings_frame"

alerterEditor.gui_names.settings_current_frame = "message-broadcaster.settings_current_frame"
alerterEditor.gui_names.settings_current_table = "message-broadcaster.settings_current_table"
alerterEditor.gui_names.settings_current_message_label = "message-broadcaster.settings_current_message_label"
alerterEditor.gui_names.settings_current_color_container = "message-broadcaster.settings_current_color_container"
alerterEditor.gui_names.settings_current_color_label = "message-broadcaster.settings_current_color_label"
alerterEditor.gui_names.settings_current_color_value_label = "message-broadcaster.settings_current_color_value_label"
alerterEditor.gui_names.settings_current_target_force_label = "message-broadcaster.settings_current_target_force_label"
alerterEditor.gui_names.settings_current_target_distance_label = "message-broadcaster.settings_current_target_distance_label"
alerterEditor.gui_names.settings_current_method_label = "message-broadcaster.settings_current_method_label"

alerterEditor.gui_names.settings_message_label_container = "message-broadcaster.settings_message_label_container"
alerterEditor.gui_names.settings_message_label = "message-broadcaster.settings_message_label"
alerterEditor.gui_names.settings_message_hint_button = "message-broadcaster.settings_message_hint_button"
alerterEditor.gui_names.settings_message_textfield = "message-broadcaster.settings_message_textfield"
alerterEditor.gui_names.settings_message_color_container = "message-broadcaster.settings_message_color_container"
alerterEditor.gui_names.settings_message_color_label = "message-broadcaster.settings_message_color_label"
alerterEditor.gui_names.settings_message_color_value_label = "message-broadcaster.settings_message_color_value_label"
alerterEditor.gui_names.settings_message_pick_color_button = "message-broadcaster.settings_message_pick_color_button"

alerterEditor.gui_names.settings_target_and_method_container = "message-broadcaster.settings_target_and_method_container"
alerterEditor.gui_names.settings_target_container = "message-broadcaster.settings_target_container"

alerterEditor.gui_names.settings_target_force_label = "message-broadcaster.settings_target_force_label"
alerterEditor.gui_names.settings_target_force_table = "message-broadcaster.settings_target_force_table"
alerterEditor.gui_names.settings_target_same_force_checkbox = "message-broadcaster.settings_target_same_force_checkbox"
alerterEditor.gui_names.settings_target_all_forces_checkbox = "message-broadcaster.settings_target_all_forces_checkbox"

alerterEditor.gui_names.settings_target_distance_label = "message-broadcaster.settings_target_distance_label"
alerterEditor.gui_names.settings_target_distance_table = "message-broadcaster.settings_target_distance_table"
alerterEditor.gui_names.settings_target_players_nearby_checkbox = "message-broadcaster.settings_target_players_nearby_checkbox"
alerterEditor.gui_names.settings_target_same_surface_checkbox = "message-broadcaster.settings_target_same_surface_checkbox"
alerterEditor.gui_names.settings_target_all_players_checkbox = "message-broadcaster.settings_target_all_players_checkbox"

alerterEditor.gui_names.settings_method_container = "message-broadcaster.settings_method_container"
alerterEditor.gui_names.settings_method_table = "message-broadcaster.settings_method_table"
alerterEditor.gui_names.settings_method_console_checkbox = "message-broadcaster.settings_method_console_checkbox"
alerterEditor.gui_names.settings_method_flying_text_checkbox = "message-broadcaster.settings_method_flying_text_checkbox"
alerterEditor.gui_names.settings_method_popup_checkbox = "message-broadcaster.settings_method_popup_checkbox"

alerterEditor.gui_names.settings_apply_and_reload_container = "message-broadcaster.settings_apply_and_reload_container"
alerterEditor.gui_names.settings_apply_button = "message-broadcaster.settings_apply_button"
alerterEditor.gui_names.settings_apply_and_reload_left_space = "message-broadcaster.settings_apply_and_reload_left_space"
alerterEditor.gui_names.settings_reload_button = "message-broadcaster.settings_reload_button"
alerterEditor.gui_names.settings_test_button = "message-broadcaster.settings_test_button"

alerterEditor.gui_names.message_hint_container = "message-broadcaster_message-hint-container"
alerterEditor.gui_names.message_hint_frame = "message-broadcaster_message-hint-frame"
alerterEditor.gui_names.message_hint_table = "message-broadcaster_message-hint-table"
alerterEditor.gui_names.message_hint_labels_prefix = "message-broadcaster_message-hint-label-"
alerterEditor.gui_names.color_picker_container = "message-broadcaster_color-picker"

alerterEditor.gui_names.received_message_popup_frame = "message-broadcaster_received-message-popup-frame"
alerterEditor.gui_names.received_message_popup_table = "message-broadcaster_received-message-popup-table"
alerterEditor.gui_names.received_message_popup_inner_frame_prefix = "message-broadcaster_received-message-popup-inner-frame-"
alerterEditor.gui_names.received_message_popup_label = "message-broadcaster_received-message-popup-label"
alerterEditor.gui_names.received_message_popup_button_container = "message-broadcaster_received-message-popup-button-container"
alerterEditor.gui_names.received_message_popup_button_space = "message-broadcaster_received-message-popup-button-space"
alerterEditor.gui_names.received_message_popup_button = "message-broadcaster_received-message-popup-button"

-- Captions.
--local alerterEditor.gui_captions.= {}

alerterEditor.gui_captions.target_forces = {}
table.insert(alerterEditor.gui_captions.target_forces, {"gui.message-broadcaster_same-force"})
table.insert(alerterEditor.gui_captions.target_forces, {"gui.message-broadcaster_all-force"})

alerterEditor.gui_captions.target_distances = {}
table.insert(alerterEditor.gui_captions.target_distances, {"gui.message-broadcaster_players-nearby"})
table.insert(alerterEditor.gui_captions.target_distances, {"gui.message-broadcaster_players-on-same-surface"})
table.insert(alerterEditor.gui_captions.target_distances, {"gui.message-broadcaster_all-players"})

alerterEditor.gui_captions.methods = {}
table.insert(alerterEditor.gui_captions.methods, {"gui.message-broadcaster_console"})
table.insert(alerterEditor.gui_captions.methods, {"gui.message-broadcaster_flying-text"})
table.insert(alerterEditor.gui_captions.methods, {"gui.message-broadcaster_popup"})
table.insert(alerterEditor.gui_captions.methods, {"gui.message-broadcaster_playsound"})
table.insert(alerterEditor.gui_captions.methods, {"gui.message-broadcaster_usemapmark"})

-- Our custom entity's name.
-- TODO: change it.
-- local entity_name = "circuit-alerter"
-- How many tiles does "Nearby" means in the target settings.
-- TODO: change it if needed.
local nearby_tiles = 1000
-- Maximum number of popup messages a player can stack.
local max_popup_message = 5

-- Converts the given color, e.g. {r = 1, g = 1, b = 1}, into printable string, e.g. (255, 255, 255).
local function get_string_for_color(color)
    local color_r, color_g, color_b
    if color.r then
        color_r = color.r * 255
    else
        color_r = 0
    end
    if color.g then
        color_g = color.g * 255
    else
        color_g = 0
    end
    if color.b then
        color_b = color.b * 255
    else
        color_b = 0
    end
    return "(" .. color_r .. ", " .. color_g .. ", " .. color_b .. ")"
end

-- Converts the given color string, e.g. (255, 255, 255), into color, e,g, {r = 1, g = 1, b = 1}
local function get_color_from_string(str)
    local r, g, b = string.match(str, "(%d+), (%d+), (%d+)")
    r = tonumber(r) / 255
    g = tonumber(g) / 255
    b = tonumber(b) / 255
    return {r = r, g = g, b = b}
end

-- Initialization.
function alerterEditor.initPlayerData(player_index)
    -- Initialize metatable for saving data in global.
    global.playerData[player_index].curGui = nil
    global.playerData[player_index].editorInit=true
end

-- Ticking. Mainly for opening or closing the custom GUI.
--script.on_event(defines.events.on_tick, function(event)
--     -- Remove invalid data.
--     for index, data in ipairs(global.message_broadcaster.broadcaster_datas) do
--         if not data.entity.valid then
--             table.remove(global.message_broadcaster.broadcaster_datas, index)
--         end
--     end
-- end
-------------------------------------------------------------------------------

-- GUI click.
--script.on_event(defines.events.on_gui_click, function(event)
function alerterEditor.onGuiClick(event)
    local element = event.element
    local player = game.players[event.player_index]
    local settings_container = player.gui.left[alerterEditor.gui_names.settings_container]
    
    -- Show message hint button.
    if element.name == alerterEditor.gui_names.settings_message_hint_button then
        -- If no hint box exists, add one. Also destroy the color picker if it exists.
        if settings_container[alerterEditor.gui_names.color_picker_container] then
            settings_container[alerterEditor.gui_names.color_picker_container].destroy()
        end
        if settings_container[alerterEditor.gui_names.message_hint_container] then
            settings_container[alerterEditor.gui_names.message_hint_container].destroy()
        else
            alerterEditor.show_message_hint(settings_container)
        end
        return
    end
    
    
    -- Pick color button. -- If color picker not installed replace with textbox for setting color?
    if element.name == alerterEditor.gui_names.settings_message_pick_color_button then
        -- If no color picker exists, add one. Also destroy the hint box if it exists.
        if settings_container[alerterEditor.gui_names.message_hint_container] then
            settings_container[alerterEditor.gui_names.message_hint_container].destroy()
        end
        if settings_container[alerterEditor.gui_names.color_picker_container] then
            settings_container[alerterEditor.gui_names.color_picker_container].destroy()
        else
            local message_color_container = element.parent
            local message_color_value_label = message_color_container[alerterEditor.gui_names.settings_message_color_value_label]
            local color = get_color_from_string(message_color_value_label.caption)
            if remote.interfaces["color-picker"] then
            remote.call("color-picker", "add_instance",
            {
                parent = settings_container,
                container_name = alerterEditor.gui_names.color_picker_container,
                title_caption = {"gui.message-broadcaster_set_message_color"},
                color = color
            })
        end
        end
        return
    end
    
    -- Reload button.
    if element.name == alerterEditor.gui_names.settings_reload_button then
        alerterEditor.reload_message_broadcaster_gui_for_player(player)
        return
    end
    
    -- Apply button.
    if element.name == alerterEditor.gui_names.settings_apply_button then
        local target_entity = global.playerData[event.player_index].curGui

        -- Load the new settings from the GUI.
        local new_message, new_color, new_target_force, new_target_distance, new_method
        
        local subcontainer_right = settings_container[alerterEditor.gui_names.settings_subcontainer_right]
        local frame = subcontainer_right[alerterEditor.gui_names.settings_frame]
        
        -- Message.
        new_message = frame[alerterEditor.gui_names.settings_message_textfield].text
        
        -- Message color.
        local message_color_container = frame[alerterEditor.gui_names.settings_message_color_container]
        local color_value_label = message_color_container[alerterEditor.gui_names.settings_message_color_value_label]
        new_color = get_color_from_string(color_value_label.caption)
        
        -- Target and method container.
        local target_and_method_container = subcontainer_right[alerterEditor.gui_names.settings_target_and_method_container]
        
        -- Target container.
        local target_container = target_and_method_container[alerterEditor.gui_names.settings_target_container]
        
        -- Target - Force
        local force_table = target_container[alerterEditor.gui_names.settings_target_force_table]
        if force_table[alerterEditor.gui_names.settings_target_same_force_checkbox].state then
            new_target_force = 1
        else
            new_target_force = 2
        end
        
        -- Target - Distance
        local distance_table = target_container[alerterEditor.gui_names.settings_target_distance_table]
        if distance_table[alerterEditor.gui_names.settings_target_players_nearby_checkbox].state then
            new_target_distance = 1
        elseif distance_table[alerterEditor.gui_names.settings_target_same_surface_checkbox].state then
            new_target_distance = 2
        else
            new_target_distance = 3
        end
        
        -- Method.
        local method_container = target_and_method_container[alerterEditor.gui_names.settings_method_container]
        local method_table = method_container[alerterEditor.gui_names.settings_method_table]
        if method_table[alerterEditor.gui_names.settings_method_console_checkbox].state then
            new_method = 1
        elseif method_table[alerterEditor.gui_names.settings_method_flying_text_checkbox].state then
            new_method = 2
        else
            new_method = 3
        end
        
        -- Apply!
        alerterEditor.save_settings_to_entity(target_entity, new_message, new_color, new_target_force, new_target_distance, new_method)
                
        -- Also update the UIs for players who are opening the same entity.
        for index, _ in pairs(global.playerData) do
            if global.playerData[index].curGui == target_entity then
                alerterEditor.update_current_message_settings_for_player(game.players[index])
            end
        end
        return
    end

        --Test Button. --Apply settings to curgui? and then test. TODO: temporarily save?
    if element.name == alerterEditor.gui_names.settings_test_button then
        local alerter = global.playerData[event.player_index].curGui
        -- Broadcast the expanded message for testing.
        
        alerter.expandedmsg=alerterEditor.expandMessage(alerter)
        alerterEditor.broadcast_message_from_entity(alerter)
        return
    end
    
    -- OK button on the message popup.
    if element.name == alerterEditor.gui_names.received_message_popup_button then
        -- button -> button_container -> inner_frame
        local inner_frame = element.parent.parent
        -- inner_frame -> message_table -> popup frame
        local message_table = inner_frame.parent
        local popup_frame = message_table.parent
        
        -- Dismiss the message by destroying the inner frame.
        inner_frame.destroy()
        -- If no more message is in the message table, destroy the whole popup.
        if #message_table.children_names <= 0 then
            popup_frame.destroy()
        end
        
        return
    end
end -- onGuiClick
-------------------------------------------------------------------------------

-- Checked state changed.
--script.on_event(defines.events.on_gui_checked_state_changed, function(event)
function alerterEditor.onGuiChecked(event)
    local element = event.element
    
    -- Target - Force
    -- Same force.
    if element.name == alerterEditor.gui_names.settings_target_same_force_checkbox then
        if element.state then
            -- It becomes true now, turn "all forces" to false.
            local force_table = element.parent
            force_table[alerterEditor.gui_names.settings_target_all_forces_checkbox].state = false
        else
            -- It becomes false now. But it should act like a radio button. It shouldn't be set from true to false. So, set it back to true.
            element.state = true
        end
        return
    end
    -- All forces.
    if element.name == alerterEditor.gui_names.settings_target_all_forces_checkbox then
        if element.state then
            local force_table = element.parent
            force_table[alerterEditor.gui_names.settings_target_same_force_checkbox].state = false
        else
            element.state = true
        end
        return
    end
    
    -- Target - Distance
    -- Players nearby.
    if element.name == alerterEditor.gui_names.settings_target_players_nearby_checkbox then
        if element.state then
            local distance_table = element.parent
            distance_table[alerterEditor.gui_names.settings_target_same_surface_checkbox].state = false
            distance_table[alerterEditor.gui_names.settings_target_all_players_checkbox].state = false
        else
            element.state = true
        end
        return
    end
    -- Players on the same surface.
    if element.name == alerterEditor.gui_names.settings_target_same_surface_checkbox then
        if element.state then
            local distance_table = element.parent
            distance_table[alerterEditor.gui_names.settings_target_players_nearby_checkbox].state = false
            distance_table[alerterEditor.gui_names.settings_target_all_players_checkbox].state = false
        else
            element.state = true
        end
        return
    end
    -- All players.
    if element.name == alerterEditor.gui_names.settings_target_all_players_checkbox then
        if element.state then
            local distance_table = element.parent
            distance_table[alerterEditor.gui_names.settings_target_players_nearby_checkbox].state = false
            distance_table[alerterEditor.gui_names.settings_target_same_surface_checkbox].state = false
        else
            element.state = true
        end
        return
    end
    
    -- Methods.
    -- Console.
    if element.name == alerterEditor.gui_names.settings_method_console_checkbox then
        if element.state then
            local method_table = element.parent
            method_table[alerterEditor.gui_names.settings_method_flying_text_checkbox].state = false
            method_table[alerterEditor.gui_names.settings_method_popup_checkbox].state = false
        else
            element.state = true
        end
        return
    end
    -- Flying text.
    if element.name == alerterEditor.gui_names.settings_method_flying_text_checkbox then
        if element.state then
            local method_table = element.parent
            method_table[alerterEditor.gui_names.settings_method_console_checkbox].state = false
            method_table[alerterEditor.gui_names.settings_method_popup_checkbox].state = false
        else
            element.state = true
        end
        return
    end
    -- Popup.
    if element.name == alerterEditor.gui_names.settings_method_popup_checkbox then
        if element.state then
            local method_table = element.parent
            method_table[alerterEditor.gui_names.settings_method_console_checkbox].state = false
            method_table[alerterEditor.gui_names.settings_method_flying_text_checkbox].state = false
        else
            element.state = true
        end
        return
    end
end
-------------------------------------------------------------------------------

-- Color picker color updated.
if remote.interfaces["color-picker"] then
script.on_event(remote.call("color-picker", "on_color_updated"), function(event)
    if event.container.name == alerterEditor.gui_names.color_picker_container then
        -- Update color.
        local settings_container = event.container.parent
        if settings_container and settings_container.name == alerterEditor.gui_names.settings_container then
            local subcontainer_right = settings_container[alerterEditor.gui_names.settings_subcontainer_right]
            if subcontainer_right then
                local frame = subcontainer_right[alerterEditor.gui_names.settings_frame]
                if frame then
                    local message_color_container = frame[alerterEditor.gui_names.settings_message_color_container]
                    if message_color_container then
                        local message_color_value_label = message_color_container[alerterEditor.gui_names.settings_message_color_value_label]
                        if message_color_value_label then
                            local r, g, b = event.color.r * 255, event.color.g * 255, event.color.b * 255
                            message_color_value_label.caption = "(" .. r .. ", " .. g .. ", " .. b .. ")"
                            message_color_value_label.style.font_color = event.color
                        end
                    end
                end
            end
        end
    end
end)
end

-------------------------------------------------------------------------------
--[[Message Helpers]]

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
    local tick = game.tick
    return Time.FormatTicksToTime(tick)
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

function alerterEditor.expandMessage(alerter)
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

-- Shows the message hint box under the given container.
function alerterEditor.show_message_hint(main_container)
    -- TODO: change the hints if needed. Localize them.
    local hints =
    {
        ["$A"] = "hint-A",
        ["$1"] = "hint-1",
        ["$B"] = "hint-B",
        ["$2"] = "hint-2",
        ["$C"] = "hint-C",
        ["$T"] = "hint-T",
        ["$t"] = "hint-t",
        ["$p"] = "hint-p",
        ["$e"] = "hint-e",
        ["$R"] = "hint-R",
        ["$L"] = "hint-L",
        ["$s"] = "hint-s",
        ["$P"] = "hint-P",
        ["$S"] = "hint-S",
        ["$F"] = "hint-F",

    }
    
    main_container.add({type = "flow", name = alerterEditor.gui_names.message_hint_container, direction = "vertical"})
    local message_hint_container = main_container[alerterEditor.gui_names.message_hint_container]
    
    message_hint_container.add({type = "frame", name = alerterEditor.gui_names.message_hint_frame, direction = "vertical", caption = {"gui.message-broadcaster_hints-title"}})
    local frame = message_hint_container[alerterEditor.gui_names.message_hint_frame]
    
    frame.add({type = "table", name = alerterEditor.gui_names.message_hint_table, colspan = 1})
    local hint_table = frame[alerterEditor.gui_names.message_hint_table]
    
    for index, hint in pairs(hints) do
        hint_table.add({type = "label", name = alerterEditor.gui_names.message_hint_labels_prefix .. hint, caption = {"hints."..hint, index}})
    end
end

-------------------------------------------------------------------------------

-- Returns the current message settings from the given entity.
function alerterEditor.load_current_settings_from_entity(entity)
    -- TODO: change the following lines if needed.
    --for _, data in ipairs(global.message_broadcaster.broadcaster_datas) do
        if entity then
            local current_message = entity.message
            local current_color = entity.color
            local current_target_force = entity.target_force
            local current_target_distance = entity.target_distance
            local current_method = entity.method
            return current_message, current_color, current_target_force, current_target_distance, current_method
        end
    --end
    -- Data not found.
    return nil, nil, nil, nil, nil
end

-------------------------------------------------------------------------------

-- Saves the given settings to the entity.
function alerterEditor.save_settings_to_entity(entity, message, color, target_force, target_distance, method)
    -- TODO: change the following lines if needed.
    for index, alerter in ipairs(global.alerters) do
        if alerter.entity == entity.entity then
            alerter.message = message
            alerter.color = color
            alerter.target_force = target_force
            alerter.target_distance = target_distance
            alerter.method = method
            global.alerters[index]=alerter
            --break
        end
    end
end

-------------------------------------------------------------------------------

-- Opens our custom GUI for the given player targeting the given entity.
function alerterEditor.open_message_broadcaster_gui_for_player(player, target_entity)
    -- Coming from circuit alerter actor we are passing the actor we need.
    -- Record the player so we know a custom GUI is being opened for him.
    global.playerData[player.index].curGui = target_entity -- TODO: unit_num?
    
    -- Load data from the entity.
    local current_message, current_color, current_target_force, current_target_distance, current_method = alerterEditor.load_current_settings_from_entity(target_entity)
    
    -- Convert the color to 0 - 255 and separate the channels for display.
    local current_color_text = get_string_for_color(current_color)
    
    -- Width of the main frame.
    local main_frame_width = 500
    -- Width of the apply and reload buttons.
    local apply_and_reload_button_width = 100
    
    local left = player.gui.left
    left.add({type = "table", name = alerterEditor.gui_names.settings_container, colspan = 2})
    local container = left[alerterEditor.gui_names.settings_container]
    container.style.top_padding = 8
    container.style.left_padding = 8
    container.style.horizontal_spacing = 0 -- Only table can set cell spacing.
    
    container.add({type = "table", name = alerterEditor.gui_names.settings_subcontainer_right, colspan = 1})
    local subcontainer_right = container[alerterEditor.gui_names.settings_subcontainer_right]
    subcontainer_right.style.vertical_spacing = 0
    
    -- Add the main frame.
    subcontainer_right.add({type = "frame", name = alerterEditor.gui_names.settings_frame, direction = "vertical", caption = {"gui.message-broadcaster_title"}})
    local frame = subcontainer_right[alerterEditor.gui_names.settings_frame]
    frame.style.minimal_width = main_frame_width
    frame.style.maximal_width = frame.style.minimal_width
    
    -- Current frame.
    frame.add({type = "frame", name = alerterEditor.gui_names.settings_current_frame, direction = "vertical"})
    local current_frame = frame[alerterEditor.gui_names.settings_current_frame]
    current_frame.style.minimal_width = main_frame_width - 9 * 3
    current_frame.style.maximal_width = current_frame.style.minimal_width
    current_frame.add({type = "table", name = alerterEditor.gui_names.settings_current_table, colspan = 1}) -- This table is needed to vertical align the labels.
    local current_table = current_frame[alerterEditor.gui_names.settings_current_table]
    -- Current message.
    current_table.add({type = "label", name = alerterEditor.gui_names.settings_current_message_label, caption = {"gui.message-broadcaster_current-message", current_message}})
    -- Current color.
    current_table.add({type = "flow", name = alerterEditor.gui_names.settings_current_color_container, direction = "horizontal"})
    local current_color_container = current_table[alerterEditor.gui_names.settings_current_color_container]
    current_color_container.add({type = "label", name = alerterEditor.gui_names.settings_current_color_label, caption = {"gui.message-broadcaster_current-color"}})
    current_color_container.add({type = "label", name = alerterEditor.gui_names.settings_current_color_value_label, caption = current_color_text})
    local current_color_value_label = current_color_container[alerterEditor.gui_names.settings_current_color_value_label]
    current_color_value_label.style.font_color = current_color
    -- Current target force.
    current_table.add({type = "label", name = alerterEditor.gui_names.settings_current_target_force_label, caption = {"gui.message-broadcaster_current-target-force", alerterEditor.gui_captions.target_forces[current_target_force]}})
    -- Current target distance.
    current_table.add({type = "label", name = alerterEditor.gui_names.settings_current_target_distance_label, caption = {"gui.message-broadcaster_current-target-distance", alerterEditor.gui_captions.target_distances[current_target_distance]}})
    -- Current method.
    current_table.add({type = "label", name = alerterEditor.gui_names.settings_current_method_label, caption = {"gui.message-broadcaster_current-method", alerterEditor.gui_captions.methods[current_method]}})
    
    -- Set message label.
    frame.add({type = "flow", name = alerterEditor.gui_names.settings_message_label_container, direction = "horizontal"}) -- This container is required because the hint button is causing unwanted space vertically. May
    local label_container = frame[alerterEditor.gui_names.settings_message_label_container]
    label_container.style.maximal_height = 25 -- Limit the height
    label_container.add({type = "label", name = alerterEditor.gui_names.settings_message_label, caption = {"gui.message-broadcaster_set-message"}})
    local set_message_label = label_container[alerterEditor.gui_names.settings_message_label]
    set_message_label.style.minimal_width = main_frame_width - 8 * 4 - 20
    set_message_label.style.maximal_width = set_message_label.style.minimal_width
    -- Hint button.
    label_container.add({type = "button", name = alerterEditor.gui_names.settings_message_hint_button, style = "small_message_hint_panel_button_style", tooltip = {"gui.message-broadcaster_show-hints"}})
    
    -- Set message textfield.
    frame.add({type = "textfield", name = alerterEditor.gui_names.settings_message_textfield, text = current_message})
    local textfield = frame[alerterEditor.gui_names.settings_message_textfield]
    textfield.style.minimal_width = main_frame_width - 13 * 2
    textfield.style.maximal_width = textfield.style.minimal_width
    
    -- Message color.
    frame.add({type = "flow", name = alerterEditor.gui_names.settings_message_color_container, direction = "horizontal"}) -- Same as above, this container is required.
    local message_color_container = frame[alerterEditor.gui_names.settings_message_color_container]
    message_color_container.style.maximal_height = 25 -- Limit the height
    message_color_container.add({type = "label", name = alerterEditor.gui_names.settings_message_color_label, caption = {"gui.message-broadcaster_message-color"}})
    message_color_container.add({type = "label", name = alerterEditor.gui_names.settings_message_color_value_label, caption = current_color_text})
    local color_value_label = message_color_container[alerterEditor.gui_names.settings_message_color_value_label]
    color_value_label.style.font_color = current_color
    -- Pick color button.
    if remote.interfaces["color-picker"] then message_color_container.add({type = "button", name = alerterEditor.gui_names.settings_message_pick_color_button, style = "small_color_picker_panel_button_style", tooltip = {"gui.message-broadcaster_pick-color"}}) end
    
    -- Target and method container.
    subcontainer_right.add({type = "table", name = alerterEditor.gui_names.settings_target_and_method_container, colspan = 2})
    local target_and_method_container = subcontainer_right[alerterEditor.gui_names.settings_target_and_method_container]
    target_and_method_container.style.vertical_spacing = 0
    target_and_method_container.style.horizontal_spacing = 0
    
    -- Target container.
    target_and_method_container.add({type = "frame", name = alerterEditor.gui_names.settings_target_container, direction = "vertical", caption = {"gui.message-broadcaster_target"}})
    local target_container = target_and_method_container[alerterEditor.gui_names.settings_target_container]
    target_container.style.minimal_width = main_frame_width * 0.5
    target_container.style.maximal_width = target_container.style.minimal_width
    
    -- Target - Force
    target_container.add({type = "label", name = alerterEditor.gui_names.settings_target_force_label, caption = {"gui.message-broadcaster_force"}})
    target_container.add({type = "table", name = alerterEditor.gui_names.settings_target_force_table, colspan = 1}) -- This table is needed, because checkboxes are horizontally aligned. They will be on the same line if their captions are not long enough.
    local force_table = target_container[alerterEditor.gui_names.settings_target_force_table]
    force_table.style.left_padding = 10
    force_table.add({type = "checkbox", name = alerterEditor.gui_names.settings_target_same_force_checkbox, state = current_target_force == 1, caption = alerterEditor.gui_captions.target_forces[1]})
    force_table.add({type = "checkbox", name = alerterEditor.gui_names.settings_target_all_forces_checkbox, state = current_target_force == 2, caption = alerterEditor.gui_captions.target_forces[2]})
    
    -- Target - Distance
    target_container.add({type = "label", name = alerterEditor.gui_names.settings_target_distance_label, caption = {"gui.message-broadcaster_distance"}})
    target_container.add({type = "table", name = alerterEditor.gui_names.settings_target_distance_table, colspan = 1}) -- Same as force_table
    local distance_table = target_container[alerterEditor.gui_names.settings_target_distance_table]
    distance_table.style.left_padding = 10
    distance_table.add({type = "checkbox", name = alerterEditor.gui_names.settings_target_players_nearby_checkbox, state = current_target_distance == 1, caption = alerterEditor.gui_captions.target_distances[1]})
    distance_table.add({type = "checkbox", name = alerterEditor.gui_names.settings_target_same_surface_checkbox, state = current_target_distance == 2, caption = alerterEditor.gui_captions.target_distances[2]})
    distance_table.add({type = "checkbox", name = alerterEditor.gui_names.settings_target_all_players_checkbox, state = current_target_distance == 3, caption = alerterEditor.gui_captions.target_distances[3]})
    
    -- Method.
    target_and_method_container.add({type = "frame", name = alerterEditor.gui_names.settings_method_container, direction = "vertical", caption = {"gui.message-broadcaster_method"}})
    local method_container = target_and_method_container[alerterEditor.gui_names.settings_method_container]
    method_container.style.minimal_width = target_container.style.minimal_width
    method_container.style.maximal_width = target_container.style.maximal_width
    method_container.add({type = "table", name = alerterEditor.gui_names.settings_method_table, colspan = 1}) -- Same as force_table
    local method_table = method_container[alerterEditor.gui_names.settings_method_table]
    method_table.add({type = "checkbox", name = alerterEditor.gui_names.settings_method_console_checkbox, state = current_method == 1, caption = alerterEditor.gui_captions.methods[1]})
    method_table.add({type = "checkbox", name = alerterEditor.gui_names.settings_method_flying_text_checkbox, state = current_method == 2, caption = alerterEditor.gui_captions.methods[2]})
    method_table.add({type = "checkbox", name = alerterEditor.gui_names.settings_method_popup_checkbox, state = current_method == 3, caption = alerterEditor.gui_captions.methods[3]})
    method_table.add({type = "checkbox", name = alerterEditor.gui_names.settings_method_playsound_checkbox, state = current_method == 4, caption = alerterEditor.gui_captions.methods[4]})
    method_table.add({type = "checkbox", name = alerterEditor.gui_names.settings_method_mapmark_checkbox, state = current_method == 5, caption = alerterEditor.gui_captions.methods[5]})
    
    -- Apply and reload.
    subcontainer_right.add({type = "frame", name = alerterEditor.gui_names.settings_apply_and_reload_container, direction = "horizontal"})
    local apply_and_reload_container = subcontainer_right[alerterEditor.gui_names.settings_apply_and_reload_container]
    apply_and_reload_container.style.minimal_width = frame.style.minimal_width
    apply_and_reload_container.style.maximal_width = frame.style.maximal_width
    
    -- Left space.
    apply_and_reload_container.add({type = "flow", name = alerterEditor.gui_names.settings_apply_and_reload_left_space, direction = "horizontal"})
    local apply_and_reload_left_space = apply_and_reload_container[alerterEditor.gui_names.settings_apply_and_reload_left_space]
    

    -- Reload button.
    apply_and_reload_container.add({type = "button", name = alerterEditor.gui_names.settings_reload_button, caption = {"gui.message-broadcaster_reload"}})
    local reload_button = apply_and_reload_container[alerterEditor.gui_names.settings_reload_button]
    reload_button.style.minimal_width = apply_and_reload_button_width
    reload_button.style.maximal_width = reload_button.style.minimal_width
    
    -- Apply button.
    apply_and_reload_container.add({type = "button", name = alerterEditor.gui_names.settings_apply_button, caption = {"gui.message-broadcaster_apply"}})
    local apply_button = apply_and_reload_container[alerterEditor.gui_names.settings_apply_button]
    apply_button.style.minimal_width = reload_button.style.minimal_width
    apply_button.style.maximal_width = apply_button.style.minimal_width
    
    --- Test Button
    local loglevel = MOD.config.get("LOGLEVEL")
    if  loglevel >= 1 then
    apply_and_reload_container.add({type = "button", name = alerterEditor.gui_names.settings_test_button, caption = {"gui.message-broadcaster_test"}})
    local test_button = apply_and_reload_container[alerterEditor.gui_names.settings_test_button]
    test_button.style.minimal_width = apply_and_reload_button_width
    test_button.style.maximal_width = test_button.style.minimal_width
    end

    --- Resize Left space based on amount of buttons
    local resizer = #apply_and_reload_container["children_names"] - 1 -- count all the buttons, don't forget to subtract the frame.
    apply_and_reload_left_space.style.minimal_width = main_frame_width - 8 * 5 - apply_and_reload_button_width * resizer
    apply_and_reload_left_space.style.maximal_width = apply_and_reload_left_space.minimal_width

end

-------------------------------------------------------------------------------

-- Closes our custom GUI for the given player.
function alerterEditor.close_message_broadcaster_gui_for_player(player)
    local left = player.gui.left
    if left[alerterEditor.gui_names.settings_container] then
        left[alerterEditor.gui_names.settings_container].destroy()
    end
    
    -- Remove the record about the player.
    global.playerData[player.index].curGui = nil
end

-------------------------------------------------------------------------------

-- Updates the current message settings in our custom GUI for the given player according to his opened entity.
-- This may be called when someone clicked the apply button, so all players opening the same entity should have their UI updated.
function alerterEditor.update_current_message_settings_for_player(player)
    local left = player.gui.left
    if not left[alerterEditor.gui_names.settings_container] then
        -- Not opened. Do nothing.
        return
    end
    
    if not global.playerData[player.index].curGui then
        -- The player has not opened our entity!
        return
    end
    
    local target_entity = global.playerData[player.index].curGui
    
    -- Load data from the entity.
    local current_message, current_color, current_target_force, current_target_distance, current_method = alerterEditor.load_current_settings_from_entity(target_entity)
    
    -- Convert the color to 0 - 255 and separate the channels for display.
    local current_color_text = get_string_for_color(current_color)
    
    local container = left[alerterEditor.gui_names.settings_container]
    local subcontainer_right = container[alerterEditor.gui_names.settings_subcontainer_right]
    
    local frame = subcontainer_right[alerterEditor.gui_names.settings_frame]
    local current_frame = frame[alerterEditor.gui_names.settings_current_frame]
    local current_table = current_frame[alerterEditor.gui_names.settings_current_table]
    -- Current message.
    current_table[alerterEditor.gui_names.settings_current_message_label].caption = {"gui.message-broadcaster_current-message", current_message}
    -- Current color.
    local current_color_container = current_table[alerterEditor.gui_names.settings_current_color_container]
    local current_color_value_label = current_color_container[alerterEditor.gui_names.settings_current_color_value_label]
    current_color_value_label.caption = current_color_text
    current_color_value_label.style.font_color = current_color
    -- Current target force.
    current_table[alerterEditor.gui_names.settings_current_target_force_label].caption = {"gui.message-broadcaster_current-target-force", alerterEditor.gui_captions.target_forces[current_target_force]}
    -- Current target distance.
    current_table[alerterEditor.gui_names.settings_current_target_distance_label].caption = {"gui.message-broadcaster_current-target-distance", alerterEditor.gui_captions.target_distances[current_target_distance]}
    -- Current method.
    current_table[alerterEditor.gui_names.settings_current_method_label].caption = {"gui.message-broadcaster_current-method", alerterEditor.gui_captions.methods[current_method]}
end

-------------------------------------------------------------------------------

-- Reloads the settings in our custom GUI for the given player.
function alerterEditor.reload_message_broadcaster_gui_for_player(player)
    local left = player.gui.left
    if not left[alerterEditor.gui_names.settings_container] then
        -- Not opened. Do nothing.
        return
    end
    
    if not global.playerData[player.index].curGui then
        -- The player has not opened our entity!
        return
    end
    
    local target_entity = global.playerData[player.index].curGui
    
    -- Load data from the entity.
    local current_message, current_color, current_target_force, current_target_distance, current_method = alerterEditor.load_current_settings_from_entity(target_entity)
    
    -- Convert the color to 0 - 255 and separate the channels for display.
    local current_color_text = get_string_for_color(current_color)
    
    --was container?
    local container = left[alerterEditor.gui_names.settings_container]
    local subcontainer_right = container[alerterEditor.gui_names.settings_subcontainer_right]
    local frame = subcontainer_right[alerterEditor.gui_names.settings_frame]
    
    -- Message.
    frame[alerterEditor.gui_names.settings_message_textfield].text = current_message
    
    -- Message color.
    local message_color_container = frame[alerterEditor.gui_names.settings_message_color_container]
    local color_value_label = message_color_container[alerterEditor.gui_names.settings_message_color_value_label]
    color_value_label.caption = current_color_text
    color_value_label.style.font_color = current_color
    
    -- Color picker if it is opened.
    if container[alerterEditor.gui_names.color_picker_container] then
        remote.call("color-picker", "set_color", container[alerterEditor.gui_names.color_picker_container], current_color)
    end
    
    -- Target and method container.
    local target_and_method_container = subcontainer_right[alerterEditor.gui_names.settings_target_and_method_container]
    
    -- Target container.
    local target_container = target_and_method_container[alerterEditor.gui_names.settings_target_container]
    
    -- Target - Force
    local force_table = target_container[alerterEditor.gui_names.settings_target_force_table]
    force_table[alerterEditor.gui_names.settings_target_same_force_checkbox].state = current_target_force == 1
    force_table[alerterEditor.gui_names.settings_target_all_forces_checkbox].state = current_target_force == 2
    
    -- Target - Distance
    local distance_table = target_container[alerterEditor.gui_names.settings_target_distance_table]
    distance_table[alerterEditor.gui_names.settings_target_players_nearby_checkbox].state = current_target_distance == 1
    distance_table[alerterEditor.gui_names.settings_target_same_surface_checkbox].state = current_target_distance == 2
    distance_table[alerterEditor.gui_names.settings_target_all_players_checkbox].state = current_target_distance == 3
    
    -- Method.
    local method_container = target_and_method_container[alerterEditor.gui_names.settings_method_container]
    local method_table = method_container[alerterEditor.gui_names.settings_method_table]
    method_table[alerterEditor.gui_names.settings_method_console_checkbox].state = current_method == 1
    method_table[alerterEditor.gui_names.settings_method_flying_text_checkbox].state = current_method == 2
    method_table[alerterEditor.gui_names.settings_method_popup_checkbox].state = current_method == 3
end

-------------------------------------------------------------------------------

-- Broadcasts the message according to the given broadcaster entity.
function alerterEditor.broadcast_message_from_entity(alerter)
    --for _, alerter in ipairs(global.message_broadcaster.broadcaster_alerters) do
        --if alerter.entity == entity then
            if alerter and alerter.entity.valid then
            -- Get all target players first.
            local target_players = {}
            local entity=alerter.entity
            local entity_owner = alerter.entity.built_by or alerter.playerID
            if entity_owner == nil then
                -- No owner. Do nothing.
            end
            
            -- Add players by force.
            if alerter.target_force == 1 then
                -- Same force only.
                for _, p in pairs(game.players) do
                    if p.force == entity_owner.force then
                        table.insert(target_players, p)
                    end
                end
            else
                -- All forces.
                for _, p in pairs(game.players) do
                    table.insert(target_players, p)
                end
            end
            
            -- Remove players by distance.
            if alerter.target_distance == 1 then
                -- Nearby.
                for index, p in ipairs(target_players) do
                    if p.surface ~= entity.surface or math.abs(p.position.x - entity.position.x) > nearby_tiles or math.abs(p.position.y - entity.position.y) > nearby_tiles then
                        table.remove(target_players, index)
                    end
                end
            elseif alerter.target_distance == 2 then
                -- Same surface.
                for index, p in ipairs(target_players) do
                    if p.surface ~= entity.surface then
                        table.remove(target_players, index)
                    end
                end
            end
            
            -- Broadcast the message to the target players.
            if alerter.method == 1 then
                -- Console.
                for _, p in ipairs(target_players) do
                    p.print(alerter.expandedmsg)
                end
            elseif alerter.method == 2 then
                -- Flying text.
                for _, p in ipairs(target_players) do
                    p.surface.create_entity{name = "flying-text", position = p.position, text = alerter.expandedmsg, color = alerter.color}
                end
            else
                -- Popup.
                for _, p in ipairs(target_players) do
                    local center = p.gui.center
                    local frame = center[alerterEditor.gui_names.received_message_popup_frame]
                    -- Create the frame if it does not exist.
                    if not frame then
                        center.add({type = "frame", name = alerterEditor.gui_names.received_message_popup_frame, direction = "vertical", caption = {"gui.message-broadcaster_title"}})
                        frame = center[alerterEditor.gui_names.received_message_popup_frame]
                        frame.add({type = "table", name = alerterEditor.gui_names.received_message_popup_table, colspan = 1})
                    end
                    
                    local message_table = frame[alerterEditor.gui_names.received_message_popup_table]
                    local children_names = message_table.children_names
                    local children_num = #children_names
                    local usable_name
                    -- Remove the oldest message if there are too many.
                    if children_num >= max_popup_message then
                        -- We can simply reuse the name of the removed element.
                        usable_name = children_names[1]
                        message_table[usable_name].destroy()
                    else
                        -- Find a name that has not been used.
                        local is_name_usable
                        for i = 1, max_popup_message, 1 do
                            usable_name = alerterEditor.gui_names.received_message_popup_inner_frame_prefix .. i
                            is_name_usable = true
                            for _, used_name in pairs(children_names) do
                                if usable_name == used_name then
                                    is_name_usable = false
                                    break
                                end
                            end
                            if is_name_usable then
                                break
                            end
                        end
                    end
                    
                    -- Inner message frame.
                    message_table.add({type = "frame", name = usable_name, direction = "vertical"})
                    local inner_frame = message_table[usable_name]
                    inner_frame.style.minimal_width = 400
                    inner_frame.style.maximal_width = inner_frame.style.minimal_width
                    
                    -- Message label.
                    inner_frame.add({type = "label", name = alerterEditor.gui_names.received_message_popup_label, caption = alerter.expandedmsg})
                    local label = inner_frame[alerterEditor.gui_names.received_message_popup_label]
                    label.style.font_color = alerter.color
                    
                    -- OK button container.
                    inner_frame.add({type = "flow", name = alerterEditor.gui_names.received_message_popup_button_container, direction = "horizontal"})
                    local button_container = inner_frame[alerterEditor.gui_names.received_message_popup_button_container]
                    -- Left space.
                    button_container.add({type = "flow", name = alerterEditor.gui_names.received_message_popup_button_space, direction = "horizontal"})
                    local button_space = button_container[alerterEditor.gui_names.received_message_popup_button_space]
                    button_space.style.minimal_width = inner_frame.style.minimal_width - 80 - 8 * 4
                    button_space.style.maximal_width = button_space.style.minimal_width
                    -- Button.
                    button_container.add({type = "button", name = alerterEditor.gui_names.received_message_popup_button, caption = {"gui.ok"}})
                    local button = button_container[alerterEditor.gui_names.received_message_popup_button]
                    button.style.minimal_width = 80
                    button.style.maximal_width = button.style.minimal_width
                end
            end
        end
    --end
end

return circuitAlerter
