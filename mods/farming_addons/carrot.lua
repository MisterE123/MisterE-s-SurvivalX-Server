local minlight = 13
local maxlight = default.LIGHT_MAX

-- carrot
farming.register_plant("farming_addons:carrot", {
	description = "Planting Carrot",
	paramtype2 = "meshoptions",
	inventory_image = "farming_addons_carrot_seed.png",
	steps = 8,
	minlight = minlight,
	maxlight = maxlight,
	fertility = {"grassland"},
	groups = {flammable = 4},
	place_param2 = 3,
	on_use = minetest.item_eat(3),
})

-- needed
minetest.override_item("farming_addons:carrot", {
	on_use = minetest.item_eat(3),
})
