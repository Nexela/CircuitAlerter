-- Mooncat's message GUI
local default_gui = data.raw["gui-style"].default
local function extract_monolith(ff, xx, yy, ww, hh)
    return
    {
        type = "monolith",
        top_monolith_border = 0,
        right_monolith_border = 0,
        bottom_monolith_border = 0,
        left_monolith_border = 0,
        monolith_image =
        {
            filename = "__CircuitAlerter__/graphics/" .. ff,
            priority = "extra-high-no-scale",
            width = ww,
            height = hh,
            x = xx,
            y = yy,
        },
    }
end

default_gui.small_message_hint_panel_button_style =
{
    type = "button_style",
    parent = "button_style",
    scalable = false,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    width = 20,
    height = 20,
    default_graphical_set = extract_monolith("message-hint-panel.png", 0, 0, 20, 20),
    hovered_graphical_set = extract_monolith("message-hint-panel.png", 20, 0, 20, 20),
    clicked_graphical_set = extract_monolith("message-hint-panel.png", 40, 0, 20, 20),
}

default_gui.apply_and_reload_button_style =
{
    type = "button_style",
    parent = "button_style",
    --scalable = false,
    top_padding = 0,
    right_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    width = 100,
    height = 20,
    minimal_width = 100,
    minimal_height = 32,
    maximal_width = 100,
    maximal_height = 32,

}


--Yarm style expando for messages and viewing alerts

local empty_animation = {
    filename = "__CircuitAlerter__/graphics/null.png",
    priority = "medium",
    width = 0,
    height = 0,
    direction_count = 18,
    frame_count = 1,
    animation_speed = 0,
    shift = {0,0},
    axially_symmetrical = false,
}

local empty_anim_level = {
    idle = empty_animation,
    idle_mask = empty_animation,
    idle_with_gun = empty_animation,
    idle_with_gun_mask = empty_animation,
    mining_with_hands = empty_animation,
    mining_with_hands_mask = empty_animation,
    mining_with_tool = empty_animation,
    mining_with_tool_mask = empty_animation,
    running_with_gun = empty_animation,
    running_with_gun_mask = empty_animation,
    running = empty_animation,
    running_mask = empty_animation,
}

local fake_player = table.deepcopy(data.raw.player.player)
fake_player.name = "cs-remote-viewer"
--fake_player.crafting_categories = {}
--fake_player.mining_categories = {}
fake_player.max_health=0
fake_player.inventory_size = 0
fake_player.build_distance = 0
fake_player.drop_item_distance = 0
fake_player.reach_distance = 0
fake_player.reach_resource_distance = 0
fake_player.mining_speed = 0
fake_player.running_speed = 0
fake_player.distance_per_frame = 0
fake_player.animations = {
    level1 = empty_anim_level,
    level2addon = empty_anim_level,
    level3addon = empty_anim_level,
}
fake_player.light = {{ intensity=0, size=0 }}
fake_player.flags = {"placeable-off-grid", "not-on-map", "not-repairable"}
fake_player.collision_mask = {"ground-tile"}

data:extend({ fake_player })



local red_label = {
    type = "label_style",
    parent = "label_style",
    font_color = {r=1, g=0.2, b=0.2}
}
default_gui.CS_err_label = red_label


local function button_graphics(xpos, ypos)
    return {
        type = "monolith",

        top_monolith_border = 0,
        right_monolith_border = 0,
        bottom_monolith_border = 0,
        left_monolith_border = 0,

        monolith_image = {
            filename = "__CircuitAlerter__/graphics/gui.png",
            priority = "extra-high-no-scale",
            width = 16,
            height = 16,
            x = xpos,
            y = ypos,
        },
    }
end

default_gui.CS_button_with_icon = {
    type = "button_style",
    parent = "slot_button_style",

    scalable = true,

    top_padding = 1,
    right_padding = 1,
    bottom_padding = 1,
    left_padding = 1,

    width = 17,
    height = 17,

    default_graphical_set = button_graphics( 0,  0),
    hovered_graphical_set = button_graphics(16,  0),
    clicked_graphical_set = button_graphics(32,  0),
}


default_gui.CS_expando_short = {
    type = "button_style",
    parent = "CS_button_with_icon",

    default_graphical_set = button_graphics( 0, 16),
    hovered_graphical_set = button_graphics(16, 16),
    clicked_graphical_set = button_graphics(32, 16),
}

default_gui.CS_expando_long = {
    type = "button_style",
    parent = "CS_button_with_icon",

    default_graphical_set = button_graphics( 0, 32),
    hovered_graphical_set = button_graphics(16, 32),
    clicked_graphical_set = button_graphics(32, 32),
}

default_gui.CS_settings = {
    type = "button_style",
    parent = "CS_button_with_icon",

    default_graphical_set = button_graphics( 0, 48),
    hovered_graphical_set = button_graphics(16, 48),
    clicked_graphical_set = button_graphics(32, 48),
}

default_gui.CS_overlay_site = {
    type = "button_style",
    parent = "CS_button_with_icon",

    default_graphical_set = button_graphics( 0, 64),
    hovered_graphical_set = button_graphics(16, 64),
    clicked_graphical_set = button_graphics(32, 64),
}

default_gui.CS_goto_site = {
    type = "button_style",
    parent = "CS_button_with_icon",

    default_graphical_set = button_graphics( 0, 80),
    hovered_graphical_set = button_graphics(16, 80),
    clicked_graphical_set = button_graphics(32, 80),
}

default_gui.CS_delete_site = {
    type = "button_style",
    parent = "CS_button_with_icon",

    default_graphical_set = button_graphics( 0, 96),
    hovered_graphical_set = button_graphics(16, 96),
    clicked_graphical_set = button_graphics(32, 96),
}

default_gui.CS_rename_site = {
    type = "button_style",
    parent = "CS_button_with_icon",

    default_graphical_set = button_graphics( 0, 112),
    hovered_graphical_set = button_graphics(16, 112),
    clicked_graphical_set = button_graphics(32, 112),
}

default_gui.CS_delete_site_confirm = {
    type = "button_style",
    parent = "CS_button_with_icon",

    default_graphical_set = button_graphics( 0, 128),
    hovered_graphical_set = button_graphics(16, 128),
    clicked_graphical_set = button_graphics(32, 128),
}

default_gui.CS_goto_site_cancel = {
    type = "button_style",
    parent = "CS_button_with_icon",

    default_graphical_set = button_graphics( 0, 144),
    hovered_graphical_set = button_graphics(16, 144),
    clicked_graphical_set = button_graphics(32, 144),
}

default_gui.CS_rename_site_cancel = {
    type = "button_style",
    parent = "CS_button_with_icon",

    default_graphical_set = button_graphics( 0, 160),
    hovered_graphical_set = button_graphics(16, 160),
    clicked_graphical_set = button_graphics(32, 160),
}

default_gui.CS_site_table = {
    type = "table_style",
    horizontal_spacing = 3,
    vertical_spacing = 1,
}

default_gui.CS_buttons = {
    type = "flow_style",
    parent = "description_flow_style",
    horizontal_spacing = 1,
    vertical_spacing = 5,
    top_padding = 4,
}
