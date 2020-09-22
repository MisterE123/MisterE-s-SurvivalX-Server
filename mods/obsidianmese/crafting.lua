--
-- Craft Items
--

-- mese apple
minetest.register_craftitem("obsidianmese:mese_apple", {
	description = "Mese apple [restores full health]",
	inventory_image = "obsidianmese_apple.png",
	on_use = function(itemstack, user, pointed_thing)

		minetest.sound_play("obsidianmese_apple_eat", {
			pos = user:getpos(),
			max_hear_distance = 32,
			gain = 0.5,
		})

		user:set_hp(20)
		itemstack:take_item()
		return itemstack
	end
})

--
-- Crafting
-- no craft for engraved sword, that is rare item obtained only by drops
--
minetest.register_craft({
	output = 'obsidianmese:chest',
	recipe = {
		{'default:obsidian','default:obsidian','default:obsidian'},
		{'default:obsidian','default:mese','default:obsidian'},
		{'default:obsidian','default:obsidian','default:obsidian'}
	}
})

minetest.register_craft({
	output = "obsidianmese:sword",
	recipe = {
		{"", "default:mese_crystal", ""},
		{"default:obsidian_shard", "default:mese_crystal", "default:obsidian_shard"},
		{"", "default:obsidian_shard", ""},
	}
})

minetest.register_craft({
	output = "obsidianmese:pick",
	recipe = {
		{"default:mese_crystal", "default:mese_crystal", "default:mese_crystal"},
		{"", "default:obsidian_shard", ""},
		{"", "default:obsidian_shard", ""},
	}
})

minetest.register_craft({
	output = "obsidianmese:shovel",
	recipe = {
		{"default:mese_crystal"},
		{"default:obsidian_shard"},
		{"default:obsidian_shard"},
	}
})

minetest.register_craft({
	output = "obsidianmese:axe",
	recipe = {
		{"default:mese_crystal", "default:mese_crystal"},
		{"default:mese_crystal", "default:obsidian_shard"},
		{"", "default:obsidian_shard"},
	}
})

-- minetest.register_craft({
-- 	output = "obsidianmese:hoe",
-- 	recipe = {
-- 		{"default:mese_crystal", "default:mese_crystal", ""},
-- 		{"", "default:obsidian_shard", ""},
-- 		{"", "default:obsidian_shard", ""},
-- 	}
-- })

minetest.register_craft({
	output = "obsidianmese:pick_engraved",
	recipe = {
		{"default:diamond", "default:diamond", "default:diamond"},
		{"", "default:obsidian_shard", ""},
		{"", "default:obsidian_shard", ""},
	}
})

minetest.register_craft({
	output = "obsidianmese:mese_apple 4",
	recipe = {
		{"", "default:apple", ""},
		{"default:apple","default:mese", "default:apple"},
		{"", "default:apple", ""},
	}
})
