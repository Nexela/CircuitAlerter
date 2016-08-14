local force = {}

function force.get_entity_count(name) end-- → uint   Count entities of given type.
function force.disable_research() end --  Disable research for this force.
function force.enable_research() end --   Enable research for this force.
function force.disable_all_prototypes() end --    Disable all recipes and technologies.
function force.reset_recipes() end -- Load the original version of all recipes from the prototypes.
function force.enable_all_recipes() end --    Unlock all recipes.
function force.enable_all_technologies() end --   Unlock all technologies.
function force.research_all_technologies() end -- Research all technologies.
function force.reset_technologies() end --    Load the original versions of technologies from prototypes.
function force.reset() end -- Reset everything.
function force.chart(surface, area) end--    Chart a portion of the map.
function force.clear_chart() end --   Remove all charted area from the chart.
function force.rechart() end --   Force a rechart of the whole chart.
function force.chart_all() end -- Chart all generated chunks.
function force.is_chunk_charted(surface, position) end-- → boolean   Has a chunk been charted?
function force.get_ammo_damage_modifier(ammo) end-- → double 
function force.set_ammo_damage_modifier(ammo, modifier) end--    
function force.get_gun_speed_modifier(ammo) end-- → double   
function force.set_gun_speed_modifier(ammo, modifier) end--  
function force.get_turret_attack_modifier(turret) end -- → double 
function force.set_turret_attack_modifier(turret, modifier) end--    
function force.set_cease_fire(other, cease_fire) end--   Stop attacking members of a given force.
function force.get_cease_fire(other) end-- → boolean Will this force attack members of another force?
function force.is_pathfinder_busy() end -- → boolean  Is pathfinder busy?
function force.kill_all_units() end --    Kill all units and flush the pathfinder.
function force.find_logistic_network_by_position(position, surface) end-- → LuaLogisticNetwork   
function force.set_spawn_position(position, surface) end --   
function force.get_spawn_position(surface) end-- → Position  
function force.name () end -- string [R]  Name of the force.
function force.technologies () end -- custom dictionary string → LuaTechnology [R]    Technologies owned by this force, indexed by their name.
function force.recipes () end -- custom dictionary string → LuaRecipe [R] Recipes available to this force, indexed by their name.
function force.manual_mining_speed_modifier () end -- double [RW] Multiplier of the manual mining speed.
function force.manual_crafting_speed_modifier () end -- double [RW]   Multiplier of the manual crafting speed.
function force.laboratory_speed_modifier () end -- double [RW]    
function force.worker_robots_speed_modifier () end -- double [RW] 
function force.worker_robots_storage_bonus () end -- double [RW]  
function force.current_research () end -- LuaTechnology or string [RW]    The current research in progress.
function force.research_progress () end -- double [RW]    Progress of current research, as a number in range [0, 1].
function force.inserter_stack_size_bonus () end -- double [RW]    The inserter stack size bonus for non stack inserters
function force.stack_inserter_capacity_bonus () end -- uint [RW]  Number of items that can be transferred by stack inserters
function force.character_logistic_slot_count () end -- double [RW]    Number of character logistic slots.
function force.character_trash_slot_count () end -- double [RW]   Number of character trash slots.
function force.quickbar_count () end -- uint [RW] Number of character quick bars.
function force.maximum_following_robot_count () end -- uint [RW]  Maximum number of follower robots.
function force.ghost_time_to_live () end -- uint [RW] The time, in ticks, before a placed ghost disappears.
function force.players () end -- array of LuaPlayer [R]   Players belonging to this force.
function force.ai_controllable () end -- boolean [RW] Enables some higher-level AI behaviour for this force.
function force.logistic_networks () end -- dictionary string → array of LuaLogisticNetwork [R]    List of logistic networks, grouped by surface.
function force.item_production_statistics () end -- LuaFlowStatistics [R] The item production statistics for this force.
function force.fluid_production_statistics () end -- LuaFlowStatistics [R]    The fluid production statistics for this force.
function force.kill_count_statistics () end -- LuaFlowStatistics [R]  The kill counter statistics for this force.
function force.item_resource_statistics () end-- LuaFlowStatistics [R]   The item resource statistics for this force (item resources collected) () end --.
function force.fluid_resource_statistics () end-- LuaFlowStatistics [R]  The fluid resource statistics for this force (fluid resources collected) () end --.
function force.entity_build_count_statistics () end -- LuaFlowStatistics [R]  The entity build statistics for this force (built and mined) () end --
function force.character_running_speed_modifier () end -- uint [RW]   
function force.character_build_distance_bonus () end -- uint [RW] 
function force.character_item_drop_distance_bonus () end -- uint [RW] 
function force.character_reach_distance_bonus () end -- uint [RW] 
function force.character_resource_reach_distance_bonus () end -- double [RW]  
function force.character_item_pickup_distance_bonus () end -- double [RW] 
function force.character_loot_pickup_distance_bonus () end -- double [RW] 
function force.character_inventory_slots_bonus () end -- uint [RW]    the number of additional inventory slots the character main inventory has.
function force.deconstruction_time_to_live () end -- uint [RW]    The time, in ticks, before a deconstruction order is removed.
function force.character_health_bonus () end -- float [RW]    
function force.auto_character_trash_slots () end -- boolean [RW]  true if auto character trash slots are enabled.
function force.valid () end -- boolean [R]

return force