--luacheck: globals doDebug log
--All functions for the circuit alerter

require ("stdlib/extras/utils")
local Position = require ("stdlib/area/position")
local circuitPole = {
    name = "circuit-pole",
    class = "entity",
    ["small-circuit-pole"] = {range=7.5},
    ["medium-circuit-pole"] = {range=9},
}


-- TODO: A little gui for selecting which wires to place, gui only shows up when electric pole type item is in hand. there is a .12x mod that does this
function circuitPole:init()
    for _, force in ipairs (game.forces) do
        if force.technologies["circuit-network"].researched == true then
            force.recipe["small-circuit-pole"].enabled = true
            force.recipe["medium-circuit-pole"].enabled = true
        end
    end
end

function circuitPole:createEntity(entity, player_index)
    local pos = entity.position
    --local unitnum = entity.unit_number
    local area = Position.expand_to_area(pos, self[entity.name].range)
    entity.disconnect_neighbour()

    local nearby=entity.surface.find_entities_filtered {area=area,type="electric-pole", force=entity.force, limit=6}
    
    if nearby then
        for _ , pole in pairs(nearby) do
            if pole.position ~= entity.position then entity.connect_neighbour({wire=defines.wire_type.red, target_entity=pole}) end
        end
    end
end


--function circuitPole:destroyEntity(entity)
--end

return circuitPole