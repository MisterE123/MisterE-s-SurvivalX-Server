--
-- Crafting recipes & items
--

-- Cocoa
minetest.register_craft( {
	output = "dye:brown",
	recipe = {
		{ "farming_addons:cocoa_bean" },
	}
})

minetest.register_craftitem("farming_addons:cookie", {
	description = "Cookie",
	inventory_image = "farming_addons_cookie.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft( {
	output = "farming_addons:cookie 8",
	recipe = {
		{"farming:wheat", "farming_addons:cocoa_bean", "farming:wheat" },
	}
})

minetest.register_craftitem("farming_addons:chocolate", {
	description = "Chocolate",
	inventory_image = "farming_addons_chocolate.png",
	on_use = minetest.item_eat(3),
})

minetest.register_craft( {
	output = "farming_addons:chocolate",
	recipe = {
		{"", "", "farming_addons:cocoa_bean"},
		{"", "farming_addons:cocoa_bean", ""},
		{"default:paper", "", ""},
	}
})

-- Soup Bowl
minetest.register_craftitem("farming_addons:bowl", {
	description = "Empty Soup Bowl",
	inventory_image = "farming_addons_bowl.png",
})

minetest.register_craft({
	output = "farming_addons:bowl 3",
	recipe = {
		{"group:wood", "", "group:wood"},
		{"", "group:wood", ""}
	}
})

-- Hog Stew
minetest.register_craftitem("farming_addons:hog_stew", {
	description = "Hog Stew",
	inventory_image = "farming_addons_hog_stew.png",
	on_use = minetest.item_eat(8, "farming_addons:bowl"),
})

minetest.register_craft({
	output = "farming_addons:hog_stew",
	recipe = {
		{"", "mobs:pork_raw", ""},
		{"farming_addons:carrot", "farming_addons:bakedpotato", "flowers:mushroom_brown"},
		{"", "farming_addons:bowl", ""}
	}
})

minetest.register_craft({
	output = "farming_addons:hog_stew",
	recipe = {
		{"", "mobs:pork_raw", ""},
		{"farming_addons:carrot", "farming_addons:bakedpotato", "flowers:mushroom_red"},
		{"", "farming_addons:bowl", ""}
	}
})

-- Beetroot
minetest.register_craftitem("farming_addons:beetroot_soup", {
	description = "Beetroot Soup",
	inventory_image = "farming_addons_beetroot_soup.png",
	on_use = minetest.item_eat(6, "farming_addons:bowl"),
})

minetest.register_craft({
	output = "farming_addons:beetroot_soup",
	recipe = {
		{"farming_addons:beetroot", "farming_addons:beetroot", "farming_addons:beetroot"},
		{"farming_addons:beetroot", "farming_addons:beetroot", "farming_addons:beetroot"},
		{"", "farming_addons:bowl", ""}
	}
})

-- Carrot
minetest.register_craftitem("farming_addons:carrot_golden", {
	description = "Golden Carrot",
	inventory_image = "farming_addons_carrot_golden.png",
	wield_image = "farming_addons_carrot_golden.png^[transformR270",
	on_use = minetest.item_eat(10),
})

minetest.register_craft({
	output = "farming_addons:carrot_golden",
	recipe = {
		{"default:gold_lump", "default:gold_lump", "default:gold_lump"},
		{"default:gold_lump", "farming_addons:carrot", "default:gold_lump"},
		{"default:gold_lump", "default:gold_lump", "default:gold_lump"}
	},
})

-- Coffee
minetest.register_craft( {
	output = "farming_addons:coffee_cup",
	recipe = {
		{"vessels:drinking_glass", "farming_addons:coffee","bucket:bucket_water"},
	},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 5,
	output = "farming_addons:coffee_cup_hot",
	recipe = "farming_addons:coffee_cup"
})

-- Corn
minetest.register_craftitem("farming_addons:corn_pop", {
	description = "Popped corn",
	inventory_image = "farming_addons_corn_pop.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craft( {
	type = "cooking",
	cooktime = 10,
	output = "farming_addons:corn_pop",
	recipe = "farming_addons:corn"
})

minetest.register_craft( {
	output = "farming_addons:corn_popcorn",
	recipe = {
		{"farming_addons:corn_pop", "farming_addons:corn_pop","farming_addons:corn_pop"},
		{"default:paper", "","default:paper"},
		{"default:paper", "default:paper","default:paper"},
	}
})

-- Melon
minetest.register_craftitem("farming_addons:golden_melon", {
	description = "Golden Melon - Restores Hearts",
	inventory_image = "farming_addons_golden_melon.png",
	wield_image = "farming_addons_golden_melon.png^[transformR90",
	on_use = minetest.item_eat(10),
})

minetest.register_craft({
	output = "farming_addons:golden_melon",
	recipe = {
		{"default:gold_lump", "default:gold_lump", "default:gold_lump"},
		{"default:gold_lump", "farming_addons:melon", "default:gold_lump"},
		{"default:gold_lump", "default:gold_lump", "default:gold_lump"}
	},
})

minetest.register_craft({
	output = "farming_addons:melon_block",
	recipe = {
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"},
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"},
		{"farming_addons:melon", "farming_addons:melon", "farming_addons:melon"}
	},
})

-- Obsidian Wart
minetest.register_craftitem("farming_addons:wart_brick", {
	description = "Wart Brick",
	inventory_image = "farming_addons_wart_brick.png",
})

minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "farming_addons:wart_brick",
	recipe = "farming_addons:obsidian_wart"
})

minetest.register_craft({
	output = "farming_addons:wart_block",
	recipe = {
		{"farming_addons:obsidian_wart", "farming_addons:obsidian_wart", "farming_addons:obsidian_wart"},
		{"farming_addons:obsidian_wart", "farming_addons:obsidian_wart", "farming_addons:obsidian_wart"},
		{"farming_addons:obsidian_wart", "farming_addons:obsidian_wart", "farming_addons:obsidian_wart"}
	}
})

minetest.register_craft({
	output = "farming_addons:wart_brick_block",
	recipe = {
		{"farming_addons:wart_brick", "farming_addons:wart_brick", ""},
		{"farming_addons:wart_brick", "farming_addons:wart_brick", ""}
	}
})

minetest.register_craft({
	output = "farming_addons:wart_red_brick_block",
	recipe = {
		{"farming_addons:obsidian_wart", "farming_addons:wart_brick", ""},
		{"farming_addons:wart_brick", "farming_addons:obsidian_wart", ""}
	},
})

minetest.register_craft({
	output = "farming_addons:wartrack 4",
	recipe = {
		{"farming_addons:wart_block", "farming_addons:wart_block", ""},
		{"farming_addons:wart_block", "farming_addons:wart_block", ""}
	},
})

-- Potato
minetest.register_craftitem("farming_addons:bakedpotato", {
	description = "Baked Potato",
	inventory_image = "farming_addons_potato_baked.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craftitem("farming_addons:poisonouspotato", {
	description = "Poisonous Potato",
	inventory_image = "farming_addons_potato_poisonous.png",
	on_use = minetest.item_eat(-5),
})

minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "farming_addons:bakedpotato",
	recipe = "farming_addons:potato"
})

-- Pumpkin
-- pumpkin lantern recipe
minetest.register_craft({
	output = "farming_addons:pumpkin_lantern",
	recipe = {
		{"", "", ""},
		{"", "farming_addons:pumpkin_block", ""},
		{"", "default:torch", ""}
	},
})

-- crafted item from recipe
minetest.register_craftitem("farming_addons:pumpkin_pie", {
	description = "Pumpkin Pie",
	inventory_image = "farming_addons_pumpkin_pie.png",
	on_use = minetest.item_eat(6),
})

-- pumpkin pie crafting recipe
minetest.register_craft({
	output = "farming_addons:pumpkin_pie",
	recipe = {
		{"", "", ""},
		{"farming_addons:pumpkin_block", "farming:flour", ""},
		{"", "mobs:egg", ""}
	}
})

-- pumpkin as fuel (better than cactus)
minetest.register_craft({
	type = "fuel",
	recipe = "farming_addons:pumpkin_block",
	burntime = 20,
})

minetest.register_craft({
	type = "fuel",
	recipe = "farming_addons:pumpkin_lantern",
	burntime = 20,
})
