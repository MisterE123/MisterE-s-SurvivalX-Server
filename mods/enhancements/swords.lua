-- SWORDS DEFAULT
minetest.override_item("default:sword_diamond", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:sword_wood", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:sword_stone", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:sword_steel", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:sword_bronze", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:sword_mese", {
	wield_scale = {x=1.5, y=2, z=1},
})

-- SWORDS MOREORES
if (minetest.get_modpath("moreores")) then
	minetest.override_item("moreores:sword_mithril", {
		wield_scale = {x=1.5, y=2, z=1},
	})

	minetest.override_item("moreores:sword_silver", {
		wield_scale = {x=1.5, y=2, z=1},
	})
end
