--[[

Telemosaic [telemosaic]
=======================

A mod which provides player-placed teleport pads

Copyright (C) 2015 Ben Deutsch <ben@bendeutsch.de>

Copyright (C) 2018 rewritten by SaKeL <juraj.vajda@gmail.com>

License
-------

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
USA

]]

local enable_particles = minetest.settings:get_bool("enable_particles")
-- @module telemosaic
telemosaic = {}
-- @field extender_ranges
telemosaic.extender_ranges = {
	["telemosaic:extender_one"] = 10,
	["telemosaic:extender_two"] = 30,
	["telemosaic:extender_three"] = 90
}
-- @field strengths
telemosaic.strengths = { "one", "two", "three" }
telemosaic.teleport_queue = {}

--- Add particle effect on deprature
-- @param {table} pos - deprature position
function telemosaic.effect_departure(pos)
	if not enable_particles then return end

	return minetest.add_particlespawner({
		amount = 100,
		time = 5,
		minpos = {x=pos.x, y=pos.y+0.3, z=pos.z},
		maxpos = {x=pos.x, y=pos.y+2, z=pos.z},
		minvel = {x = 1,  y = -6,  z = 1},
		maxvel = {x = -1, y = -1, z = -1},
		minacc = {x = 0, y = -2, z = 0},
		maxacc = {x = 0, y = -6, z = 0},
		minexptime = 0.1,
		maxexptime = 1,
		minsize = 0.5,
		maxsize = 1.5,
		texture = "telemosaic_particle_departure.png^[transform"..math.random(0,3),
		glow = 15,
	})
end

--- Add particle effect on arrival
-- @param {table} pos - arrival position
function telemosaic.effect_arrival(pos)
	minetest.sound_play("telemosaic_plop", {
		pos = pos,
		max_hear_distance = 8,
		gain = 1
	})

	if not enable_particles then return end

	minetest.add_particlespawner({
		amount = 100,
		time = 0.25,
		minpos = {x=pos.x, y=pos.y+0.3, z=pos.z},
		maxpos = {x=pos.x, y=pos.y+2, z=pos.z},
		minvel = {x = -1, y = 1, z = -1},
		maxvel = {x = 1,  y = 6,  z = 1},
		minacc = {x = 0, y = -2, z = 0},
		maxacc = {x = 0, y = -6, z = 0},
		minexptime = 0.1,
		maxexptime = 1,
		minsize = 0.5,
		maxsize = 1.5,
		texture = "telemosaic_particle_arrival.png^[transform"..math.random(0,3),
		glow = 15,
	})
end

function telemosaic.get_table_length(tbl)
	local length = 0
	for k, v in pairs(tbl) do
		length = length + 1
	end
	return length
end

function telemosaic.add_to_queue(player, pos2)
	local ppos = player:getpos()
	local dep_effect = telemosaic.effect_departure(player:get_pos())
	telemosaic.teleport_queue[player:get_player_name()] = {
		qtime = minetest.get_us_time() + (5 * 1000000),
		ppos = ppos,
		player = player,
		pos2 = pos2,
		sound = minetest.sound_play("warps_woosh", { pos = ppos, max_hear_distance = 8, gain = 1 }),
		dep_effect = dep_effect
	}
	minetest.chat_send_player(player:get_player_name(), "Don't move for 5 seconds!")

	if telemosaic.get_table_length(telemosaic.teleport_queue) == 1 then
		minetest.after(1, telemosaic.from_queue)
	end
	-- attempt to emerge the target area before the player gets there
	local vpos = vector.new(pos2)
	minetest.get_voxel_manip():read_from_map(vpos, vpos)
	if not minetest.get_node_or_nil(pos2) then
		minetest.emerge_area(vector.subtract(vpos, 8), vector.add(vpos, 8))
	end
end

function telemosaic.from_queue()
	if telemosaic.get_table_length(telemosaic.teleport_queue) == 0 then
		return
	end

	local time = minetest.get_us_time()

	for k, v in pairs(telemosaic.teleport_queue) do
		if v.player:getpos() then
			if vector.equals(v.player:getpos(), v.ppos) then
				if time > v.qtime then
					local pos2 = {x = v.pos2.x, y = v.pos2.y + 1, z = v.pos2.z}
					v.player:setpos(pos2)
					telemosaic.effect_arrival(pos2)
					telemosaic.teleport_queue[v.player:get_player_name()] = nil
				end
			else
				minetest.sound_stop(v.sound)
				minetest.delete_particlespawner(v.dep_effect)
				minetest.chat_send_player(v.player:get_player_name(),
					"You have to stand still for 5 seconds!")
				telemosaic.teleport_queue[v.player:get_player_name()] = nil
			end
		end
	end

	if telemosaic.get_table_length(telemosaic.teleport_queue) == 0 then
		return
	end

	minetest.after(1, telemosaic.from_queue)
end

--- Generate formspec dynamically
-- @param {table} pos - position of the node
-- @param {table} table - custom parameters passed in the table
-- @return {string} formspec - formspec string what can be set to metadata
function telemosaic.get_formspec(pos, table)
	local meta = minetest.get_meta(pos)
	local arrivals_tbl = meta:get_string("arrivals_tbl")
	local pos2_str = meta:get_string("dest_pos")
	local pos2 = minetest.string_to_pos(pos2_str)
	arrivals_tbl = minetest.deserialize(arrivals_tbl)
	if not arrivals_tbl then arrivals_tbl = {} end
	local range = table.range or 0
	local bname = meta:get_string("bname")
	if not bname or bname == "" then
		bname = "beacon at: "..minetest.pos_to_string(pos)
	end

	local textlist = ""
	for ipos, ival in pairs(arrivals_tbl) do
		textlist = textlist..minetest.formspec_escape(ipos)..": "..minetest.formspec_escape(ival)..","
	end

	local button_teleport = ""
	local pos2_colorize = minetest.colorize("#ff0000", pos2_str)

	if pos2 then
		local meta2 = minetest.get_meta(pos2)
		local bname2 = meta2:get_string("bname")
		pos2_colorize = minetest.colorize("#00ff00", bname2)
		button_teleport = "button_exit[0.1,7.5;2.4,1.5;teleport;Teleport Now]"
	end

	-- dynamic formspec
	local formspec = "size[12,8.5]"..
		default.gui_bg..
		default.gui_bg_img..
		default.gui_slots..
		"label[0,0.5;beacon position: "..minetest.pos_to_string(pos).."]"..
		"label[0,1;destination: "..pos2_colorize.."]"..
		"label[0,1.5;range: "..range.." blocks]"..
		"field[0.34,2.7;4,1;bname;beacon name:;"..bname.."]"..
		button_teleport..
		"button_exit[2.5,7.5;2.4,1.5;saveandclose;Save & Close]"..
		"label[5,0;Arrivals from ( x | y | z ):]"..
		"textlist[5,0.5;6.7,8;arrivals;"..textlist..";1;false]"

	return formspec
end

--- Minetest "register_on_player_receive_fields" function
-- @see https://github.com/minetest/minetest/blob/master/doc/lua_api.txt
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local mod_pos_pos2 = formname:split(":")

	if mod_pos_pos2[1] == "telemosaic" then
		local pos = minetest.string_to_pos(mod_pos_pos2[2])

		if minetest.is_protected(pos, player:get_player_name()) then
			minetest.chat_send_player(player:get_player_name(), "You cannot use protected beacon!")
			return
		end

		-- beacon name change
		if fields.bname then
			local bname = fields.bname
			local meta = minetest.get_meta(pos)
			local pos2 = minetest.string_to_pos(mod_pos_pos2[3])

			meta:set_string("bname", bname)

			if pos2 then
				local meta2 = minetest.get_meta(pos2)
				local arrivals_tbl2 = meta2:get_string("arrivals_tbl")
				arrivals_tbl2 = minetest.deserialize(arrivals_tbl2)
				if not arrivals_tbl2 then arrivals_tbl2 = {} end

				arrivals_tbl2[minetest.pos_to_string(pos)] = bname
				meta2:set_string("arrivals_tbl", minetest.serialize(arrivals_tbl2))
			end
		end

		-- teleport
		if fields.teleport then
			local pos = minetest.string_to_pos(mod_pos_pos2[2])
			local meta = minetest.get_meta(pos)
			local range = meta:get_int("range")
			local pos2 = minetest.string_to_pos(mod_pos_pos2[3])

			if pos2 then
				if math.floor(vector.distance(pos, pos2)) <= range then
					for i = 1, 2 do
						if minetest.get_node({x = pos2.x, y = pos2.y + i, z = pos2.z}).name ~= "air" then
							minetest.chat_send_player(player:get_player_name(), "Cannot teleport - not enough space in destination - the destination beacon is obstructed!")
							return
						end
					end

					telemosaic.add_to_queue(player, pos2)
				else
					minetest.chat_send_player(player:get_player_name(), "Not enough power, destination is too far. Beacon needs "..math.floor(vector.distance(pos, pos2)) - range.." more power.")
				end
			end
		end
	end
end)

--
-- extenders
--

--- Minetest "after_place_node" function
-- @see https://github.com/minetest/minetest/blob/master/doc/lua_api.txt
function telemosaic.extender_after_place(pos, placer, itemstack, pointed_thing)
	local positions = minetest.find_nodes_in_area_under_air(
		{x = pos.x - 3, y = pos.y, z = pos.z - 3},
		{x = pos.x + 3, y = pos.y, z = pos.z + 3},
		{"telemosaic:beacon_off", "telemosaic:beacon", "telemosaic:beacon_err"})
	local meta = minetest.get_meta(pos)
	local playername = placer:get_player_name()
	local nodename = itemstack:get_name()
	if not minetest.registered_nodes[nodename] then return end

	local description = minetest.registered_nodes[nodename]["description"]

	local power = telemosaic.extender_ranges[nodename]

	for i, bpos in ipairs(positions) do
		local bnode = minetest.get_node(bpos)
		local bmeta = minetest.get_meta(bpos)
		if not bnode then return end
		local bnodename = bnode.name
		if not minetest.registered_nodes[bnodename] then return end
		local bdescription = minetest.registered_nodes[bnodename]["description"]
		local bowner = bmeta:get_string("owner")
		local brange = bmeta:get_int("range")
		brange = brange + power
		bmeta:set_int("range", brange)
		telemosaic.set_status(bpos, placer)

		bmeta:set_string("infotext", bdescription.."\nowner: "..bowner.."\nrange: "..brange.." blocks\nright-click for more info")
	end

	meta:set_string("owner", playername)
	meta:set_string("infotext", description.."\nowner: "..playername)
end

--- Minetest "on_destruct" function
-- @see https://github.com/minetest/minetest/blob/master/doc/lua_api.txt
function telemosaic.extender_on_destruct(pos)
	local node = minetest.get_node(pos)
	if not node then return end
	local meta = minetest.get_meta(pos)
	local nodename = node.name
	if not minetest.registered_nodes[nodename] then return end
	local power = telemosaic.extender_ranges[nodename]
	local positions = minetest.find_nodes_in_area_under_air(
		{x = pos.x - 3, y = pos.y, z = pos.z - 3},
		{x = pos.x + 3, y = pos.y, z = pos.z + 3},
		{"telemosaic:beacon_off", "telemosaic:beacon", "telemosaic:beacon_err"})

	for i, bpos in ipairs(positions) do
		local bnode = minetest.get_node(bpos)
		local bmeta = minetest.get_meta(bpos)
		if not bmeta or not bnode then return end
		local bnodename = bnode.name
		if not minetest.registered_nodes[bnodename] then return end
		local bdescription = minetest.registered_nodes[bnodename]["description"]
		local bowner = bmeta:get_string("owner")
		local brange = bmeta:get_int("range")
		brange = brange - power
		if brange < 0 then brange = 0 end
		bmeta:set_int("range", brange)
		telemosaic.set_status(bpos)

		bmeta:set_string("infotext", bdescription.."\nowner: "..bowner.."\nrange: "..brange.." blocks\nright-click for more info")
	end
end

--
-- beacons
--

--- Finds extenders in the area under air, counts the range based on the found extenders power/strength
-- @param {table} be_pos - beacon position as a center point from where extenders will be searched
-- @returns {number} range - total power from found extenders
function telemosaic.get_range_from_extenders(be_pos)
	-- 7x1x7 area
	local positions = minetest.find_nodes_in_area_under_air(
		{x = be_pos.x - 3, y = be_pos.y, z = be_pos.z - 3},
		{x = be_pos.x + 3, y = be_pos.y, z = be_pos.z + 3},
		{"telemosaic:extender_one", "telemosaic:extender_two", "telemosaic:extender_three"})

	local range = 0

	for i, ex_pos in ipairs(positions) do
		local inode = minetest.get_node(ex_pos)
		if not inode then return end

		range = range + telemosaic.extender_ranges[inode.name]
	end

	return range
end

--- Manage state of the beacons, i.e. swap nodes and update metadata
-- @param {table} pos - beacon position of which the state should be managed
function telemosaic.set_status(pos)
	local meta = minetest.get_meta(pos)
	if not meta then return end
	local range = meta:get_int("range")
	local pos2 = meta:get_string("dest_pos")
	local state = meta:get_string("state")
	local arrivals_tbl = meta:get_string("arrivals_tbl")
	arrivals_tbl = minetest.deserialize(arrivals_tbl)
	if not arrivals_tbl then arrivals_tbl = {} end

	-- not enough energy (err)
	if range <= 0 and
		 state ~= "err" then
		minetest.swap_node(pos, { name = "telemosaic:beacon_err" })
		meta:set_string("state", "err")

	-- configured beacon (off)
	elseif range > 0 and
				 pos2 == "not configured" and
				 state ~= "off" and
				 #arrivals_tbl == 0 then
		minetest.swap_node(pos, { name = "telemosaic:beacon_off" })
		meta:set_string("state", "off")

	-- not configured beacon (on)
	elseif range > 0 and
				 pos2 ~= "not configured" and
				 state ~= "on" then
		minetest.swap_node(pos, { name = "telemosaic:beacon" })
		meta:set_string("state", "on")
	end
end

--- Minetest node "after_place_node" function
-- @see https://github.com/minetest/minetest/blob/master/doc/lua_api.txt
function telemosaic.beacon_after_place(pos, placer, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local nodename = itemstack:get_name()
	local playername = placer:get_player_name()
	local range = telemosaic.get_range_from_extenders(pos)
	if not minetest.registered_nodes[nodename] then return end

	local bname = "beacon at: "..minetest.pos_to_string(pos)

	local description = minetest.registered_nodes[nodename]["description"]
	meta:set_int("range", range)
	meta:set_string("bname", bname)
	meta:set_string("owner", playername)
	meta:set_string("state", "off")
	meta:set_string("dep_pos", "")
	meta:set_string("dest_pos", "not configured")
	meta:set_string("arrivals_tbl", "{}")
	meta:set_string("infotext", description.."\nowner: "..playername.."\nrange: "..range.." blocks\nright-click for more info")

	telemosaic.set_status(pos)
end

--- Minetest node "on_rightclick" function
-- @see https://github.com/minetest/minetest/blob/master/doc/lua_api.txt
function telemosaic.beacon_rightclick(pos, node, clicker, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local meta_stack = itemstack:get_meta()
	local ownername = meta:get_string("owner") or "unknown"
	local clickername = clicker:get_player_name()
	local nodename = node.name
	local stackname = itemstack:get_name()
	local range = telemosaic.get_range_from_extenders(pos)
	if not minetest.registered_nodes[nodename] then return end

	local description = minetest.registered_nodes[nodename]["description"]
	meta:set_int("range", range)

	-- departure
	if stackname == "default:mese_crystal_fragment" and itemstack:get_count() == 1 then
		itemstack:replace("telemosaic:key")

		local item_description = minetest.registered_items[itemstack:get_name()]["description"]
		-- remember departure position in the item meta
		meta_stack:set_string("dep_pos", minetest.pos_to_string(pos))
		meta_stack:set_string("description", item_description.."\nsaved position: "..minetest.pos_to_string(pos))

		meta:set_string("infotext", description.."\nowner: "..ownername.."\nrange: "..range.." blocks\nright-click for more info")

	-- destination
	elseif stackname == "telemosaic:key" then
		-- get deprature position from item meta
		local pos_stack = meta_stack:get_string("dep_pos")
		pos_stack = minetest.string_to_pos(pos_stack)
		if not pos_stack then return end
		local meta2 = minetest.get_meta(pos_stack)
		local range2 = meta2:get_int("range")

		-- do nothing if departure position is marked as arrival position
		if math.floor(vector.distance(pos_stack, pos)) == 0 then
			minetest.chat_send_player(clickername, "This is marked as your departure position, you have to mark your destination position now!")
			return
		-- too far, not enough range - keep the key
		elseif math.floor(vector.distance(pos_stack, pos)) > range2 then
			minetest.chat_send_player(clickername, "The destination is too far, place the beacon closer about "..math.floor(vector.distance(pos_stack, pos)) - range2.." blocks.")
			return
		-- do nothing when arrival position is protected
		elseif minetest.is_protected(pos, clickername) then
			minetest.chat_send_player(clickername, "You cannot configure protected beacons!")
			return
		end

		itemstack:replace("default:mese_crystal_fragment")

		-- remove this node position from arrival node "arrivals_tbl"
		local bname2 = meta2:get_string("bname")
		local pos3 = meta2:get_string("dest_pos")
		pos3 = minetest.string_to_pos(pos3)

		-- not for the node we just clicked though
		if pos3 and math.floor(vector.distance(pos3, pos)) ~= 0 then
			local meta3 = minetest.get_meta(pos3)
			local arrivals_tbl3 = meta3:get_string("arrivals_tbl")
			arrivals_tbl3 = minetest.deserialize(arrivals_tbl3)
			if not arrivals_tbl3 then arrivals_tbl3 = {} end
			arrivals_tbl3[minetest.pos_to_string(pos_stack)] = nil
			meta3:set_string('arrivals_tbl', arrivals_tbl3)
			telemosaic.set_status(pos3)
		end

		-- add arrival position to the arrival table list
		local arrivals_tbl = meta:get_string("arrivals_tbl")
		arrivals_tbl = minetest.deserialize(arrivals_tbl)
		if not arrivals_tbl then arrivals_tbl = {} end

		arrivals_tbl[minetest.pos_to_string(pos_stack)] = bname2

		arrivals_tbl = minetest.serialize(arrivals_tbl)
		meta2:set_string("dest_pos", minetest.pos_to_string(pos))
		meta:set_string("arrivals_tbl", arrivals_tbl)

		meta:set_string("infotext", description.."\nowner: "..ownername.."\nrange: "..range.." blocks\nright-click for more info")

		minetest.sound_play("telemosaic_set", {
			pos = pos,
			max_hear_distance = 8,
			gain = 1
		})

		telemosaic.set_status(pos_stack)

	-- default place_node callback
	-- elseif itemstack:get_definition().type == "node" then
	-- 	itemstack = minetest.item_place_node(itemstack, clicker, pointed_thing)
	else
		-- mod : pos : pos2
		-- - pos2 is from itemstack so not always set, else "not configured"
		local formspec = telemosaic.get_formspec(pos, {
			range = range
		})
		local pos2 = meta:get_string("dest_pos")
		minetest.show_formspec(clickername, "telemosaic:"..minetest.pos_to_string(pos)..":"..pos2, formspec)

		meta:set_string("infotext", description.."\nowner: "..ownername.."\nrange: "..range.." blocks\nright-click for more info")
	end
	return itemstack
end

--- Minetest node "on_destruct" function
-- @see https://github.com/minetest/minetest/blob/master/doc/lua_api.txt
function telemosaic.beacon_on_destruct(pos)
	local meta = minetest.get_meta(pos)
	local pos2 = meta:get_string("dest_pos")
	pos2 = minetest.string_to_pos(pos2)
	local arrivals_tbl = meta:get_string("arrivals_tbl")
	arrivals_tbl = minetest.deserialize(arrivals_tbl)
	if not arrivals_tbl then arrivals_tbl = {} end

	-- found destination position, will update the meta in destination
	if pos2 then
		local meta2 = minetest.get_meta(pos2)
		local arrivals_tbl2 = meta2:get_string("arrivals_tbl")
		arrivals_tbl2 = minetest.deserialize(arrivals_tbl2)
		if not arrivals_tbl2 then arrivals_tbl2 = {} end

		if arrivals_tbl2[minetest.pos_to_string(pos)] then
			arrivals_tbl2[minetest.pos_to_string(pos)] = nil
			arrivals_tbl2 = minetest.serialize(arrivals_tbl2)
			meta2:set_string("arrivals_tbl", arrivals_tbl2)
		end

		meta2:set_string("dest_pos", "not configured")
		telemosaic.set_status(pos2)
	end

	-- update meta in all arrivals list from this node
	for k, v in pairs(arrivals_tbl) do
		local ipos = minetest.string_to_pos(k)
		local imeta = minetest.get_meta(ipos)
		imeta:set_string("dest_pos", "not configured")
		telemosaic.set_status(ipos)
	end

end
