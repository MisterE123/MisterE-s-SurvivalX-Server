-- SHOVELS MOREORES
if (minetest.get_modpath("moreores")) then
	minetest.override_item("moreores:shovel_mithril", {
		wield_image = "moreores_tool_mithrilshovel.png^[transformR90",
	})

	minetest.override_item("moreores:shovel_silver", {
		wield_image = "moreores_tool_silvershovel.png^[transformR90",
	})
end