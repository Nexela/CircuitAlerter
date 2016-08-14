local entity = {}

function entity.get_output_inventory() -- → LuaInventory   Gets the entities output inventory if it has one.
function entity.get_module_inventory() -- → LuaInventory   
function entity.damage(damage, force, type) -- → float Damages the entity.
function entity.destroy() -- → boolean Destroys the entity.
function entity.set_command(command) --    Give the entity a command.
function entity.has_command() -- → boolean Has this unit been assigned a command?
function entity.die() --   Immediately kills the entity.
function entity.has_flag(flag) -- → boolean    Test whether this entity's prototype has a flag set.
function entity.add_market_item({price=, offer=}) --   Offer a thing on the market.
function entity.remove_market_item(offer) -- → boolean Remove an offer from a market.
function entity.get_market_items() -- → array of Offer Get all offers in a market as an array.
function entity.connect_neighbour(target) --   Connect two devices with wire or cable.
function entity.disconnect_neighbour(target) --    Disconnect wires or cables.
function entity.order_deconstruction(force) -- → boolean   Sets the entity to be deconstructed by construction robots.
function entity.cancel_deconstruction(force) --    Cancels deconstruction if it is scheduled, does nothing otherwise.
function entity.to_be_deconstructed(force) -- → boolean    Is this entity marked for deconstruction?
function entity.get_request_slot(slot) -- → SimpleItemStack    Get a logistic requester slot.
function entity.set_request_slot(request, slot) -- Set a logistic requester slot.
function entity.clear_request_slot(slot) --    Clear a logistic requester slot.
function entity.is_crafting() -- → boolean 
function entity.is_opened() -- → boolean   
function entity.is_opening() -- → boolean  
function entity.is_closed() -- → boolean   
function entity.is_closing() -- → boolean  
function entity.request_to_open(force, extra_time) --  
function entity.request_to_close(force) -- 
function entity.get_transport_line(index) -- → LuaTransportLine    Get a transport line of a belt.
function entity.launch_rocket() -- → boolean   
function entity.revive() -- → uint Revive a ghost.
function entity.get_connected_rail({rail_direction=, rail_connection_direction=}) -- → LuaEntity   
function entity.get_filter(uint) -- → string   Get the filter for a slot.
function entity.set_filter(uint, string) --    Set the filter for a slot.
function entity.get_control_behavior() -- → LuaControlBehavior Gets the control behavior of the entity (if any) --.
function entity.get_or_create_control_behavior() -- → LuaControlBehavior   Gets (and or creates if needed) -- the control behavior of the entity.
function entity.get_circuit_network(wire, circuit_connector) -- → LuaCircuitNetwork    
function entity.supports_backer_name() -- → boolean    
function entity.copy_settings(entity) -- → dictionary string → uint    Copies settings from the given entity onto this entity.
function entity.get_inventory(inventory) -- → LuaInventory Get an inventory belonging to this entity.
function entity.get_quickbar() -- → LuaInventory   Get the quickbar belonging to this entity if any.
function entity.can_insert(items) -- → boolean Can at least some items be inserted?
function entity.insert(items) -- → uint    Insert items into this entity.
function entity.get_item_count(item) -- → uint Get the number of all or some items in this entity.
function entity.has_items_inside() -- → boolean    Does this entity have any item inside it?
function entity.clear_items_inside() --    Remove all items from this entity.
function entity.remove_item(items) -- → uint   Remove items from this entity.
function entity.teleport(position, surface) -- → boolean   Teleport the entity to a given position, possibly on another surface.
function entity.passenger ()-- LuaEntity [RW] Setting to nil forces the character out of the vehicle, setting to a new character forces any existing passenger out and the given character becomes the new passenger.
function entity.name ()-- string [R]  Name of the entity prototype.
function entity.ghost_name ()-- string [R]    Name of the entity contained in this ghost
function entity.localised_name ()-- LocalisedString [R]   Localised name of the entity.
function entity.ghost_localised_name ()-- LocalisedString [R] Localised name of the entity contained in this ghost.
function entity.type ()-- string [R]  The entity prototype type of this entity.
function entity.ghost_type ()-- string [R]    The prototype type of the entity contained in this ghost.
function entity.active ()-- boolean [RW]  Deactivating an entity will stop all its operations (car will stop moving, inserters will stop working, fish will stop moving etc) --.
function entity.destructible ()-- boolean [RW]    When the entity is not destructible it can't be damaged.
function entity.minable ()-- boolean [RW] 
function entity.rotatable ()-- boolean [RW]   When entity is not to be rotatable (inserter, transport belt etc) --, it can't be rotated by player using the R key.
function entity.operable ()-- boolean [RW]    Player can't open gui of this entity and he can't quick insert/input stuff in to the entity when it is not operable.
function entity.health ()-- float [RW]    Health of the entity.
function entity.direction ()-- defines.direction [RW] The current direction this entity is facing.
function entity.orientation ()-- float [RW]   The smooth orientation.
function entity.amount ()-- uint [RW] Count of resource units contained.
function entity.effectivity_modifier ()-- float [RW]  Multiplies the acceleration the vehicle can create for one unit of energy.
function entity.consumption_modifier ()-- float [RW]  Multiplies the the energy consumption.
function entity.friction_modifier ()-- float [RW] Multiplies the car friction rate.
function entity.speed ()-- float [RW] The current speed of the car.
function entity.stack ()-- LuaItemStack [R]   
function entity.prototype ()-- LuaEntityPrototype [R] The entity prototype of this entity.
function entity.ghost_prototype ()-- LuaEntityPrototype [R]   The entity prototype of the entity contained in this ghost.
function entity.drop_position ()-- Position [RW]  Position where the entity puts its stuff.
function entity.pickup_position ()-- Position [RW]    Where the inserter will pick up items from.
function entity.drop_target ()-- LuaEntity [R]    The entity this entity is putting its stuff to or nil if there is no such entity.
function entity.pickup_target ()-- LuaEntity [R]  The entity the inserter will attempt to pick up from.
function entity.selected_gun_index ()-- uint [RW] Index of the currently selected weapon slot of this character.
function entity.energy ()-- double [RW]   Energy stored in the entity (heat in furnace, energy stored in electrical devices etc.
function entity.recipe ()-- LuaRecipe [RW]    Current recipe being assembled by this machine.
function entity.held_stack ()-- LuaItemStack [R]  The item stack currently held in an inserter's hand.
function entity.held_stack_position ()-- Position [R] Current position of the inserter's "hand".
function entity.train ()-- LuaTrain [R]   The train this rolling stock belongs to.
function entity.neighbours ()-- dictionary string → array of LuaEntity or array of LuaEntity or LuaEntity [R] 
function entity.fluidbox ()-- LuaFluidBox [RW]    
function entity.backer_name ()-- string [RW]  The name of a backer (of Factorio) -- assigned to a lab or train station / stop.
function entity.time_to_live ()-- uint [RW]   The ticks left for a ghost entity before it's destroyed.
function entity.color ()-- Color [RW] The character or rolling stock color.
function entity.signal_state ()-- defines.signal_state [R]    The state of this rail signal.
function entity.chain_signal_state ()-- uint [R]  The state of this chain signal.
function entity.to_be_looted ()-- boolean [RW]    Will this entity be picked up automatically when the player walks over it?
function entity.crafting_progress ()-- float [RW] The current crafting progress, as a number in range [0, 1].
function entity.bonus_progress ()-- float [RW]    The current productivity bonus progress, as a number in range [0, 1].
function entity.belt_to_ground_type ()-- string [R]   "input" or "output", depending on whether this underground belt goes down or up.
function entity.rocket_parts ()-- uint [RW]   Number of rocket parts in the silo.
function entity.logistic_network ()-- LuaLogisticNetwork [R]  The logistic network this entity is a part of.
function entity.logistic_cell ()-- LuaLogisticCell [R]    The logistic cell this entity is a part of.
function entity.item_requests ()-- dictionary string → uint [RW]  Items this ghost will request when revived.
function entity.player ()-- LuaPlayer [R] The player connected to this character.
function entity.unit_group ()-- LuaUnitGroup [R]  The unit group this unit is a member of, or nil if none.
function entity.damage_dealt ()-- double [RW] The damage dealt by this turret.
function entity.kills ()-- uint [RW]  The number of units killed by this turret.
function entity.built_by ()-- LuaPlayer [RW]  The player who built the entity
function entity.electric_buffer_size ()-- double [RW] The buffer size for the electric energy source or nil if the entity doesn't have an electric energy source.
function entity.electric_input_flow_limit ()-- double [RW]    The input flow limit for the electric energy source or nil if the entity doesn't have an electric energy source.
function entity.electric_output_flow_limit ()-- double [RW]   The output flow limit for the electric energy source or nil if the entity doesn't have an electric energy source.
function entity.electric_drain ()-- double [RW]   The electric drain for the electric energy source or nil if the entity doesn't have an electric energy source.
function entity.electric_emissions ()-- double [RW]   The emissions size for the electric energy source or nil if the entity doesn't have an electric energy source.
function entity.unit_number ()-- uint [R] The unit number or nil if the entity doesn't have one.
function entity.mining_progress ()-- double [RW]  The mining progress for this mining drill or nil if this isn't a mining drill.
function entity.bonus_mining_progress ()-- double [RW]    The bonus mining progress for this mining drill or nil if this isn't a mining drill.
function entity.power_production ()-- double [RW] The power production specific to the ElectricEnergyInterface entity type.
function entity.power_usage ()-- double [RW]  The power usage specific to the ElectricEnergyInterface entity type.
function entity.bounding_box ()-- BoundingBox [R] 
function entity.mining_target ()-- LuaEntity [R]  The mining target or nil if none
function entity.circuit_connected_entities () --[R]  Entities connected to this entity via the circuit network.
function entity.circuit_connection_definitions ()-- array of CircuitConnectionDefinition [R]  The connection definition for entities connected to this entity via the circuit network.
function entity.request_slot_count ()-- uint [R]  The number of request slots this entity has.
function entity.force ()-- string or LuaForce [RW]    The force of this entity.
function entity.surface ()-- LuaSurface [R]   The surface this entity is currently on.
function entity.position ()-- Position [R]    Current position of the entity.
function entity.riding_state () -- [RW]   Current riding state of this car or the vehicle this player is riding in.
function entity.auto_trash_filters ()-- dictionary string → uint [RW] The auto-trash filters.
function entity.valid ()-- boolean [R]    Is this object valid?

return entity