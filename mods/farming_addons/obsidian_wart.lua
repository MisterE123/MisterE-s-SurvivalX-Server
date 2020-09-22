local minlight = 0
local maxlight = default.LIGHT_MAX

-- OBSIDIAN WART
farming.register_plant("farming_addons:obsidian_wart", {
	description = "Obsidian Wart Seed",
	paramtype2 = "meshoptions",
	inventory_image = "farming_addons_obsidian_wart_seed.png",
	steps = 6,
	minlight = minlight,
	maxlight = maxlight,
	fertility = {"underground"},
	groups = {flammable = 4},
	place_param2 = 3
})

-- default obsidian
minetest.override_item("default:obsidian", {
	groups = {cracky = 1, level = 2, soil = 1, underground = 1},
	soil = {
		base = "default:obsidian",
		dry = "farming_addons:obsidian_soil",
		wet = "farming_addons:obsidian_soil_wet"
	}
})

-- obsidian - soil
minetest.register_node("farming_addons:obsidian_soil", {
	description = "Obsidian Soil",
	drop = "default:obsidian",
	tiles = {"farming_addons_obsidian_soil.png", "default_obsidian.png"},
	groups = {cracky = 1, level = 2, soil = 2, underground = 1, field = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_stone_defaults(),
	soil = {
		base = "default:obsidian",
		dry = "farming_addons:obsidian_soil",
		wet = "farming_addons:obsidian_soil_wet"
	}
})

-- obsidian - soil - wet
minetest.register_node("farming_addons:obsidian_soil_wet", {
	description = "Wet Obsidian Soil",
	drop = "default:obsidian",
	tiles = {"farming_addons_obsidian_soil_wet.png", "farming_addons_obsidian_soil_wet_side.png"},
	groups = {cracky = 1, level = 2, soil = 3, wet = 1, underground = 1, field = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_stone_defaults(),
	soil = {
		base = "default:obsidian",
		dry = "farming_addons:obsidian_soil",
		wet = "farming_addons:obsidian_soil_wet"
	}
})

--
-- Nodes
--
minetest.register_node("farming_addons:wart_block", {
	description = "Wart Block",
	tiles = {"farming_addons_wart_block.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("farming_addons:wartrack", {
	description = "Wartrack",
	tiles = {"farming_addons_wartrack.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("farming_addons:wart_brick_block", {
	description = "Wart Brick Block",
	tiles = {"farming_addons_wart_brick_block.png"},
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node("farming_addons:wart_red_brick_block", {
	description = "Wart Red Brick Block",
	tiles = {"farming_addons_wart_red_brick_block.png"},
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults()
})

--
-- Register Wart stairs and slabs
--
stairs.register_stair_and_slab(
	"wart_block",
	"farming_addons:wart_block",
	{cracky = 3},
	{"farming_addons_wart_block.png"},
	"Wart Block Stair",
	"Wart Block Slab",
	default.node_sound_stone_defaults()
)

stairs.register_stair_and_slab(
	"wart_brick_block",
	"farming_addons:wart_brick_block",
	{cracky = 2},
	{"farming_addons_wart_brick_block.png"},
	"Wart Brick Stair",
	"Wart Brick Slab",
	default.node_sound_stone_defaults()
)

stairs.register_stair_and_slab(
	"wart_red_brick_block",
	"farming_addons:wart_red_brick_block",
	{cracky = 2},
	{"farming_addons_wart_red_brick_block.png"},
	"Wart Red Brick Stair",
	"Wart Red Brick Slab",
	default.node_sound_stone_defaults()
)

stairs.register_stair_and_slab(
	"wartrack",
	"farming_addons:wartrack",
	{cracky = 3},
	{"farming_addons_wartrack.png"},
	"Wartrack Stair",
	"Wartrack Slab",
	default.node_sound_stone_defaults()
)
