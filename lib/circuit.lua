require("lib.utils")
local circuit = {}

function circuit.fulfilled(entity)
        
    if entity.get_control_behavior() and entity.get_control_behavior().circuit_condition and entity.get_control_behavior().circuit_condition.fulfilled then
        return true
    else --not fulfilled
        return false
    end
end

function circuit.getConditions(entity)
    local behavior = entity.get_control_behavior()
    if behavior == nil then return nil, nil, nil, nil, nil end
    local red = behavior.get_circuit_network(defines.wire_type.red)
    local green = behavior.get_circuit_network(defines.wire_type.green)

    local condition = behavior.circuit_condition
    if condition == nil then return nil, nil, nil, nil, nil end

    --if not condition.fulfilled then return nil, nil, nil end
    local a = condition.condition.first_signal.name
    local b = condition.condition.constant or condition.condition.second_signal.name
    local c = condition.condition.comparator

    local a1 = circuit.getSignalValues(condition.condition.first_signal, red, green)
    local b2 = condition.condition.second_signal

    if b2 then
        b2 = circuit.getSignalValues(b2, red, green)
    else
        b2 = condition.condition.constant
    end


    return a, a1, b, b2, c
end

function circuit.getCircuitNetworkItems(entity, signalname)
    local red = entity.get_circuit_network(defines.wire_type.red)
    local green = entity.get_circuit_network(defines.wire_type.green)
    local signal = red.signals[signalname] or green.signals[signalname]
    if signal then return circuit.getSignalValues(signal, red, green) end
    return 0

end

function circuit.getSignalValues(signal, red, green)
    if not signal or type(signal) ~= "table" or not signal.name then return 0 end
    local count = 0
    --if type(signal) = "string" then signal =
    if red and red.get_signal(signal) then count = count + red.get_signal(signal) end
    if green and green.get_signal(signal) then count = count + green.get_signal(signal) end
    return count
end


return circuit