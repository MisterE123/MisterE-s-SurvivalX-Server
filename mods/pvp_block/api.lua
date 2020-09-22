pvp_block = {}
pvp_block.blocks = {}
pvp_block.set_pos = {}
pvp_block.pos0 = {}
pvp_block.pos1 = {}
pvp_block.pos2 = {}
pvp_block.marker1 = {}
pvp_block.marker2 = {}
pvp_block.filename = minetest.get_worldpath() .. "/pvp_blocks.txt"

function pvp_block:save()
	local datastring = minetest.serialize(self.blocks)
	if not datastring then
		return
	end
	local file, err = io.open(self.filename, "w")
	if err then
		return
	end
	file:write(datastring)
	file:close()
end

function pvp_block:load()
	local file, err = io.open(self.filename, "r")
	if err then
		self.blocks = {}
		return
	end
	self.blocks = minetest.deserialize(file:read("*all"))
	if type(self.blocks) ~= "table" then
		self.blocks = {}
	end
	file:close()
end

function pvp_block:in_area(pos)
	local pos0 = vector.round(pos)
	for i, block in ipairs(self.blocks) do
		local pos1 = block.pos1
		local pos2 = block.pos2

		if not pos1 or not pos2 then
			return
		end

		-- print("pos: ", dump(pos0))
		-- print("pos1: ", dump(pos1))
		-- print("pos2: ", dump(pos2))

		if (pos0.x >= pos1.x and pos0.x <= pos2.x) and
			 (pos0.y >= pos1.y and pos0.y <= pos2.y) and
			 (pos0.z >= pos1.z and pos0.z <= pos2.z) then
			 return true
		end
	end
	return false
end

minetest.register_on_punchnode(function(pos, node, puncher)
	local pname = puncher:get_player_name()
	if not pname or pname == "" then
		return
	end
	if pvp_block.set_pos[pname] == "pos1" then
		pvp_block.pos1[pname] = pos
		pvp_block.mark_pos1(pname)
		pvp_block.set_pos[pname] = "pos2"
		minetest.chat_send_player(pname, "--- Position 1 set to "..minetest.pos_to_string(pos))
	elseif pvp_block.set_pos[pname] == "pos2" then
		pvp_block.pos2[pname] = pos
		pvp_block.mark_pos2(pname)
		pvp_block.set_pos[pname] = nil
		minetest.chat_send_player(pname, "--- Position 2 set to "..minetest.pos_to_string(pos))
		-- save positions to file
		for i, block in ipairs(pvp_block.blocks) do
			if vector.equals(pvp_block.pos0[pname], block.pos) then
				-- print("block: ", dump(block.pos))
				-- print("pos0: ", dump(pvp_block.pos0[pname]))
				local pos1, pos2 = vector.sort(pvp_block.pos1[pname], pvp_block.pos2[pname])

				pvp_block.blocks[i].pos1 = pos1
				pvp_block.blocks[i].pos2 = pos2
				pvp_block:save()
				break
			end
		end
	end
end)

-- marks region position 1
pvp_block.mark_pos1 = function(pname)
	local pos1, pos2 = pvp_block.pos1[pname], pvp_block.pos2[pname]

	if pos1 ~= nil then
		-- make area stay loaded
		local manip = minetest.get_voxel_manip()
		manip:read_from_map(pos1, pos1)
	end
	if pvp_block.marker1[pname] ~= nil then -- marker already exists
		pvp_block.marker1[pname]:remove() -- remove marker
		pvp_block.marker1[pname] = nil
	end
	if pos1 ~= nil then
		-- add marker
		pvp_block.marker1[pname] = minetest.add_entity(pos1, "pvp_block:pos1")
		if pvp_block.marker1[pname] ~= nil then
			pvp_block.marker1[pname]:get_luaentity().player_name = pname
		end
	end
end

-- marks region position 2
pvp_block.mark_pos2 = function(pname)
	local pos1, pos2 = pvp_block.pos1[pname], pvp_block.pos2[pname]

	if pos2 ~= nil then
		-- make area stay loaded
		local manip = minetest.get_voxel_manip()
		manip:read_from_map(pos2, pos2)
	end
	if pvp_block.marker2[pname] ~= nil then -- marker already exists
		pvp_block.marker2[pname]:remove() -- remove marker
		pvp_block.marker2[pname] = nil
	end
	if pos2 ~= nil then
		-- add marker
		pvp_block.marker2[pname] = minetest.add_entity(pos2, "pvp_block:pos2")
		if pvp_block.marker2[pname] ~= nil then
			pvp_block.marker2[pname]:get_luaentity().player_name = pname
		end
	end
end

function pvp_block.drop_inventory(pos, player)
	-- local pname = player:get_player_name()
	-- local name = hitter:get_player_name()
	local player_inv = player:get_inventory()
	pos.y = pos.y + 1

	if player_inv then
		-- drop items
		local obj

		for i = 1, player_inv:get_size("main") do
			obj = minetest.add_item(pos, player_inv:get_stack("main", i))
			if obj and obj:get_luaentity() then
				obj:setvelocity({
					x = math.random(-15, 15) / 9,
					y = 6,
					z = math.random(-15, 15) / 9,
				})
			end
		end

		for i = 1, player_inv:get_size("craft") do
			obj = minetest.add_item(pos, player_inv:get_stack("craft", i))
			if obj and obj:get_luaentity() then
				obj:setvelocity({
					x = math.random(-15, 15) / 9,
					y = 6,
					z = math.random(-15, 15) / 9,
				})
			end
		end

		-- empty lists main and craft
		player_inv:set_list("main", {})
		player_inv:set_list("craft", {})
	end
	-- hitter:set_pos( {x=50, y=15.5, z=117} )

	-- minetest.chat_send_all("Player "..name.." sent to jail for killing " .. pname .." without reason in town")
	-- minetest.log("action", "Player "..name.." warned for killing in town")
end

function pvp_block.register_on_punchplayer(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	if not player or not hitter then
		return
	end
	if not player:is_player() or not hitter:is_player() then
		return
	end

	local hp = player:get_hp()
	local pos = player:get_pos()
	-- local nametag_attr = player:get_nametag_attributes()
	-- print("in_area: ", dump(pvp_block:in_area(pos)))
	-- print("hp: ", hp)
	-- print("damage: ", damage)
	-- print("new hp: ", hp - damage)
	-- if hp < 20 then
	-- 	player:set_nametag_attributes({color = {a = 0, r = 255, g = 255, b = 255}})
	-- else
	-- 	player:set_nametag_attributes({color = {a = 255, r = 255, g = 255, b = 255}})
	-- end
	if hp > 0 and (hp - damage) <= 0 then
		if pvp_block:in_area(pos) then
			pvp_block.drop_inventory(pos, player)
		end
	end
end

minetest.register_on_punchplayer(pvp_block.register_on_punchplayer)

-- die player - water, lava..
minetest.register_on_dieplayer(function(player)
	if not player then
		return
	end
	if not player:is_player() then
		return
	end

	local hp = player:get_hp()
	local pos = player:get_pos()

	if pvp_block:in_area(pos) then
		pvp_block.drop_inventory(pos, player)
	end
end)

-- protection
local old_is_protected = minetest.is_protected
function minetest.is_protected(pos, name)
	if pvp_block:in_area(pos) then
		return true
	end
	return old_is_protected(pos, name)
end
