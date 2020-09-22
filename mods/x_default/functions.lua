--
-- magma growth on cobble near lava
--

minetest.register_abm({
	label = "Magma growth",
	nodenames = {"default:cobble", "stairs:slab_cobble", "stairs:stair_cobble", "stairs:stair_inner_cobble", "stairs:stair_outer_cobble", "walls:cobble"},
	neighbors = {"group:lava"},
	interval = 16,
	chance = 200,
	catch_up = false,
	action = function(pos, node)
		if node.name == "default:cobble" then
			minetest.set_node(pos, {name = "x_default:magmacobble"})
		elseif node.name == "stairs:slab_cobble" then
			minetest.set_node(pos, {name = "stairs:slab_magmacobble", param2 = node.param2})
		elseif node.name == "stairs:stair_cobble" then
			minetest.set_node(pos, {name = "stairs:stair_magmacobble", param2 = node.param2})
		elseif node.name == "stairs:stair_inner_cobble" then
			minetest.set_node(pos, {name = "stairs:stair_inner_magmacobble", param2 = node.param2})
		elseif node.name == "stairs:stair_outer_cobble" then
			minetest.set_node(pos, {name = "stairs:stair_outer_magmacobble", param2 = node.param2})
		elseif node.name == "walls:cobble" then
			minetest.set_node(pos, {name = "x_walls:magmacobble", param2 = node.param2})
		end
	end
})

--
-- Player dies
--

function x_default:isInMMOArena(pos)
	local pos0 = pos

	if not pos0 then
		return false
	end

	local balrog_area_pos1 = { x = 149, y = 8, z = 238 }
	local balrog_area_pos2 = { x = 212, y = 108, z = 302 }

	if (pos0.x >= balrog_area_pos1.x and pos0.x <= balrog_area_pos2.x) and
		 (pos0.y >= balrog_area_pos1.y and pos0.y <= balrog_area_pos2.y) and
		 (pos0.z >= balrog_area_pos1.z and pos0.z <= balrog_area_pos2.z) then

		 return true
	end

	return false
end

minetest.register_on_dieplayer(function(player, reason)
	local pos0 = vector.round(player:getpos())

	-- drop players inventory if inside the balrog area
	if x_default:isInMMOArena(pos0) then

		local player_inventory_lists = { "main", "craft" }
		local player_inv = player:get_inventory()

		for _, list_name in ipairs(player_inventory_lists) do
			for i = 1, player_inv:get_size(list_name) do
				local itemstack = player_inv:get_stack(list_name, i)
				local obj = minetest.add_item(pos0, itemstack:take_item(itemstack:get_count()))

				if obj then
					obj:set_velocity({
						x = math.random(-10, 10) / 9,
						y = 5,
						z = math.random(-10, 10) / 9,
					})
				end
			end
			player_inv:set_list(list_name, {})
		end
	end
end)

-- External Command (external_cmd) mod by Menche
-- Allows server commands / chat from outside minetest
-- License: LGPL

local external_cmd_admin = "SERVER"
local external_cmd_timer = 0
-- local external_cmd_admin = minetest.settings:get("name")

-- if external_cmd_admin == nil then
-- 	external_cmd_admin = "SERVER"
-- end

minetest.register_globalstep(function(dtime)
	external_cmd_timer = external_cmd_timer + dtime

	-- every 5 second
	if external_cmd_timer >= 5 then
		external_cmd_timer = 0
		local f = (io.open(minetest.get_worldpath().."/message", "r"))

		if f ~= nil then
			local message = f:read("*line")
			f:close()
			os.remove(minetest.get_worldpath().."/message")

			if message ~= nil then
				local cmd, param = string.match(message, "^/([^ ]+) *(.*)")

				if not param then
					param = ""
				end

				local cmd_def = minetest.registered_chatcommands[cmd]

				if cmd_def then
					cmd_def.func(external_cmd_admin, param)
				else
					minetest.chat_send_all(external_cmd_admin..": "..message)
				end
			end
		end

	end
end)
