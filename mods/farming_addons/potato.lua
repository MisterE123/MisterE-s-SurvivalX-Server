local minlight = 13
local maxlight = default.LIGHT_MAX

-- POTATO
farming.register_plant("farming_addons:potato", {
	description = "Planting Potato",
	paramtype2 = "meshoptions",
	inventory_image = "farming_addons_potato_seed.png",
	steps = 8,
	minlight = minlight,
	maxlight = maxlight,
	fertility = {"grassland"},
	groups = {flammable = 4},
	place_param2 = 3,
	on_use = minetest.item_eat(2),
})

-- needed
minetest.override_item("farming_addons:potato", {
	on_use = minetest.item_eat(2),
})

-- add poisonous potato to drops
minetest.override_item("farming_addons:potato_8", {
	drop = {
		items = {
			{items = {"farming_addons:potato"}, rarity = 1},
			{items = {"farming_addons:potato"}, rarity = 2},
			{items = {"farming_addons:poisonouspotato"}, rarity = 5},
			{items = {"farming_addons:seed_potato"}, rarity = 1},
			{items = {"farming_addons:seed_potato"}, rarity = 2},
		}
	}
})
