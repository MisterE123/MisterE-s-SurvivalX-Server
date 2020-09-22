screwdriver = screwdriver or {}

--
-- Stone
--

minetest.register_node("x_default:magmacobble", {
	description = "Magma Cobblestone",
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
	tiles = {
		{
			name = "x_default_magmacobble_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	special_tiles = {
		-- New-style lava source material (mostly unused)
		{
			name = "x_default_magmacobble_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
			backface_culling = false,
		},
	},
	-- paramtype = "light",
	light_source = 3,
})

minetest.register_node("x_default:lapisblock", {
	description = "Lapis Block",
	tiles ={"x_default_lapis_block.png"},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node( "x_default:lapisbrick", {
	description = "Lapis Brick",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {
		"x_default_lapis_brick_top.png",
		"x_default_lapis_brick_top.png^[transformFXR90",
		"x_default_lapis_brick_side.png",
		"x_default_lapis_brick_side.png^[transformFX",
		"x_default_lapis_brick.png^[transformFX",
		"x_default_lapis_brick.png"
	},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node( "x_default:lapiscobble",  {
	description = "Lapis Cobblestone",
	is_ground_content = false,
	tiles = {
		"x_default_lapiscobble.png",
		"x_default_lapiscobble.png^[transformFY",
		"x_default_lapiscobble.png^[transformFX",
		"x_default_lapiscobble.png",
		"x_default_lapiscobble.png^[transformFX",
		"x_default_lapiscobble.png"
	},
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node( "x_default:lapis_tile",  {
	description = "Lapis Tile",
	is_ground_content = false,
	tiles = {"x_default_lapis_tile.png"},
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node( "x_default:lapis_gold_tile",  {
	description = "Lapis Gold Tile",
	is_ground_content = true,
	tiles = {"x_default_lapis_gold_tile.png"},
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults()
})

minetest.register_node( "x_default:lapis_gold_brick",  {
	description = "Lapis Gold Brick",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {
		"x_default_lapis_gold_brick_top.png",
		"x_default_lapis_gold_brick_top.png^[transformFXR90",
		"x_default_lapis_gold_brick_side.png",
		"x_default_lapis_gold_brick_side.png^[transformFX",
		"x_default_lapis_gold_brick.png^[transformFX",
		"x_default_lapis_gold_brick.png"
	},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node( "x_default:lapis_gold_block",  {
	description = "Lapis Gold Block",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {
		"x_default_lapis_gold_block_top.png",
		"x_default_lapis_gold_block_top.png",
		"x_default_lapis_gold_block.png"
	},
	is_ground_content = false,
	groups = {cracky = 2, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("x_default:lapis_gold_obsidian", {
	description = "Lapis Gold Obsidian",
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {
		"x_default_lapis_gold_obsidian_front.png",
		"x_default_lapis_gold_obsidian_front.png",
		"x_default_lapis_gold_obsidian_side.png^[transformFX",
		"x_default_lapis_gold_obsidian_side.png^[transformFYR90",
		"x_default_lapis_gold_obsidian_side.png^[transformFY",
		"x_default_lapis_gold_obsidian_side.png"
	},
	is_ground_content = false,
	groups = {cracky = 2, level = 2},
	sounds = default.node_sound_stone_defaults(),
	on_rotate = screwdriver.rotate_simple
})

--
-- Soft / Non-Stone
--

minetest.register_node("x_default:snowcobble", {
	description = "Snow Cobble",
	tiles = {"x_default_snowcobble.png"},
	groups = {puts_out_fire = 1, cools_lava = 1, snowy = 1, cracky = 2, stone = 1},
	sounds = default.node_sound_snow_defaults(),
	is_ground_content = false,

	on_construct = function(pos)
		pos.y = pos.y - 1
		if minetest.get_node(pos).name == "default:dirt_with_grass" then
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
		end
	end,
})

minetest.register_node("x_default:icecobble", {
	description = "Ice Cobble",
	tiles = {"x_default_icecobble.png"},
	groups = {cracky = 2, puts_out_fire = 1, cools_lava = 1, slippery = 3},
	sounds = default.node_sound_glass_defaults(),
	is_ground_content = false,
})

--
-- Ores
--

minetest.register_node("x_default:stone_with_lapis", {
	description = "Lapis Ore",
	tiles = {"default_stone.png^x_default_mineral_lapis.png"},
	groups = {cracky = 2},
	drop = 'x_default:lapis_lump',
	sounds = default.node_sound_stone_defaults(),
})

--
-- Christmas Tree
--

minetest.register_node("x_default:christmas_tree_sapling", {
	description = "Christmas Tree Sapling",
	drawtype = "plantlike",
	tiles = { "x_default_christmas_tree_sapling.png" },
	inventory_image = "x_default_christmas_tree_sapling.png",
	wield_image = "x_default_christmas_tree_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = x_default.grow_sapling,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 3,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"x_default:christmas_tree_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 14, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})

-- Decorated Pine Leaves
minetest.register_node("x_default:christmas_tree_needles", {
	description ="Decorated Pine Needles",
	drawtype = "allfaces_optional",
	tiles = {
		{
			-- Animated, "blinking lights" version. ~ LazyJ
			name = "x_default_pine_needles_decorated_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 20.0
			},
		}
	},
	waving = 0,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
	light_source = 5,
})

-- Star
minetest.register_node("x_default:christmas_tree_star", {
	description ="Christmas Tree Star",
	tiles = {"x_default_christmas_tree_star.png"},
	inventory_image = "x_default_christmas_tree_star.png",
	wield_image = "x_default_christmas_tree_star.png",
	drawtype = "plantlike",
	paramtype2 = 0,
	paramtype = "light",
	walkable = false,
	groups = {cracky=1, crumbly=1, choppy=1, oddly_breakable_by_hand=1, not_in_creative_inventory=1},
	sounds = default.node_sound_glass_defaults(),
	light_source = 5,
})

default.register_leafdecay({
	trunks = {"default:pine_tree"},
	leaves = {"x_default:christmas_tree_needles"},
	radius = 2,
})