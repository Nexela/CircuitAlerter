local game = {}

function game.get_event_handler(event) --    Find the event handler for an event.
function game.raise_event(event, table) --   Raise an event.
function game.set_game_state({game_finished=, player_won=, next_level=, can_continue=}) -- Set scenario state.
function game.get_entity_by_tag(tag) -- → LuaEntity  
function game.show_message_dialog({text=, image=, point_to=})  --  Show an in-game message dialog.
function game.disable_tips_and_tricks() --   Disable showing tips and tricks.
function game.is_demo() -- → boolean Is this the demo version of Factorio?
function game.save(name) --  Save scenario progress.
function game.load(name) --  Load scenario progress.
function game.reload_script() -- Forces a reload of the scenario script when the save game without the migration is loaded.
function game.save_atlas() --    Saves the current configuration of Atlas to a file.
function game.check_consistency() -- Run internal consistency checks.
function game.regenerate_entity(entitites) --    Regenerate autoplacement of some entities.
function game.take_screenshot({player=, by_player=, position=, resolution=, zoom=, path=, show_gui=, show_entity_info=, anti_alias=}) -- Take a screenshot and save it to a file.
function game.write_file(filename, data, append) --  Write a string to a file.
function game.remove_path(path) --   Remove file or directory.
function game.remove_offline_players(players) -- Remove players who are currently not connected from the map.
function game.force_crc() -- Force a CRC check.
function game.create_force(force) -- → LuaForce  Create a new force.
function game.merge_forces(source, destination) --   Merge two forces together.
function game.create_surface(name, settings) --  Create a new surface
function game.server_save(name) --   Instruct the server to save the map.
function game.delete_surface(surface) -- Deletes the given surface and all entities on it.
function game.disable_replay() --    Disables replay saving for the current save file.
function game.direction_to_string(direction) --  Converts the given direction into the string version of the direction.
function game.player ()-- LuaPlayer [R] The player typing at the console - nil in all other instances.
function game.players ()-- custom dictionary uint or string → LuaPlayer [R] 
function game.evolution_factor ()-- float [RW]  Evolution factor of enemies.
function game.map_settings ()-- MapSettings [R] 
function game.difficulty ()-- defines.difficulty [R]    Current scenario difficulty.
function game.forces ()-- custom dictionary string → LuaForce [R]   
function game.entity_prototypes ()-- custom dictionary string → LuaEntityPrototype [R]  
function game.item_prototypes ()-- custom dictionary string → LuaItemPrototype [R]  
function game.fluid_prototypes ()-- custom dictionary string → LuaFluidPrototype [R]    
function game.tile_prototypes ()-- custom dictionary string → LuaTilePrototype [R]  
function game.equipment_prototypes ()-- custom dictionary string → LuaEquipmentPrototype [R]    
function game.tick ()-- uint [R]    Current map tick.
function game.finished ()-- boolean [R] Is the scenario finished?
function game.speed ()-- float [RW] Speed to update the map at.
function game.surfaces ()-- custom dictionary string → LuaSurface [R]   
function game.active_mods ()-- dictionary string → string [R]   The active mods versions.

return game