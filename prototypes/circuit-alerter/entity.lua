local alerter = dupli_proto( "lamp", "small-lamp", "circuit-alerter", true)


local mapmark_anim =
{
  filename = "__CircuitTools__/graphics/null.png",
  priority = "high",
  width = 0,
  height = 0,
  frame_count = 1,
  shift = {0,0},
}

-- to put a label on the map.
local mapmark = dupli_proto("train-stop","train-stop","circuit-alerter-mapmark")
mapmark.collision_box = {{0,0}, {0,0}}
mapmark.selection_box = {{0,0}, {0,0}}
mapmark.drawing_box = {{0,0}, {0,0}}
mapmark.order = "y"
mapmark.selectable_in_game = false
mapmark.tile_width = 1
mapmark.tile_height = 1
mapmark.rail_overlay_animations =
{
  north = mapmark_anim,
  east = mapmark_anim,
  south = mapmark_anim,
  west = mapmark_anim,
}
mapmark.animations =
{
  north = mapmark_anim,
  east = mapmark_anim,
  south = mapmark_anim,
  west = mapmark_anim,
}
mapmark.top_animations =
{
  north = mapmark_anim,
  east = mapmark_anim,
  south = mapmark_anim,
  west = mapmark_anim,
}

data:extend({mapmark, alerter})