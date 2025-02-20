-- spawn snow golem
-- local function pumpkin_on_construct(pos)
-- 	if not minetest.get_modpath("mobs_npc") then return end

-- 	for i = 1,2 do
-- 		if minetest.get_node({x=pos.x,y=pos.y-i,z=pos.z}).name ~= "default:snowblock" then
-- 			return
-- 		end
-- 	end

-- 	--if 3 snow block are placed, this will make snow golem
-- 	for i = 0,2 do
-- 		minetest.remove_node({x=pos.x,y=pos.y-i,z=pos.z})
-- 	end

-- 	minetest.add_entity({x=pos.x,y=pos.y-1,z=pos.z}, "mobs_npc:snow_golem")
-- end

-- PUMPKIN
farming.register_plant("farming_addons:pumpkin", {
	description = "Pumpkin Seed",
	inventory_image = "farming_addons_pumpkin_seed.png",
	steps = 8,
	minlight = MINLIGHT,
	maxlight = MAXLIGHT,
	fertility = {"grassland", "desert"},
	groups = {flammable = 4},
	place_param2 = 3,
})

-- PUMPKIN FRUIT - HARVEST
minetest.register_node("farming_addons:pumpkin_fruit", {
	description = "Pumpkin Fruit",
	tiles = {"farming_addons_pumpkin_fruit_top.png", "farming_addons_pumpkin_fruit_top.png", "farming_addons_pumpkin_fruit_side.png", "farming_addons_pumpkin_fruit_side.png", "farming_addons_pumpkin_fruit_side.png", "farming_addons_pumpkin_fruit_side_off.png"},
	paramtype2 = "facedir",
	sounds = default.node_sound_wood_defaults(),
	is_ground_content = false,
	groups = {snappy=3, flammable=4, fall_damage_add_percent=-30},
	drop = {
		max_items = 4,  -- Maximum number of items to drop.
		items = { -- Choose max_items randomly from this list.
			{
				items = {"farming_addons:pumpkin"},  -- Items to drop.
				rarity = 1,  -- Probability of dropping is 1 / rarity.
			},
			{
				items = {"farming_addons:pumpkin"},  -- Items to drop.
				rarity = 2,  -- Probability of dropping is 1 / rarity.
			}
		},
	},
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		local parent = oldmetadata.fields.parent
		local parent_pos_from_child = minetest.string_to_pos(parent)
		local parent_node = nil

		-- make sure we have position
		if parent_pos_from_child
			and parent_pos_from_child ~= nil then

			parent_node = minetest.get_node(parent_pos_from_child)
		end

		-- tick parent if parent stem still exists
		if parent_node
			and parent_node ~= nil
			and parent_node.name == "farming_addons:pumpkin_8" then

			farming_addons.tick(parent_pos_from_child)
		end
	end
})

-- PUMPKIN BLOCK - HARVEST from crops
minetest.register_node("farming_addons:pumpkin_block", {
	description = "Pumpkin Block",
	tiles = {"farming_addons_pumpkin_fruit_top.png", "farming_addons_pumpkin_fruit_top.png", "farming_addons_pumpkin_fruit_side.png", "farming_addons_pumpkin_fruit_side.png", "farming_addons_pumpkin_fruit_side.png", "farming_addons_pumpkin_fruit_side_off.png"},
	paramtype2 = "facedir",
	sounds = default.node_sound_wood_defaults(),
	is_ground_content = false,
	groups = {snappy=3, flammable=4, fall_damage_add_percent=-30},
	-- on_construct = pumpkin_on_construct
})

-- PUMPKIN LANTERN -- from recipe
minetest.register_node("farming_addons:pumpkin_lantern", {
	description = "Pumpkin Lantern",
	tiles = {"farming_addons_pumpkin_fruit_top.png", "farming_addons_pumpkin_fruit_top.png", "farming_addons_pumpkin_fruit_side.png", "farming_addons_pumpkin_fruit_side.png", "farming_addons_pumpkin_fruit_side.png", "farming_addons_pumpkin_fruit_side_on.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	sounds = default.node_sound_wood_defaults(),
	is_ground_content = false,
	light_source = 12,
	drop = "farming_addons:pumpkin_lantern",
	groups = {snappy=3, flammable=4, fall_damage_add_percent=-30},
	-- on_construct = pumpkin_on_construct
})

-- drop blocks instead of items
minetest.register_alias_force("farming_addons:pumpkin", "farming_addons:pumpkin_block")

-- take over the growth from minetest_game farming from here
minetest.override_item("farming_addons:pumpkin_8", {
	next_plant = "farming_addons:pumpkin_fruit",
	on_timer = farming_addons.grow_block
})

-- replacement LBM for pre-nodetimer plants
minetest.register_lbm({
	name = "farming_addons:start_nodetimer_pumpkin",
	nodenames = {"farming_addons:pumpkin_8"},
	action = function(pos, node)
		farming_addons.tick_short(pos)
	end,
})
