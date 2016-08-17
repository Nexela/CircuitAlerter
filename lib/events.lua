-- luacheck: globals script global game

--Generate Table of events
--Portions of this code graciously liberated from Smart Trains and Custom Events Mods with modifications by aubergine10
local events = {}
events.on_player_opened = script.generate_event_name()
events.on_player_closed = script.generate_event_name()

--[[ on_init - Setup the global tables ]]--
function events.init()
end

function events.closed( player, type, entity )
	game.raise_event( events.on_player_closed,
		{ player_index = player.index, type = type, entity = entity }
	)
end

function events.opened( player, type, entity )
	game.raise_event( events.on_player_opened,
		{ player_index = player.index, type = type, entity = entity }
	)
end

function events.raiseEvents(event)


	--[[Open and Close Events]]
	if event.tick % 30 == 0 then -- check twice per second

		for _, player in pairs( game.players ) do -- iterate players...

			if player.connected then

				local was, now = global.playerData[player.index], player

				-- check if something closed...
				if was.opened_self and not now.opened_self then -- closed self
					events.closed( player, 'self', player )
				elseif was.opened and ( not now.opened or not now.opened.valid ) then -- closed entity
					events.closed( player, 'entity', was.opened )
				end

				-- Note: Should get 2 events...
				-- if something was open (closed event),
				-- but now something else is open (open event),
				-- ...hence no else/elseif at this point.

				-- check if something opened...
				if not was.opened_self and now.opened_self then -- opened self
					events.opened( player, 'self', player )
				elseif ( not was.opened ) and now.opened and now.opened.valid then -- opened entity
					events.opened( player, 'entity', now.opened )
				end

				-- remember current state
				-- quicker to just assign vals rather than recalc what changed
				was.opened      = now.opened and now.opened.valid and now.opened -- or (now.opened_self and now.valid and player)--> intentional
				was.opened_self = now.opened_self

			end--if player.connected

		end--for player

	end--if event.tick

end

return events
