local colors = {
	["yellow"] = "#FFEB3B", -- info
	["green"] = "#4CAF50", -- success
	["red"] = "#f44336", -- error
	["cyan"] = "#00BCD4" -- terminal info
}

minetest.override_chatcommand("home", {
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_pos = player:get_pos()

		if not player then
			return false, minetest.colorize(colors.red, "Player not found.")
		end

		if minetest.global_exists("pvp_block") then
			if pvp_block:in_area(player_pos) then
				return false, minetest.colorize(colors.red, "You cannot do this in PvP arena.")
			end
		end

		if minetest.global_exists("sethome") then
			if sethome.go(name) then
				return true, minetest.colorize(colors.green, "Teleported to home!")
			end
			return false, minetest.colorize(colors.yellow, "Set a home using /sethome")
		end

		return false, minetest.colorize(colors.yellow, "Something went wrong, try again.")
	end
})

-- Spawn mod for Minetest
-- Originally written by VanessaE (I think), rewritten by cheapie
-- WTFPL

local spawn_spawnpos = minetest.setting_get_pos("static_spawnpoint")

minetest.register_chatcommand("spawn", {
	params = "",
	description = "Teleport to the spawn point.",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_pos = player:get_pos()

		if not player then
			return false, minetest.colorize(colors.red, "Player not found.")
		end

		if minetest.global_exists("pvp_block") then
			if pvp_block:in_area(player_pos) then
				return false, minetest.colorize(colors.red, "You cannot do this in PvP arena.")
			end
		end

		if spawn_spawnpos then
			-- prevent teleporting to spawn when already at spawn, or in jail at spawn
			if vector.distance(player_pos, spawn_spawnpos) < 48 then
				return false, minetest.colorize(colors.yellow, "You are already near the spawn, teleporting aborted.")
			end

			player:set_pos(spawn_spawnpos)
			return true, minetest.colorize(colors.green, "Teleporting to spawn..")
		else
			return false, minetest.colorize(colors.yellow, "The spawn point is not set!")
		end
	end,
})

minetest.register_chatcommand("setspawn", {
	params = "",
	description = "Sets the spawn point to your current position",
	privs = {server = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)

		if not player then
			return false, minetest.colorize(colors.red, "Player not found")
		end

		local pos = player:get_pos()
		local x = pos.x
		local y = pos.y + 1
		local z = pos.z
		local pos_string = x..","..y..","..z
		local pos_string_2 = "Setting spawn point to ("..x..", "..y..", "..z..")"

		minetest.settings:set("static_spawnpoint", pos_string)
		spawn_spawnpos = pos

		if minetest.settings:write() then
			return true, minetest.colorize(colors.yellow, pos_string_2)
		else
			return false, minetest.colorize(colors.red, "Something went wrong, the new spawn position was not saved in minetest.conf file.")
		end
	end,
})

-- Original code by Traxie21 and released with the WTFPL license
-- https://forum.minetest.net/viewtopic.php?id=4457
-- Updates by Zeno, ChaosWormz, SaKeL

local timeout_delay = 60
local version = "1.2"
local tpr_list = {}
local tphr_list = {}

-- Copied from Celeron-55"s /teleport command. Thanks Celeron!
local function find_free_position_near(pos)
	local tries = {
		{ x = 1, y = 0, z = 0 },
		{ x = -1, y = 0, z = 0 },
		{ x = 0, y = 0, z = 1 },
		{ x = 0, y = 0, z = -1 },
	}

	for _, d in ipairs(tries) do
		local p = { x = pos.x + d.x, y = pos.y + d.y, z = pos.z + d.z }
		local n = minetest.get_node(p)

		if not minetest.registered_nodes[n.name].walkable then
			return p, true
		end
	end

	return pos, false
end

minetest.register_chatcommand("tpr", {
	description = "Request teleport to another player.",
	params = "<player name> | leave playername empty to see help message",
	privs = { interact = true },
	func = function(name, param)
		local receiver = param

		if receiver == "" then
			return false, minetest.colorize(colors.yellow, "Usage: /tpr <player name>")
		end

		local player = minetest.get_player_by_name(name)
		local player_pos = player:get_pos()

		if minetest.global_exists("pvp_block") then
			if pvp_block:in_area(player_pos) then
				return false, minetest.colorize(colors.red, "You cannot do this in PvP arena.")
			end
		end

		-- If paremeter is valid, Send teleport message and set the table.
		if minetest.get_player_by_name(receiver) then
			minetest.chat_send_player(receiver, minetest.colorize(colors.yellow, name .." is requesting to teleport to you. /tpy to accept."))

			-- Write name values to list and clear old values.
			tpr_list[receiver] = name

			-- Teleport timeout delay
			minetest.after(timeout_delay, function(name, receiver)
				if tpr_list[name] ~= nil then
					tpr_list[name] = nil

					-- if name and receiver then
					-- 	minetest.chat_send_player(name, minetest.colorize(colors.yellow, "Teleport request to "..receiver.." timed out."))
					-- 	minetest.chat_send_player(receiver, minetest.colorize(colors.yellow, "Teleport request from "..name.." timed out."))
					-- end
				end

			end, name, receiver)

			return true, minetest.colorize(colors.green, "Teleport request sent! It will time out in ".. timeout_delay .." seconds.")
		end

		return false, minetest.colorize(colors.red, "Player not found.")
	end
})

minetest.register_chatcommand("tphr", {
	description = "Request player to teleport to you.",
	params = "<player name> | leave playername empty to see help message",
	privs = { interact = true },
	func = function(name, param)
		local receiver = param

		if receiver == "" then
			return false, minetest.colorize(colors.red, "Usage: /tphr <player name>")
		end

		-- If paremeter is valid, Send teleport message and set the table.
		if minetest.get_player_by_name(receiver) then
			minetest.chat_send_player(receiver, minetest.colorize(colors.yellow, name .." is requesting that you teleport to them. /tpy to accept; /tpn to deny"))

			-- Write name values to list and clear old values.
			tphr_list[receiver] = name

			-- Teleport timeout delay
			minetest.after(timeout_delay, function(name)
				if tphr_list[name] ~= nil then
					tphr_list[name] = nil

					-- if name and receiver then
					-- 	minetest.chat_send_player(name, minetest.colorize(colors.yellow, "Teleport request to "..receiver.." timed out."))
					-- 	minetest.chat_send_player(receiver, minetest.colorize(colors.yellow, "Teleport request from "..name.." timed out."))
					-- end
				end

			end, name, receiver)

			return true, minetest.colorize(colors.green, "Teleport request sent! It will time out in ".. timeout_delay .." seconds.")
		end

		return false, minetest.colorize(colors.red, "Player not found.")
	end,
})

minetest.register_chatcommand("tpy", {
	description = "Accept teleport requests from another player",
	func = function(name, param)
		-- Check to prevent constant teleporting.
		if tpr_list[name] == nil and tphr_list[name] == nil then
			return false, minetest.colorize(colors.green, "Usage: /tpy allows you to accept teleport requests sent to you by other players")
		end

		local chatmsg
		local source = nil
		local target = nil
		local name2

		if tpr_list[name] then
			name2 = tpr_list[name]
			source = minetest.get_player_by_name(name)
			target = minetest.get_player_by_name(name2)
			chatmsg = name2 .. " is teleporting to you."
			tpr_list[name] = nil

		elseif tphr_list[name] then
			name2 = tphr_list[name]
			source = minetest.get_player_by_name(name2)
			target = minetest.get_player_by_name(name)
			chatmsg = "You are teleporting to " .. name2 .. "."
			tphr_list[name] = nil

		else
			return false
		end

		-- Could happen if either player disconnects (or timeout); if so just abort
		if source == nil or target == nil then
			return false, minetest.colorize(colors.red, "Player not found.")
		end

		minetest.chat_send_player(name2, minetest.colorize(colors.green, "Request Accepted!"))

		local p = source:getpos()
		local p = find_free_position_near(p)
		target:setpos(p)

		return true, minetest.colorize(colors.green, chatmsg)
	end,
})

minetest.register_chatcommand("tpn", {
	description = "Deny teleport requests from another player.",
	func = function(name, param)
		if tpr_list[name] ~= nil then
			tpr_list[name] = nil
			return true, minetest.colorize(colors.red, "Teleport request denied.")
		end

		if tphr_list[name] ~= nil then
			tphr_list[name] = nil
			return true, minetest.colorize(colors.red, "Teleport request denied.")
		end

		return false
	end,
})
