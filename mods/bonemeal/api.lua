------------
-- Main API for bonemeal Mod
-- @author Juraj Vajda
-- @license GNU LGPL 2.1
----

--- Main bonemeal class
-- @classmod bonemeal
bonemeal = {}

--- Get creative mode setting from minetest.conf
-- @local
local creative_mode_cache = minetest.settings:get_bool("creative_mode")

--- Check if creating mode is enabled or player has creative privs
-- @function
-- @param name Player name
-- @return Boolean
function bonemeal.is_creative(name)
	return creative_mode_cache or minetest.check_player_privs(name, {creative = true})
end

--- Check if node has a soil below its self
-- @function
-- @param under table of position
-- @return Boolean
function bonemeal.is_on_soil(under)
	local below = minetest.get_node({x = under.x, y = under.y - 1, z = under.z})
	if minetest.get_item_group(below.name, "soil") == 0 then
		return false
	end
	return true
end

--- Growth steps for farming plants, there is no way of getting them dynamically, so they are defined in the local table variable
-- @table farming_steps
-- @local
local farming_steps = {
	["farming:wheat"] = 8,
	["farming:cotton"] = 8,
	["farming_addons:coffee"] = 5,
	["farming_addons:corn"] = 10,
	["farming_addons:obsidian_wart"] = 6,
	["farming_addons:melon"] = 8,
	["farming_addons:pumpkin"] = 8,
	["farming_addons:carrot"] = 8,
	["farming_addons:potato"] = 8,
	["farming_addons:beetroot"] = 8,
}

--- Particle and sound effect after the bone meal is successfully used
-- @function
-- @param pos table containing position
function bonemeal.particle_effect(pos)
	minetest.sound_play("bonemeal_grow", {
		pos = pos,
		gain = 0.5,
	})

	minetest.add_particlespawner({
		amount = 4,
		time = 0.15,
		minpos = pos,
		maxpos = pos,
		minvel = {x = -0.5, y = 0.5, z = -0.5},
		maxvel = {x = 0.5, y = 1, z = 0.5},
		minacc = {x = -0.5, y = -0.5, z = -0.5},
		maxacc = {x = 0.5, y = 0.5, z = 0.5},
		minexptime = 1,
		maxexptime = 1,
		minsize = 1,
		maxsize = 3,
		texture = "bonemeal_particle.png",
	})
end

--- Handle growth of grass, flowers, mushrooms
-- @function
-- @param pos table containing position
-- @param find_node_name node what has to be around the pos for successful growth
-- @param replace_node_name what are we growing (grass, flower, mushroom)
function bonemeal.grow_grass_and_flowers(pos, itemstack, user, find_node_name, replace_node_name)
	if not pos or not find_node_name or not replace_node_name then return itemstack end

	local pos0 = vector.subtract(pos, 2)
	local pos1 = vector.add(pos, 2)
	local positions = minetest.find_nodes_in_area_under_air(pos0, pos1, find_node_name)
	local howmany = math.random(5)
	print(#positions)
	if #positions == 0 then return itemstack end

	if howmany > #positions then
		howmany = #positions
	end

	for i = 1, howmany do
		local idx = math.random(#positions)
		local grass = replace_node_name

		if type(replace_node_name) == "table" then
			grass = replace_node_name[math.random(#replace_node_name)]
		end

		bonemeal.particle_effect({x = positions[idx].x, y = positions[idx].y + 1, z = positions[idx].z})

		minetest.set_node({x = positions[idx].x, y = positions[idx].y + 1, z = positions[idx].z}, { name = grass })

		table.remove(positions, idx)
	end

	-- take item if not in creative
	if not bonemeal.is_creative(user:get_player_name()) then
		itemstack:take_item()
	end

	return itemstack
end

--- Handle farming and farming addons plants. Needed to copy this function from minetest_game and modify it in order to ommit some checks (e.g. light..)
-- @function
-- @param pos table containing position
-- @param replace_node_name the node/plant what we are growing/replacing with new growth stage
function bonemeal.grow_farming(pos, itemstack, user, replace_node_name)
	local ndef = minetest.registered_nodes[replace_node_name]

	if not ndef.next_plant or ndef.next_plant == "farming_addons:pumpkin_fruit" or ndef.next_plant == "farming_addons:melon_fruit" then return itemstack end

	-- check if on wet soil
	local below = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
	if minetest.get_item_group(below.name, "soil") < 3 then
		return itemstack
	end

	local plant = replace_node_name:split("_")[1]
	local current_step = tonumber(string.reverse(replace_node_name):split("_")[1])
	local max_step = farming_steps[replace_node_name:gsub("_%d+", "", 1)]

	-- check if seed
	-- farming:seed_wheat
	local mod_plant = replace_node_name:split(":")
	-- seed_wheat
	local seed_plant = mod_plant[2]:split("_")
	-- print("seed: ", mod_plant[1]..":"..seed_plant[2])

	if seed_plant[1] == "seed" then
		current_step = 0
		if replace_node_name == "farming_addons:seed_obsidian_wart" then
			replace_node_name = mod_plant[1]..":"..seed_plant[2].."_"..seed_plant[3]
		else
			replace_node_name = mod_plant[1]..":"..seed_plant[2]
		end
		max_step = farming_steps[replace_node_name]
		replace_node_name = replace_node_name.."_"..current_step
	end

	-- print(dump(ndef))
	-- print("current_step: ", current_step)
	-- print("max_step: ", max_step)

	if not current_step or not max_step then return itemstack end

	local available_steps = max_step - current_step
	local new_step = max_step - available_steps + math.random(available_steps)
	local new_plant = replace_node_name:gsub("_%d+", "_"..new_step, 1)

	-- print("new_plant: ", new_plant)

	local placenode = {name = new_plant}
	if ndef.place_param2 then
		placenode.param2 = ndef.place_param2
	end

	bonemeal.particle_effect(pos)
	minetest.swap_node(pos, placenode)

	-- take item if not in creative
	if not bonemeal.is_creative(user:get_player_name()) then
		itemstack:take_item()
	end

	return itemstack
end
