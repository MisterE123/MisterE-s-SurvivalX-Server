--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Diamonds by InfinityProject - re-done by SaKeL
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

minetest.register_node( "diamonds:diamond_in_ground", {
	description = "Super Diamond Ore",
	tiles = { "default_stone.png^diamond_in_ground.png" },
	groups = {cracky=1},
	drop = "diamonds:diamond",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node( "diamonds:block", {
	description = "Super Diamond Block",
	tiles = { "diamond_block.png" },
	is_ground_content = true,
	groups = {cracky = 1, level = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craftitem( "diamonds:diamond", {
	description = "Super Diamond",
	inventory_image = "diamonds_diamond.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

if minetest.get_modpath("playereffects") ~= nil then
	-- playereffects.register_effect_type(effect_type_id, description, icon, groups, apply, cancel, hidden, cancel_on_death, repeat_interval)
	playereffects.register_effect_type("diamonds:apple_eff", "Apple Powers", "diamond_apple_16.png", {"apple_eff"},
		function(player)
			player:set_physics_override(2,1.5,1.1)
		end,
		
		function(effect, player)
			player:set_physics_override(1,1,1)
		end,
		false, true
	)

	playereffects.register_effect_type("diamonds:apple_eff_regen", "Health Regen", "heart_16.png", {"health"},
		function(player)
			player:set_hp(player:get_hp()+2)
		end,
		nil, false, true, 1
	)
end

minetest.register_craftitem("diamonds:diamond_apple", {
	description = "Super diamond apple.",
	inventory_image = "diamond_apple.png",
	on_use = function(itemstack, user, pointed_thing)

		minetest.sound_play("apple_eat", {to_player = user:get_player_name(), gain = 0.7})

		user:set_hp(20)
		
		if minetest.get_modpath("playereffects") ~= nil then
			local effects = playereffects.get_player_effects(user:get_player_name())

			-- if #effects > 0 then
			-- 	for e=1, #effects do
			-- 		if effects[e].effect_type_id == "diamonds:apple_eff" then
			-- 			minetest.chat_send_player(user:get_player_name(), "You can eat only one diamond apple at one time.")
			-- 			return
			-- 		end
			-- 	end
			-- end


			-- playereffects.apply_effect_type(effect_type_id, duration, player, repeat_interval_time_left)
			playereffects.apply_effect_type("diamonds:apple_eff", 30, user)
			playereffects.apply_effect_type("diamonds:apple_eff_regen", 30, user)

			minetest.chat_send_player(user:get_player_name(), "You have super powers for 30 seconds.")
		end

		itemstack:take_item()

		return itemstack
	end
})

--
--Tools
--

minetest.register_tool("diamonds:sword", {
	description = "Super Diamond Sword",
	inventory_image = "diamond_sword.png",
	tool_capabilities = {
		full_punch_interval = 0.5,
		max_drop_level=1,
		groupcaps={
			fleshy={times={[1]=2.00, [2]=0.65, [3]=0.25}, uses=500, maxlevel=3},
			snappy={times={[1]=1.90, [2]=0.80, [3]=0.30}, uses=450, maxlevel=3},
			choppy={times={[3]=0.65}, uses=400, maxlevel=0}
		},
		damage_groups = {fleshy=9},
	}
})

minetest.register_tool("diamonds:axe", {
	description = "Super Diamond Axe",
	inventory_image = "diamond_axe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=500, maxlevel=2},
			fleshy={times={[2]=0.95, [3]=0.30}, uses=600, maxlevel=2}
		},
		damage_groups = {fleshy=7},
	},
})

minetest.register_tool("diamonds:shovel", {
	description = "Super Diamond Shovel",
	inventory_image = "diamond_shovel.png",
	wield_image = "diamond_shovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly={times = {[1]=1.10, [2]=0.50, [3]=0.30}, uses=500, maxlevel=3}
		},
		damage_groups = {fleshy=4},
	},
})

minetest.register_tool("diamonds:pick", {
	description = "Super Diamond Pickaxe",
	inventory_image = "diamond_pick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky={times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=500, maxlevel=3},
			crumbly={times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=600, maxlevel=3},
			snappy={times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=550, maxlevel=3}
		},
		damage_groups = {fleshy=5},
	},
})

--
--Diamonds in steel
--Awesome idea by SegFault22
--

minetest.register_craftitem( "diamonds:ingot", {
	description = "Super Diamond and Steel Ingot",
	inventory_image = "diamonds_ingot.png",
	on_place_on_ground = minetest.craftitem_place_item,
})

minetest.register_node( "diamonds:steelblock", {
	description = "Super Diamond and Steel Block",
	tiles = { "diamond_steel_block.png" },
	groups = {cracky = 1, level = 3},
	sounds = default.node_sound_stone_defaults(),
})

--
--Diamond and Steel Tools
--

minetest.register_tool("diamonds:steelsword", {
	description = "Super Diamond and Steel Sword",
	inventory_image = "diamond_steel_sword.png",
	tool_capabilities = {
		full_punch_interval = 0.45,
		max_drop_level=1,
		groupcaps={
			fleshy={times={[1]=2.00, [2]=0.65, [3]=0.25}, uses=700, maxlevel=3},
			snappy={times={[1]=1.90, [2]=0.70, [3]=0.25}, uses=650, maxlevel=3},
			choppy={times={[3]=0.65}, uses=600, maxlevel=0}
		},
		damage_groups = {fleshy=9},
	}
})

minetest.register_tool("diamonds:steelaxe", {
	description = "Super Diamond and Steel Axe",
	inventory_image = "diamond_steel_axe.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=700, maxlevel=2},
			fleshy={times={[2]=0.95, [3]=0.30}, uses=800, maxlevel=2}
		},
		damage_groups = {fleshy=7},
	},
})

minetest.register_tool("diamonds:steelshovel", {
	description = "Super Diamond and Steel Shovel",
	inventory_image = "diamond_steel_shovel.png",
	wield_image = "diamond_steel_shovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly={times={[1]=1.10, [2]=0.50, [3]=0.30}, uses=700, maxlevel=3}
		},
		damage_groups = {fleshy=4},
	},
})

minetest.register_tool("diamonds:steelpick", {
	description = "Super Diamond and Steel Pickaxe",
	inventory_image = "diamond_steel_pick.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky={times={[1]=2.0, [2]=1.0, [3]=0.50}, uses=700, maxlevel=3},
			crumbly={times={[1]=2.0, [2]=1.0, [3]=0.5}, uses=800, maxlevel=3},
			snappy={times={[1]=2.0, [2]=1.0, [3]=0.5}, uses=750, maxlevel=3}
		},
		damage_groups = {fleshy=5},
	},
})

--
--Diamond Showcase
--

minetest.register_node( "diamonds:garden_block", {
	description = "Super Diamond Showcase",
	tiles = { "diamond_showcase_block.png" },
	is_ground_content = true,
	groups = {cracky = 1, level = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node( "diamonds:garden", {
	drawtype = "plantlike",
	description = "Super Diamond Showcase",
	tiles = { "diamond_showcase.png" },
	is_ground_content = true,
	paramtype = "light",
	visual_scale = 1.0,
	pointable = false,
	groups = {immortal=1,not_in_creative_inventory=1},
	sounds = default.node_sound_stone_defaults(),
})

function add_garden(pos, node, active_object_count, active_object_count_wider)
	if 
	  node.name == "diamonds:garden_block"
	then
	  pos.y = pos.y + 1
	  minetest.add_node(pos, {name="diamonds:garden"})
  end
end
minetest.register_on_placenode(add_garden)

function remove_garden(pos, node, active_object_count, active_object_count_wider)
	if 
	  node.name == "diamonds:garden_block"
	then
	  pos.y = pos.y + 1
	  minetest.remove_node(pos, {name="diamonds:garden"})
  end
end
minetest.register_on_dignode(remove_garden)

--
--Crafting
--

minetest.register_craft({
	output = 'diamonds:pick',
	recipe = {
		{'diamonds:diamond', 'diamonds:diamond', 'diamonds:diamond'},
		{'', 'group:stick', ''},
		{'', 'group:stick', ''},
	}
})

minetest.register_craft({
	output = 'diamonds:axe',
	recipe = {
		{'diamonds:diamond', 'diamonds:diamond'},
		{'diamonds:diamond', 'group:stick'},
		{'', 'group:stick'},
	}
})

minetest.register_craft({
	output = 'diamonds:axe',
	recipe = {
		{'diamonds:diamond', 'diamonds:diamond'},
		{'group:stick', 'diamonds:diamond'},
		{'group:stick', ''},
	}
})

minetest.register_craft({
	output = 'diamonds:shovel',
	recipe = {
		{'diamonds:diamond'},
		{'group:stick'},
		{'group:stick'},
	}
})

minetest.register_craft({
	output = 'diamonds:sword',
	recipe = {
		{'diamonds:diamond'},
		{'diamonds:diamond'},
		{'default:obsidian_shard'},
	}
})

minetest.register_craft({
	output = 'diamonds:block',
	recipe = {
		{'diamonds:diamond', 'diamonds:diamond', 'diamonds:diamond'},
		{'diamonds:diamond', 'diamonds:diamond', 'diamonds:diamond'},
		{'diamonds:diamond', 'diamonds:diamond', 'diamonds:diamond'},
	}
})

minetest.register_craft({
	output = 'diamonds:diamond 9',
	recipe = {
		{'diamonds:block'},
	}
})

minetest.register_craft({
	output = 'diamonds:ingot 2',
	recipe = {
		{'diamonds:diamond'},
		{'default:steel_ingot'},
		{'diamonds:diamond'},
	}
})

minetest.register_craft({
	output = 'diamonds:steelsword',
	recipe = {
		{'diamonds:ingot'},
		{'diamonds:ingot'},
		{'default:obsidian_shard'},
	}
})

minetest.register_craft({
	output = 'diamonds:steelpick',
	recipe = {
		{'diamonds:ingot', 'diamonds:ingot', 'diamonds:ingot'},
		{'', 'default:obsidian_shard', ''},
		{'', 'default:obsidian_shard', ''},
	}
})

minetest.register_craft({
	output = 'diamonds:steelaxe',
	recipe = {
		{'diamonds:ingot', 'diamonds:ingot'},
		{'diamonds:ingot', 'group:stick'},
		{'', 'group:stick'},
	}
})

minetest.register_craft({
	output = 'diamonds:steelaxe',
	recipe = {
		{'diamonds:ingot', 'diamonds:ingot'},
		{'group:stick', 'diamonds:ingot'},
		{'group:stick', ''},
	}
})

minetest.register_craft({
	output = 'diamonds:steelshovel',
	recipe = {
		{'diamonds:ingot'},
		{'group:stick'},
		{'group:stick'},
	}
})

minetest.register_craft({
	output = 'diamonds:steelblock',
	recipe = {
		{'diamonds:ingot', 'diamonds:ingot', 'diamonds:ingot'},
		{'diamonds:ingot', 'diamonds:ingot', 'diamonds:ingot'},
		{'diamonds:ingot', 'diamonds:ingot', 'diamonds:ingot'},
	}
})

minetest.register_craft({
	output = 'diamonds:garden_block',
	recipe = {
		{'', 'diamonds:diamond', ''},
		{'diamonds:diamond', 'diamonds:block', 'diamonds:diamond'},
		{'', 'diamonds:diamond', ''},
	}
})

minetest.register_craft({
	output = 'diamonds:ingot 9',
	recipe = {
		{'diamonds:steelblock'},
	}
})

minetest.register_craft({
	output = 'diamonds:diamond_apple 2',
	recipe = {
		{'diamonds:diamond', 'diamonds:diamond', 'diamonds:diamond'},
		{'diamonds:diamond','default:apple', 'diamonds:diamond'},
		{'diamonds:diamond', 'diamonds:diamond', 'diamonds:diamond'},
	}
})

--
--Generation
--

local function generate_ore(name, wherein, minp, maxp, seed, chunks_per_volume, ore_per_chunk, y_min, y_max)
	if maxp.y < y_min or minp.y > y_max then
		return
	end
	local y_min = math.max(minp.y, y_min)
	local y_max = math.min(maxp.y, y_max)
	local volume = (maxp.x-minp.x+1)*(y_max-y_min+1)*(maxp.z-minp.z+1)
	local pr = PseudoRandom(seed)
	local num_chunks = math.floor(chunks_per_volume * volume)
	local chunk_size = 3
	if ore_per_chunk <= 4 then
		chunk_size = 2
	end
	local inverse_chance = math.floor(chunk_size*chunk_size*chunk_size / ore_per_chunk)
	--print("generate_ore num_chunks: "..dump(num_chunks))
	for i=1,num_chunks do
		local y0 = pr:next(y_min, y_max-chunk_size+1)
		if y0 >= y_min and y0 <= y_max then
			local x0 = pr:next(minp.x, maxp.x-chunk_size+1)
			local z0 = pr:next(minp.z, maxp.z-chunk_size+1)
			local p0 = {x=x0, y=y0, z=z0}
			for x1=0,chunk_size-1 do
			for y1=0,chunk_size-1 do
			for z1=0,chunk_size-1 do
				if pr:next(1,inverse_chance) == 1 then
					local x2 = x0+x1
					local y2 = y0+y1
					local z2 = z0+z1
					local p2 = {x=x2, y=y2, z=z2}
					if minetest.get_node(p2).name == wherein then
						minetest.set_node(p2, {name=name})
					end
				end
			end
			end
			end
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
generate_ore("diamonds:diamond_in_ground", "default:stone", minp, maxp, seed+20,   1/13/13/13,    2, -31000,  -10000)
end)

print("[Mod] Diamonds Loaded.")
