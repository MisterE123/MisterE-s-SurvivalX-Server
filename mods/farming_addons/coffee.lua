-- COFFEE
farming.register_plant("farming_addons:coffee", {
	description = "Coffee Seed",
	paramtype2 = "meshoptions",
	inventory_image = "farming_addons_coffee_seed.png",
	steps = 5,
	minlight = 13,
	maxlight = default.LIGHT_MAX,
	fertility = {"grassland"},
	groups = {flammable = 4},
	place_param2 = 3,
})

-- cold cup of coffee
minetest.register_node("farming_addons:coffee_cup", {
	description = "Cold Cup of Coffee",
	drawtype = "plantlike",
	tiles = {"farming_addons_coffee_cup.png"},
	inventory_image = "farming_addons_coffee_cup.png",
	wield_image = "farming_addons_coffee_cup.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.25, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	on_use = minetest.item_eat(4, "vessels:drinking_glass"),
	sounds = default.node_sound_glass_defaults(),
})

-- hot cup of coffee
minetest.register_node("farming_addons:coffee_cup_hot", {
	description = "Hot Cup of Coffee",
	drawtype = "plantlike",
	tiles = {"farming_addons_coffee_cup_hot.png"},
	inventory_image = "farming_addons_coffee_cup_hot.png",
	wield_image = "farming_addons_coffee_cup_hot.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.25, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	on_use = minetest.item_eat(6, "vessels:drinking_glass"),
	sounds = default.node_sound_glass_defaults(),
})
