-- PICK-AXE DEFAULT
minetest.override_item("default:pick_diamond", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:pick_wood", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:pick_stone", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:pick_steel", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:pick_bronze", {
	wield_scale = {x=1.5, y=2, z=1},
})

minetest.override_item("default:pick_mese", {
	wield_scale = {x=1.5, y=2, z=1},
})

-- PICK-AXE MOREORES
if (minetest.get_modpath("moreores")) then
	minetest.override_item("moreores:pick_mithril", {
		wield_scale = {x=1.5, y=2, z=1},
	})

	minetest.override_item("moreores:pick_silver", {
		wield_scale = {x=1.5, y=2, z=1},
	})
end

-- OBSIDIANMESE
if (minetest.get_modpath("obsidianmese")) then
	minetest.override_item("obsidianmese:pick", {
		wield_scale = {x=1.5, y=2, z=1},
	})

	minetest.override_item("obsidianmese:pick_engraved", {
		wield_scale = {x=1.5, y=2, z=1},
	})
end

-- MOBS
if (minetest.get_modpath("mobs_monsters")) then
	minetest.override_item("mobs_monsters:pick_lava", {
		wield_scale = {x=1.5, y=2, z=1},
	})
end
