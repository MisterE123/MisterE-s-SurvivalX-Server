local S = protector.intllib
local radius = (tonumber(minetest.settings:get("protector_radius")) or 5)
local hud = {}
local hud_timer = 0

minetest.register_globalstep(function(dtime)

	-- every 5 seconds
	hud_timer = hud_timer + dtime
	if hud_timer < 5 then
		return
	end
	hud_timer = 0

	for _, player in pairs(minetest.get_connected_players()) do

		local name = player:get_player_name()
		local pos = vector.round(player:get_pos())
		local hud_text = ""
		local hud_text_color = 0xFFFF22; -- lemon yellow

		local protectors = minetest.find_nodes_in_area(
			{x = pos.x - radius , y = pos.y - radius , z = pos.z - radius},
			{x = pos.x + radius , y = pos.y + radius , z = pos.z + radius},
			{"protector:protect","protector:protect2","protector:protect_pvp","protector:protect2_pvp"})

		if #protectors > 0 then
			local npos = protectors[1]
			local meta = minetest.get_meta(npos)
			local is_pvp = meta:get_int("is_pvp")

			if not is_pvp then
				is_pvp = 0
			end

			if is_pvp == 1 then
				hud_text_color = 0xFF0022 -- torch red
			else
				hud_text_color = 0xFFFF22 -- lemon yellow
			end

			local nodeowner = meta:get_string("owner")

			if is_pvp == 1 then
				hud_text = S("Owner: @1", nodeowner) .. " (PvP Enabled)"
			else
				hud_text = S("Owner: @1", nodeowner)
			end
		end

		if not hud[name] then

			hud[name] = {}

			hud[name].id = player:hud_add({
				hud_elem_type = "text",
				name = "Protector Area",
				number = hud_text_color,
				position = {x=0, y=0.95},
				offset = {x=8, y=-8},
				text = hud_text,
				scale = {x=200, y=60},
				alignment = {x=1, y=-1},
			})

			return

		else

			player:hud_change(hud[name].id, "text", hud_text)
			player:hud_change(hud[name].id, "number", hud_text_color)
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	hud[player:get_player_name()] = nil
end)
