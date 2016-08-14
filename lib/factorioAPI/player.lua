function player.set_ending_screen_data(message, file) --   Setup the screen to be shown when the game is finished.
function player.print(message) --  Print text to the chat console.
function player.clear_console() -- Clear the chat console.
function player.get_goal_description() -- → LocalisedString    Get the current goal description, as a localised string.
function player.set_goal_description(text, only_update) -- Set the text in the goal window (top left) --.
function player.set_controller({type=, character=}) -- Set the controller type of the player.
function player.build_from_cursor() -- → boolean   Build the entity in the player's cursor (hand) --.
function player.rotate_for_build() -- → boolean    Rotate the entity in cursor before building.
function player.disable_recipe_groups() -- Disable recipe groups.
function player.print_entity_statistics(entities) --   Print entity statistics to the player's console.
function player.unlock_achievement(name) --    Unlock the achievements of the given player.
function player.clean_cursor() --  Invokes the "clean cursor" action on the player as if the user pressed it.
function player.get_inventory(inventory) -- → LuaInventory Get an inventory belonging to this entity.
function player.get_quickbar() -- → LuaInventory   Get the quickbar belonging to this entity if any.
function player.can_insert(items) -- → boolean Can at least some items be inserted?
function player.insert(items) -- → uint    Insert items into this entity.
function player.set_gui_arrow({type=}) --   Create an arrow which points at this entity.
function player.clear_gui_arrow() --   Removes the arrow created by set_gui_arrow.
function player.get_item_count(item) -- → uint Get the number of all or some items in this entity.
function player.has_items_inside() -- → boolean    Does this entity have any item inside it?
function player.can_reach_entity(entity) -- → boolean  Can a given entity be opened or accessed?
function player.clear_items_inside() --    Remove all items from this entity.
function player.remove_item(items) -- → uint   Remove items from this entity.
function player.teleport(position, surface) -- → boolean   Teleport the entity to a given position, possibly on another surface.
function player.update_selected_entity(position) --    Select an entity, as if by hovering the mouse above it.
function player.clear_selected_entity() -- Unselect any selected entity.
function player.disable_flashlight() --    Disable the flashlight.
function player.enable_flashlight() -- Enable the flashlight.
function player.get_craftable_count(recipe) -- → uint  Gets the count of the given recipe that can be crafted.
function player.begin_crafting({count=, recipe=, silent=}) -- → uint  Begins crafting the given count of the given recipe
function player.cancel_crafting(options) --    Cancels crafting the given count of the given crafting queue index
function player.character ()-- LuaEntity [RW] The character attached to this player, or nil if no character.
function player.index ()-- uint [R]   This player's index in LuaGameScript()--players.
function player.force ()-- string or LuaForce [RW]    The force of this player.
function player.gui ()-- LuaGui [R]   
function player.opened_self ()-- boolean [R]  true if the player opened itself.
function player.controller_type ()-- defines.controllers [R]  
function player.game_view_settings ()-- GameViewSettings [RW] The player's game view settings.
function player.minimap_enabled ()-- boolean [RW] true if the minimap is visible.
function player.color ()-- Color [RW] The colour associated with the player.
function player.name ()-- string [RW] The player's username.
function player.connected ()-- boolean [R]    true if the player is currently connected to the game.
function player.admin ()-- boolean [R]    true if the player is an admin.
function player.entity_copy_source ()-- LuaEntity [R] The source entity used during entity settings copy-paste if any.
function player.cursor_position ()-- Position [W] Position of the player's mouse cursor.
function player.zoom ()-- double [W]  The player's zoom-level.
function player.surface ()-- LuaSurface [R]   The surface this entity is currently on.
function player.position ()-- Position [R]    Current position of the entity.
function player.vehicle ()-- LuaEntity [R]    The vehicle the player is currently sitting in; nil if none.
function player.selected ()-- LuaEntity [R]   The currently selected entity; nil if none.
function player.opened ()-- LuaEntity [R] The entity whose GUI the player currently has open; nil if none.
function player.crafting_queue_size ()-- uint [R] Size of the crafting queue.
function player.walking_state ()--[RW]  Current walking state.
function player.riding_state ()--[RW]   Current riding state of this car or the vehicle this player is riding in.
function player.mining_state ()--[RW]   Current mining state.
function player.cursor_stack ()-- LuaItemStack [R]    The player's cursor stack.
function player.driving ()-- boolean [RW] true if the player is in a vehicle.
function player.crafting_queue ()-- array of CraftingQueueItem [R]    Gets the current crafting queue items.
function player.cheat_mode ()-- boolean [RW]  When true hand crafting is free and instant
function player.character_crafting_speed_modifier ()-- double [RW]    
function player.character_mining_speed_modifier ()-- double [RW]  
function player.character_running_speed_modifier ()-- double [RW] 
function player.character_build_distance_bonus ()-- uint [RW] 
function player.character_item_drop_distance_bonus ()-- uint [RW] 
function player.character_reach_distance_bonus ()-- uint [RW] 
function player.character_resource_reach_distance_bonus ()-- uint [RW]    
function player.character_item_pickup_distance_bonus ()-- uint [RW]   
function player.character_loot_pickup_distance_bonus ()-- uint [RW]   
function player.quickbar_count_bonus ()-- uint [RW]   
function player.character_inventory_slots_bonus ()-- uint [RW]    
function player.character_logistic_slot_count_bonus ()-- uint [RW]    
function player.character_trash_slot_count_bonus ()-- uint [RW]   
function player.character_maximum_following_robot_count_bonus ()-- uint [RW]  
function player.character_health_bonus ()-- float [RW]    
function player.auto_trash_filters ()-- dictionary string → uint [RW] The auto-trash filters.
function player.valid ()-- boolean [R]    Is this object valid?