local minlight = 13
local maxlight = default.LIGHT_MAX

-- beetroot
farming.register_plant("farming_addons:beetroot", {
	description = "Beetroot Seed",
	paramtype2 = "meshoptions",
	inventory_image = "farming_addons_beetroot_seed.png",
	steps = 8,
	minlight = minlight,
	maxlight = maxlight,
	fertility = {"grassland"},
	groups = {flammable = 4},
	place_param2 = 3,
	on_use = minetest.item_eat(3),
})

-- needed
minetest.override_item("farming_addons:beetroot", {
	on_use = minetest.item_eat(3),
})
