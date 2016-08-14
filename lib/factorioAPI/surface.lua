local surface = {}
function surface.get_pollution(position) -- → double    Get the pollution for a given position.
function surface.can_place_entity({name=, position=, direction=, force=}) -- → boolean    Check for collisions with terrain or other entities.
function surface.find_entity(entity, position) -- → LuaEntity   Find a specific entity at a specific position.
function surface.find_entities(area) -- → array of LuaEntity    Find entities in a given area.
function surface.find_entities_filtered({area=, position=, name=, type=, force=, limit=}) -- → array of LuaEntity   Find entities of given type or name in a given area.
function surface.count_entities_filtered({area=, position=, name=, type=, force=, limit=}) -- → uint    Count entities of given type or name in a given area.
function surface.find_non_colliding_position(name, center, radius, precision) -- → Position Find a non-colliding possition within a given rectangle.
function surface.spill_item_stack(position, items) --   Spill items on the ground centered at a given location.
function surface.find_enemy_units(center, radius, force) -- → array of LuaEntity    Find units enemy of a given force within an area.
function surface.find_nearest_enemy({position=, max_distance=, force=}) -- → LuaEntity Find the enemy closest to the given position.
function surface.set_multi_command({command=, unit_count=, force=, unit_search_distance=}) -- → uint  Give a command to multiple units.
function surface.create_entity({name=, position=, direction=, force=, target=, source=, fast_replace=, player=, spill=}) -- → LuaEntity  Create an entity on this surface.
function surface.create_unit_group({position=, force=}) -- → LuaUnitGroup   Create a new unit group at a given position.
function surface.build_enemy_base(position, unit_count, force) --   Send a group to build a new base.
function surface.get_tile(x, y) -- → LuaTile    Get the tile at a given position.
function surface.get_tileproperties(x, y) -- → TileProperties   Get tile properties.
function surface.set_tiles(tiles, correct_tiles) -- Set tiles at specified locations.
function surface.pollute(source, amount) -- Spawn pollution at the given position.
function surface.get_chunks() -- → LuaChunkIterator Get an iterator going over every chunk on this surface.
function surface.is_chunk_generated(position) -- → boolean  Is a given chunk generated?
function surface.request_to_generate_chunks(position, radius) --    Request that the game's map generator generate chunks at the given position for the given radius on this surface.
function surface.find_logistic_network_by_position(position, force) -- → LuaLogisticNetwork Find the logistic network that covers a given position.
function surface.freeze_daytime(freeze) --  Freeze or unfreeze time of day at the current value.
function surface.deconstruct_area({area=, force=}) --   Place a deconstruction request.
function surface.cancel_deconstruct_area({area=, force=}) --    Cancel a deconstruction order.
function surface.name () -- string [R]  The name of this surface.
function surface.index () -- uint [R]   Unique ID associated with this surface.
function surface.map_gen_settings () -- MapGenSettings [R]  Gets the generation settings for the surface.
function surface.always_day () -- boolean [RW]  When set to true, the sun will always shine.
function surface.daytime () -- float [RW]   Current time of day, as a number in range [0, 1) --.
function surface.darkness () -- float [R]   Amount of darkness at the current time.
function surface.wind_speed () -- float [RW]    Current wind speed.
function surface.wind_orientation () -- float [RW]  Current wind direction.
function surface.wind_orientation_change () -- float [RW]   Change in wind orientation per tick.
function surface.peaceful_mode () -- boolean [RW]   Is peaceful mode enabled on this surface?
function surface.valid () -- boolean [R]    Is this object valid?

return surface