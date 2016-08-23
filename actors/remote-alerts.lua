--local circuitAlerter=require("actors.circuit-alerter-actor")
local remoteAlertSystem ={
    name="remoteAlertSystem",
    class="remote"
}

function remoteAlertSystem.isValidAlert(tbl)
    if type(tbl) ~= "table" then return false end
    if not tbl.name and type(tbl.name) ~= "string" then return false end
    return true
end

--Create or replace existing named alert.
function remoteAlertSystem.createRemoteAlert(tbl)
    if not remoteAlertSystem.isValidAlert(tbl) then return false end
    tbl.message = tbl.message or ""
    tbl.alertto = tbl.alertto or 2
    tbl.distance = tbl.distance or 3
    tbl.method = tbl.method or 1
    tbl.sound = tbl.sound or false
    tbl.usemapmark = tbl.usemapmark or false
    tbl.position = tbl.position or {x=0, y=0}
    for i, alert in pairs(global.remoteAlerts) do
        if tbl.name == alert.name then
            table.remove(global.remoteAlerts, i)
            table.insert(global.remoteAlerts)
            return {"remote-alerts.remote-alert-replaced"}
        end
    end
    table.insert(global.remoteAlerts)
    return {"remote-alerts.remote-alert-added"}
end

function remoteAlertSystem.removeRemoteAlert(name)
    for i, alert in pairs(global.remoteAlerts) do
        if name == alert.name then
            table.remove(global.remoteAlerts, i)
            return true
        end
    end
    return false -- no alert found
end

--[[
tbl = {
name = string: name of the alert -- must be unique?
force = force or string: name of force
alertto = 1, 2 = force, all
distance = 1, 2, 3 = close, surface, all
method = 1, 2, 3 = console, flying, popup
sound = sound -- TBD
mapmark = bool : place a mark on the map
position = {position table of alert in either array or x=,y= format}
}
--]]

return remoteAlertSystem