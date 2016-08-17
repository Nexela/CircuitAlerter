local remoteAlerts ={
    name="remoteAlerts",
    class="remote"
}

function remoteAlerts.isValidAlert(tbl)
    if type(tbl) ~= "table" then return false, {"remote-alerts.not-a-table"} end



end

--[[
tbl = {
uniqueID = internal:number
name = string: name of the alert
force = force or string: name of force
alertto = 1, 2 = force, all
distance = 1, 2, 3 = close, surface, all
method = 1, 2, 3 = console, flying, popup
sound = sound -- TBD
mapmark = bool : place a mark on the map
position = {position table of alert in either array or x=,y= format}


}
--]]




return remoteAlerts