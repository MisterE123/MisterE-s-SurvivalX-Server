------------
-- Bonemeal Mod for Minetest by SaKeL
-- @author Juraj Vajda
-- @license GNU LGPL 2.1
----

local path = minetest.get_modpath("bonemeal")

--- API include
-- @submodule
dofile(path.."/api.lua")

--- Register craftitem definition - added to minetest.registered_items[name]
-- @function
minetest.register_craftitem("bonemeal:bonemeal", {
	description = "Bonemeal - use it as a fertilizer for most plants",
	inventory_image = "bonemeal_bonemeal.png",
	wield_scale = {x=1.5, y=1.5, z=1},
	sound = {breaks = "default_tool_breaks"},
	on_use = function(itemstack, user, pointed_thing)
		local pt = pointed_thing
		local under = pointed_thing.under

		if not under then return end
		if pointed_thing.type ~= "node" then return end
		if minetest.is_protected(under, user:get_player_name()) then return end

		local node = minetest.get_node(under)

		if not node then return end
		if node.name == "ignore" then return end

		local mod = node.name:split(":")[1]

		--
		-- Nodes
		--

		-- default:grass
		-- default:junglegrass
		if node.name == "default:dirt_with_grass" then
			bonemeal.grow_grass_and_flowers(under, itemstack, user, node.name, { "default:grass_1", "default:grass_2", "default:grass_3", "default:grass_4", "default:grass_5", "default:junglegrass" })

		-- default:dry_grass
		elseif node.name == "default:dirt_with_dry_grass" then
			bonemeal.grow_grass_and_flowers(under, itemstack, user, node.name, { "default:dry_grass_1", "default:dry_grass_2", "default:dry_grass_3", "default:dry_grass_4", "default:dry_grass_5" })

		-- default:dry_shrub
		elseif minetest.get_item_group(node.name, "sand") == 1 or
					 node.name == "default:dirt_with_snow" then
			bonemeal.grow_grass_and_flowers(under, itemstack, user, node.name, "default:dry_shrub")

		--
		-- Flowers
		--

		elseif mod == "flowers" then
			if node.name == "flowers:waterlily" then
				-- waterlily
				bonemeal.grow_grass_and_flowers(under, itemstack, user, "default:water_source", node.name)
			else
				bonemeal.grow_grass_and_flowers(under, itemstack, user, "default:dirt_with_grass", node.name)
			end

		-- bakedclay mod
		elseif mod == "bakedclay" then
			if node.name == "bakedclay:delphinium" or
				 node.name == "bakedclay:thistle" or
				 node.name == "bakedclay:lazarus" or
				 node.name == "bakedclay:mannagrass" then
				bonemeal.grow_grass_and_flowers(under, itemstack, user, "default:dirt_with_grass", node.name)
			end

		--
		-- Farming
		--

		elseif mod == "farming" or mod == "farming_addons" then
			bonemeal.grow_farming(under, itemstack, user, node.name)

		--
		-- Default (Trees, Bushes, Papyrus)
		--

		-- christmas tree
		elseif node.name == "x_default:christmas_tree_sapling" then
			local chance = math.random(2)
			if not bonemeal.is_on_soil(under) then return end

			if chance == 1 then
				if minetest.find_node_near(under, 1, {"group:snowy"}) then
					x_default.grow_snowy_christmas_tree(under)
				else
					x_default.grow_christmas_tree(under)
				end

				bonemeal.particle_effect({x = under.x, y = under.y + 1, z = under.z})
			end
			-- take item if not in creative
			if not bonemeal.is_creative(user:get_player_name()) then
				itemstack:take_item()
			end
			return itemstack

		-- apple tree
		elseif node.name == "default:sapling" then
			local chance = math.random(2)
			if not bonemeal.is_on_soil(under) then return end

			if chance == 1 then
				default.grow_new_apple_tree(under)
				bonemeal.particle_effect({x = under.x, y = under.y + 1, z = under.z})
			end
			-- take item if not in creative
			if not bonemeal.is_creative(user:get_player_name()) then
				itemstack:take_item()
			end
			return itemstack

		-- jungle tree
		elseif node.name == "default:junglesapling" then
			local chance = math.random(2)
			if not bonemeal.is_on_soil(under) then return end

			if chance == 1 then
				default.grow_new_jungle_tree(under)
				bonemeal.particle_effect({x = under.x, y = under.y + 1, z = under.z})
			end
			-- take item if not in creative
			if not bonemeal.is_creative(user:get_player_name()) then
				itemstack:take_item()
			end
			return itemstack

		-- emergent jungle tree
		elseif node.name == "default:emergent_jungle_sapling" then
			local chance = math.random(2)
			if not bonemeal.is_on_soil(under) then return end

			if chance == 1 then
				default.grow_new_emergent_jungle_tree(under)
				bonemeal.particle_effect({x = under.x, y = under.y + 1, z = under.z})
			end
			-- take item if not in creative
			if not bonemeal.is_creative(user:get_player_name()) then
				itemstack:take_item()
			end
			return itemstack

		-- acacia tree
		elseif node.name == "default:acacia_sapling" then
			local chance = math.random(2)
			if not bonemeal.is_on_soil(under) then return end

			if chance == 1 then
				default.grow_new_acacia_tree(under)
				bonemeal.particle_effect({x = under.x, y = under.y + 1, z = under.z})
			end
			-- take item if not in creative
			if not bonemeal.is_creative(user:get_player_name()) then
				itemstack:take_item()
			end
			return itemstack

		-- aspen tree
		elseif node.name == "default:aspen_sapling" then
			local chance = math.random(2)
			if not bonemeal.is_on_soil(under) then return end

			if chance == 1 then
				default.grow_new_aspen_tree(under)
				bonemeal.particle_effect({x = under.x, y = under.y + 1, z = under.z})
			end
			-- take item if not in creative
			if not bonemeal.is_creative(user:get_player_name()) then
				itemstack:take_item()
			end
			return itemstack

		-- pine tree
		elseif node.name == "default:pine_sapling" then
			local chance = math.random(4)
			if not bonemeal.is_on_soil(under) then return end

			if chance == 3 then
				default.grow_new_snowy_pine_tree(under)
			elseif chance == 1 then
				default.grow_new_pine_tree(under)
				bonemeal.particle_effect({x = under.x, y = under.y + 1, z = under.z})
			end
			-- take item if not in creative
			if not bonemeal.is_creative(user:get_player_name()) then
				itemstack:take_item()
			end
			return itemstack

		-- Bush
		elseif node.name == "default:bush_sapling" then
			local chance = math.random(2)

			if chance == 1 then
				if not bonemeal.is_on_soil(under) then return end
				default.grow_bush(under)
				bonemeal.particle_effect({x = under.x, y = under.y + 1, z = under.z})
			end
			-- take item if not in creative
			if not bonemeal.is_creative(user:get_player_name()) then
				itemstack:take_item()
			end
			return itemstack

		-- Acacia bush
		elseif node.name == "default:acacia_bush_sapling" then
			local chance = math.random(2)

			if chance == 1 then
				if not bonemeal.is_on_soil(under) then return end
				default.grow_acacia_bush(under)
				bonemeal.particle_effect({x = under.x, y = under.y + 1, z = under.z})
			end
			-- take item if not in creative
			if not bonemeal.is_creative(user:get_player_name()) then
				itemstack:take_item()
			end
			return itemstack

		-- Papyrus
		elseif node.name == "default:papyrus" then
			local chance = math.random(2)

			if chance == 1 then
				if not bonemeal.is_on_soil(under) then return end
				default.grow_papyrus(under, node)
				bonemeal.particle_effect({x = under.x, y = under.y + 1, z = under.z})
			end
			-- take item if not in creative
			if not bonemeal.is_creative(user:get_player_name()) then
				itemstack:take_item()
			end
			return itemstack
		end

		return itemstack
	end,
})

--
-- Crafting
--

minetest.register_craft({
  output = 'bonemeal:bonemeal 9',
  recipe = {
    {'bones:bones'}
  }
})

minetest.register_craft({
  output = 'bonemeal:bonemeal 9',
  recipe = {
    {'default:coral_skeleton'}
  }
})

print("[Mod] Bonemeal Loaded.")
