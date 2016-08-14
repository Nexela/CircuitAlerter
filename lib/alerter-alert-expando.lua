--require "util"
--require "libs/array_pair"

local csgui = {
    on_click = {},
}

function csgui.init_player(player)
    --csgui.init_force(player.force)
    --if not global.playerData then newPlayerInit(player) end
    local playerData = global.playerData[player.index]
    if not playerData then playerData = {} end
    if playerData.expandoed == nil then playerData.expandoed = false end
    if not playerData.overlays then playerData.overlays = {} end
    global.playerData[player.index] = playerData
end


function csgui.update_ui(player)
    local playerData = global.playerData[player.index]
    local forceData = global.forceData[player.force.name]

    local root = player.gui.left.CS_root
    if not root then
        root = player.gui.left.add{type="frame",
                                   name="CS_root",
                                   direction="horizontal",
                                   style="outer_frame_style"}

        local buttons = root.add{type="flow",
                                 name="buttons",
                                 direction="vertical",
                                 style="CS_buttons"}

        buttons.add{type="button", name="CS_expando", style="CS_expando_short"}
    end

    if root.sites and root.sites.valid then
        root.sites.destroy()
    end
    
    local sites_gui = root.add{type="table", colspan=7, name="sites", style="CS_site_table"}

    if forceData and forceData.ore_sites then
        for site in ascending_by_ratio(forceData.ore_sites) do
            if not playerData.expandoed then -- and (site.remaining_permille / 10) > playerData.warn_percent then
                break
            end

            if site.deleting_since and site.deleting_since + 600 < game.tick then
                site.deleting_since = nil
            end

            local color = csgui.site_color(site, player)
            local el

            el = sites_gui.add{type="label", name="CS_label_site_"..site.name,
                               caption=site.name}
            el.style.font_color = color

            el = sites_gui.add{type="label", name="CS_label_percent_"..site.name,
                               caption=string.format("%.1f%%", site.remaining_permille / 10)}
            el.style.font_color = color

            el = sites_gui.add{type="label", name="CS_label_amount_"..site.name,
                               caption=format_number(site.amount)}
            el.style.font_color = color

            el = sites_gui.add{type="label", name="CS_label_ore_name_"..site.name,
                               caption=site.ore_name}
            el.style.font_color = color

            el = sites_gui.add{type="label", name="CS_label_ore_per_minute_"..site.name,
                               caption={"CS-ore-per-minute", site.ore_per_minute}}
            el.style.font_color = color

            el = sites_gui.add{type="label", name="CS_label_etd_"..site.name,
                               caption={"CS-time-to-deplete", csgui.time_to_deplete(site)}}
            el.style.font_color = color


            local site_buttons = sites_gui.add{type="flow", name="CS_site_buttons_"..site.name,
                                               direction="horizontal", style="CS_buttons"}

            if site.deleting_since then
                site_buttons.add{type="button",
                                 name="CS_delete_site_"..site.name,
                                 style="CS_delete_site_confirm"}
            elseif playerData.viewing_site == site.name then
                site_buttons.add{type="button",
                                 name="CS_goto_site_"..site.name,
                                 style="CS_goto_site_cancel"}
                if playerData.renaming_site == site.name then
                    site_buttons.add{type="button",
                                    name="CS_rename_site_"..site.name,
                                    style="CS_rename_site_cancel"}
                else
                    site_buttons.add{type="button",
                                    name="CS_rename_site_"..site.name,
                                    style="CS_rename_site"}
                end
            else
                site_buttons.add{type="button",
                                 name="CS_goto_site_"..site.name,
                                 style="CS_goto_site"}
                site_buttons.add{type="button",
                                 name="CS_delete_site_"..site.name,
                                 style="CS_delete_site"}
            end
        end
    end
end




function csgui.on_click.goto_site(event)
    local site_name = string.sub(event.element.name, 1 + string.len("CS_goto_site_"))

    local player = game.players[event.player_index]
    local playerData = global.playerData[event.player_index]
    local forceData = global.forceData[player.force.name]
    local site = forceData.ore_sites[site_name]

    -- Don't bodyswap too often, Factorio hates it when you do that.
    if playerData.last_bodyswap and playerData.last_bodyswap + 10 > event.tick then return end
    playerData.last_bodyswap = event.tick

    if playerData.viewing_site == site_name then
        -- returning to our home body
        if playerData.real_character == nil or not playerData.real_character.valid then
            player.print({"CS-warn-no-return-possible"})
            return
        end

        player.character = playerData.real_character
        playerData.remote_viewer.destroy()

        playerData.real_character = nil
        playerData.remote_viewer = nil
        playerData.viewing_site = nil
    else
        -- stepping out to a remote viewer: first, be sure you remember your old body
        if not playerData.real_character or not playerData.real_character.valid then
            -- Abort if the "real" character is missing (e.g., god mode) or isn't a player!
            -- NB: this might happen if you use something like The Fat Controller or Command Control
            -- and you do NOT want to get stuck not being able to return from those
            if not player.character or player.character.name ~= "player" then
                player.print({"CS-warn-not-in-real-body"})
                return
            end

            playerData.real_character = player.character
        end
        playerData.viewing_site = site_name

        -- make us a viewer and put us in it
        local viewer = player.surface.create_entity{name="CS-remote-viewer", position=site.center, force=player.force}
        player.character = viewer

        -- don't leave an old one behind
        if playerData.remote_viewer then
            playerData.remote_viewer.destroy()
        end
        playerData.remote_viewer = viewer
    end

    for _, p in pairs(player.force.players) do
        csgui.update_ui(p)
    end
end


function csgui.on_gui_click(event)
    if csgui.on_click[event.element.name] then
        csgui.on_click[event.element.name](event)
    elseif string.starts_with(event.element.name, "CS_delete_site_") then
        csgui.on_click.remove_site(event)
    elseif string.starts_with(event.element.name, "CS_rename_site_") then
        csgui.on_click.rename_site(event)
    elseif string.starts_with(event.element.name, "CS_goto_site_") then
        csgui.on_click.goto_site(event)
    end
end


function csgui.on_click.CS_expando(event)
    local player = game.players[event.player_index]
    local playerData = global.playerData[event.player_index]

    playerData.expandoed = not playerData.expandoed

    if playerData.expandoed then
        player.gui.left.CS_root.buttons.CS_expando.style = "CS_expando_long"
    else
        player.gui.left.CS_root.buttons.CS_expando.style = "CS_expando_short"
    end

    csgui.update_ui(player)
end


function csgui.update_players(event)
    for index, player in pairs(game.players) do
        local playerData = global.playerData[index]

        if not playerData then
            csgui.init_player(index)
        --elseif not player.connected and playerData.current_site then
        --    csgui.clear_current_site(index)
        end

        --if event.tick % playerData.gui_update_ticks == 15 + index then
            csgui.update_ui(player)
        --end
    end
end


function csgui.update_forces(event)
    local update_cycle = event.tick % csgui.ticks_between_checks
    for _, force in pairs(game.forces) do
        local forceData = global.forceData[force.name]

        if not forceData then
            csgui.init_force(force)
        elseif forceData and forceData.ore_sites then
            for _, site in pairs(forceData.ore_sites) do
                csgui.count_deposits(site, update_cycle)
            end
        end
    end
end

function csgui.on_tick(event)
    csgui.update_players(event)
    --csgui.update_forces(event)
end

return csgui