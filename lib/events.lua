--Generate Table of events
--Portions of this code graciously liberated from Smart Trains and Custom Events Mods
local events = {}
events["on_player_opened"] = script.generate_event_name()
events["on_player_closed"] = script.generate_event_name()

--[[ on_init - Setup the global tables ]]--
function events.init()
end

function events.raiseEvents(event)

	if event.tick % 10 == 0 then -- Every 10 ticks...
		for _, player in pairs(game.players) do -- For every player in the game...
			if player.connected then -- If the player is connected...
				if player.opened ~= nil and player.opened.valid and global.playerData[player.index].opened ~= player.opened.name then -- If a player has opened an entity but the global data says otherwise...
				
					game.raise_event(events["on_player_opened"], {player_index = player.index, entity_name = player.opened.name}) -- Raise the "on_entity_opened" event
					global.playerData[player.index].opened = player.opened.name -- Update the global data
					
				elseif player.opened_self and global.playerData[player.index].opened ~= "opened_self" then -- ... Or if the player has opened himself/herself but the global data says oterwise...
				
					game.raise_event(events["on_player_opened"], {player_index = player.index, entity_name = "opened_self"}) -- Raise the "on_entity_opened" event
					global.playerData[player.index].opened = "opened_self" -- Update the global data
										
				elseif not player.opened_self and global.playerData[player.index].opened == "opened_self" then -- ... Or if the player hasn't opened himself/herself but the global data says otherwise...
				
					game.raise_event(events["on_player_closed"], {player_index = player.index, entity_name = global.playerData[player.index].opened}) -- Raise the "on_entity_closed" event
					global.playerData[player.index].opened = nil -- Update the global data
					
				elseif player.opened == nil and global.playerData[player.index].opened ~= nil and global.playerData[player.index].opened ~= "opened_self" then -- ... Or if the player hasn't opened an entity but the global data says otherwise...
				
					game.raise_event(events["on_player_closed"], {player_index = player.index, entity_name = global.playerData[player.index].opened}) -- Raise the "on_entity_closed" event
					global.playerData[player.index].opened = nil -- Update the global data
					
				end
			end
			
		end
	end
	
end

return events
