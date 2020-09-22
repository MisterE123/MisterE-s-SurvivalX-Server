-- AXE DEFAULT
minetest.override_item("default:axe_diamond", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:axe_wood", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:axe_stone", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:axe_steel", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:axe_bronze", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:axe_mese", {
	wield_scale = {x=1.5, y=2, z=1},
})

-- AXE MOREORES
if (minetest.get_modpath("moreores")) then
	minetest.override_item("moreores:axe_mithril", {
		wield_scale = {x=1.5, y=2, z=1},
	})

	minetest.override_item("moreores:axe_silver", {
		wield_scale = {x=1.5, y=2, z=1},
	})
end

-- AXE SUPER DIAMONDS
if (minetest.get_modpath("diamonds")) then
	minetest.override_item("diamonds:axe", {
		wield_scale = {x=1.5, y=2, z=1},
	})

	minetest.override_item("diamonds:steelaxe", {
		wield_scale = {x=1.5, y=2, z=1},
	})
end

