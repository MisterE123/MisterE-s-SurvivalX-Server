-- extenders come in three strengths
for num, strength in ipairs(telemosaic.strengths) do
	minetest.register_node("telemosaic:extender_"..strength, {
		description = "Telemosaic extender, tier "..num..", extends beacon range by: "..telemosaic.extender_ranges["telemosaic:extender_"..strength].." blocks",
		tiles = { "telemosaic_extender_"..strength..".png" },
		paramtype = "light",
		light_source = 2 + num,
		is_ground_content = false,
		groups = { cracky = 2, ["telemosaic_extender_"..strength] = 1 },
		sounds = default.node_sound_stone_defaults(),
		after_place_node = telemosaic.extender_after_place,
		on_destruct = telemosaic.extender_on_destruct,
	})
end

-- beacons
minetest.register_node("telemosaic:beacon_off", {
	description = "Telemosaic beacon (off)",
	tiles = {
		"telemosaic_beacon_off.png",
		"telemosaic_beacon_off.png",
		"telemosaic_beacon_side.png",
		"telemosaic_beacon_side.png",
		"telemosaic_beacon_side.png",
		"telemosaic_beacon_side.png",
	},
	paramtype = "light",
	light_source = 4,
	is_ground_content = false,
	groups = { cracky = 2 },
	sounds = default.node_sound_stone_defaults(),
	after_place_node = telemosaic.beacon_after_place,
	on_rightclick = telemosaic.beacon_rightclick,
	on_destruct = telemosaic.beacon_on_destruct,
	on_receive_fields = telemosaic.on_receive_fields,
})

minetest.register_node("telemosaic:beacon", {
	description = "Telemosaic beacon (on)",
	tiles = {
		"telemosaic_beacon_top.png",
		"telemosaic_beacon_side.png",
		"telemosaic_beacon_side.png",
		"telemosaic_beacon_side.png",
		"telemosaic_beacon_side.png",
		"telemosaic_beacon_side.png",
	},
	paramtype = "light",
	light_source = 5,
	is_ground_content = false,
	groups = { cracky = 2, not_in_creative_inventory = 1 },
	drop = "telemosaic:beacon_off",
	sounds = default.node_sound_stone_defaults(),
	on_rightclick = telemosaic.beacon_rightclick,
	on_destruct = telemosaic.beacon_on_destruct,
	on_receive_fields = telemosaic.on_receive_fields,
})

minetest.register_node("telemosaic:beacon_err", {
	description = "Telemosaic beacon (err)",
	tiles = {
		"telemosaic_beacon_err.png",
		"telemosaic_beacon_side.png",
		"telemosaic_beacon_side.png",
		"telemosaic_beacon_side.png",
		"telemosaic_beacon_side.png",
		"telemosaic_beacon_side.png",
	},
	paramtype = "light",
	light_source = 3,
	is_ground_content = false,
	groups = { cracky = 2, not_in_creative_inventory = 1 },
	drop = "telemosaic:beacon_off",
	sounds = default.node_sound_stone_defaults(),
	on_rightclick = telemosaic.beacon_rightclick,
	on_destruct = telemosaic.beacon_on_destruct,
	on_receive_fields = telemosaic.on_receive_fields,
})

-- telemosaic key
minetest.register_tool("telemosaic:key", {
	description = "Telemosaic key",
	inventory_image = "telemosaic_key.png",
	stack_max = 1,
	groups = { not_in_creative_inventory = 1 },
})
