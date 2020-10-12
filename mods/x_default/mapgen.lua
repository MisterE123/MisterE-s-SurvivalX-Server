-- Lapis
-- high ores
--[[minetest.register_ore({
	ore_type       = "scatter",
	ore            = "x_default:stone_with_lapis",
	wherein        = "default:stone",
	clust_scarcity = 9 * 9 * 9,
	clust_num_ores = 12,
	clust_size     = 3,
	y_max          = 31000,
	y_min          = 1025,
})]]--



minetest.register_ore({
	ore_type       = "scatter",
	ore            = "x_default:stone_with_lapis",
	wherein        = "default:stone",
	clust_scarcity = 7 * 7 * 7,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = -7000,
	y_min          = -10000,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "x_default:stone_with_lapis",
	wherein        = "default:stone",
	clust_scarcity = 12 * 12 * 12,
	clust_num_ores = 29,
	clust_size     = 5,
	y_max          = -10000,
	y_min          = -33000,
})
