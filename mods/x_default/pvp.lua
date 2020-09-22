--[[
	Manage where and when is PVP enabled
--]]

x_default.disable_areas = true
x_default.disable_protector = true
-- x_default.pvp_night_only = true

-- should return 'true' to prevent the default damage mechanism
minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)

	if not player
	or not hitter then
		print("[x_default] on_punchplayer called with nil objects")
	end

	local player_pos = player:get_pos()
	local hitter_pos = hitter:get_pos()

	--
	-- Player
	--
	if hitter:is_player() then
		-- do we enable pvp at night time only ?
		-- if x_default.pvp_night_only then
		-- 	-- get time of day
		-- 	local tod = minetest.get_timeofday() or 0

		-- 	if tod > 0.2 and tod < 0.8 then
		-- 		--
		-- 	else
		-- 		return false
		-- 	end
		-- end

		-- no damage inside areas
		if x_default.disable_areas then
			if minetest.global_exists("areas") then
				if #areas:getNodeOwners(player_pos) > 0 and not pvp_block:in_area(player_pos) then
					-- print("player in areas")
					return true
				end
			end
		end

		local player_can_dig, player_is_pvp = protector.can_dig(5, player_pos, hitter:get_player_name(), true, 1)
		local hitter_can_dig, hitter_is_pvp = protector.can_dig(5, hitter_pos, player:get_player_name(), true, 1)

		-- local both_in_pvp = player_is_pvp == true and hitter_is_pvp == true
		local both_out_pvp = player_is_pvp == false and hitter_is_pvp == false

		if x_default.disable_protector then
			-- no damage if in protected area (e.g. protector redo)
			if minetest.is_protected(player_pos, "") and
				 minetest.is_protected(hitter_pos, "") and
				 not pvp_block:in_area(player_pos) and
				 both_out_pvp then
				-- print("#1 player in protector")
				return true
			end
		end

		return false

	--
	-- Entity
	-- for entities we have special handling with whitelist - will be useful in the future with custom logic
	--
	else
		local ent = hitter:get_luaentity()

		if not ent then
			return false
		end

		local ent_blacklist = {
			["obsidianmese:sword_bullet"] = true,
			["throwing:arrow_obsidian_entity"] = true,
			["throwing:arrow_steel_entity"] = true,
			["throwing:arrow_stone_entity"] = true,
			["throwing:arrow_diamond_entity"] = true,
			["basic_machines:ball"] = true
		}

		-- print("------")
		-- print(ent.name)
		-- print("------")

		-- no damage inside areas
		if x_default.disable_areas then
			if minetest.global_exists("areas") then
				if #areas:getNodeOwners(player_pos) > 0 and not pvp_block:in_area(player_pos) then
					-- print("player in areas")
					if ent_blacklist[ent.name] then
						-- print("player not hurt")
						return true
					end
				end
			end
		end

		local can_dig, is_pvp = protector.can_dig(5, player_pos, "", true, 1)

		-- no damage if in protected area (e.g. protector redo)
		if minetest.is_protected(player_pos, "") and not (pvp_block:in_area(player_pos) or is_pvp) then
			-- print("player in protector")
			if ent_blacklist[ent.name] then
				-- print("player not hurt")
				return true
			end
		end

		return false
	end

end)
