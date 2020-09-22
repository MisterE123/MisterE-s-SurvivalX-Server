minetest.register_craft({
	output = "x_default:snowcobble 9",
	recipe = {
		{"default:snowblock", "default:snowblock", "default:snowblock"},
		{"default:snowblock", "default:snowblock", "default:snowblock"},
		{"default:snowblock", "default:snowblock", "default:snowblock"},
	}
})

minetest.register_craft({
	output = "x_default:icecobble 9",
	recipe = {
		{"default:ice", "default:ice", "default:ice"},
		{"default:ice", "default:ice", "default:ice"},
		{"default:ice", "default:ice", "default:ice"},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "x_default:lapis_ingot",
	recipe = "x_default:lapis_lump",
})

minetest.register_craft({
	output = "x_default:lapisblock",
	recipe = {
		{"x_default:lapis_ingot", "x_default:lapis_ingot", "x_default:lapis_ingot"},
		{"x_default:lapis_ingot", "x_default:lapis_ingot", "x_default:lapis_ingot"},
		{"x_default:lapis_ingot", "x_default:lapis_ingot", "x_default:lapis_ingot"},
	}
})

minetest.register_craft({
	output = "x_default:lapis_ingot 9",
	recipe = {
		{"x_default:lapisblock"},
	}
})

minetest.register_craft({
	output = "x_default:lapisbrick 4",
	recipe = {
		{"x_default:lapisblock", "x_default:lapisblock"},
		{"x_default:lapisblock", "x_default:lapisblock"},
	}
})

minetest.register_craft({
	output = "x_default:lapiscobble 9",
	recipe = {
		{"x_default:lapisblock", "x_default:lapisblock", "x_default:lapisblock"},
		{"x_default:lapisblock", "x_default:lapisblock", "x_default:lapisblock"},
		{"x_default:lapisblock", "x_default:lapisblock", "x_default:lapisblock"},
	}
})

minetest.register_craft({
	output = "x_default:lapis_tile 4",
	recipe = {
		{"x_default:lapisbrick", "x_default:lapisbrick"},
		{"x_default:lapisbrick", "x_default:lapisbrick"},
	}
})

minetest.register_craft({
	output = "x_default:lapis_gold_tile 9",
	recipe = {
		{"x_default:lapis_gold_block", "x_default:lapis_gold_block", "x_default:lapis_gold_block"},
		{"x_default:lapis_gold_block", "x_default:lapis_gold_block", "x_default:lapis_gold_block"},
		{"x_default:lapis_gold_block", "x_default:lapis_gold_block", "x_default:lapis_gold_block"},
	}
})

minetest.register_craft({
	output = "x_default:lapis_gold_brick 4",
	recipe = {
		{"x_default:lapis_gold_block", "x_default:lapis_gold_block"},
		{"x_default:lapis_gold_block", "x_default:lapis_gold_block"},
	}
})

minetest.register_craft({
	output = "x_default:lapis_gold_block",
	recipe = {
		{"x_default:lapis_ingot", "default:gold_lump", "x_default:lapis_ingot"},
		{"default:gold_lump", "x_default:lapis_ingot", "default:gold_lump"},
		{"x_default:lapis_ingot", "default:gold_lump", "x_default:lapis_ingot"},
	}
})

minetest.register_craft({
	output = "dye:blue",
	recipe = {
		{"x_default:lapis_lump"},
	}
})

minetest.register_craft({
	output = "x_default:lapis_gold_obsidian 2",
	recipe = {
		{"x_default:lapis_gold_block", "default:obsidian"},
		{"default:obsidian", "x_default:lapis_gold_block"},
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "default:bronze_ingot",
	recipe = {"default:steel_ingot", "default:copper_ingot"},
})

minetest.register_craft({
	output = "x_default:christmas_tree_sapling",
	recipe = {
		{"default:goldblock", "default:meselamp", "default:goldblock"},
		{"wool:green", "default:pine_sapling", "wool:blue"},
		{"wool:yellow", "default:pine_sapling", "wool:red"}
	}
})
