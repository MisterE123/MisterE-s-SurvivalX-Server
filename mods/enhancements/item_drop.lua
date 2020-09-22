--basic settings
item_drop_settings                       = {} --settings table
item_drop_settings.radius_magnet         = 2.5 --radius of item magnet
item_drop_settings.radius_collect        = 0.4 --radius of collection
item_drop_settings.player_collect_height = 1.5 --added to their pos y value
local delay = 0
local timer = 0

local sneak = {}

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	sneak[player_name] = false
end)

minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	sneak[player_name] = nil
end)

minetest.register_globalstep(function(dtime)
	timer = timer + dtime

	-- every 1 second
	if timer >= 1 then
		for _, player in ipairs(minetest.get_connected_players()) do
			local control = player:get_player_control()
			local player_hp = player:get_hp()
			local player_name = player:get_player_name()

			if control.sneak and (player_hp > 0 or not minetest.settings:get_bool("enable_damage")) then

				-- [Shift + E + Q] single drop item
				-- autopickup after delay
				if control.aux1 then
					delay = 3
				end

				if delay > 0 then
					minetest.after(delay, function()
						delay = 0
					end)
					return
				else
					pick_dropped_items(player)
				end

			end

			-- hide nametag when sneaking
			if control.sneak ~= sneak[player_name] then
				if control.sneak and player_hp > 0 then
					local nametag_tbl = player:get_nametag_attributes()
					nametag_tbl.color.a = 0
					player:set_nametag_attributes(nametag_tbl)
					player:set_properties{makes_footstep_sound = false}
				else
					local nametag_tbl = player:get_nametag_attributes()
					nametag_tbl.color.a = 255
					player:set_nametag_attributes(nametag_tbl)
					player:set_properties{makes_footstep_sound = true}
				end
				sneak[player_name] = control.sneak
			end
		end

		timer = 0
	end
end)

function pick_dropped_items(player)
	local pos = player:getpos()
	local inv = player:get_inventory()

	--collection
	for _,object in ipairs(minetest.get_objects_inside_radius({x=pos.x,y=pos.y + item_drop_settings.player_collect_height,z=pos.z}, item_drop_settings.radius_collect)) do
		if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
			if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
				inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
				if object:get_luaentity().itemstring ~= "" then
					minetest.sound_play("item_drop_pickup", {
						pos = pos,
						max_hear_distance = 16,
						gain = 0.4,
					})
				end
				object:get_luaentity().itemstring = ""
				object:remove()
			end
		end
	end

	--magnet
	for _,object in ipairs(minetest.get_objects_inside_radius({x=pos.x,y=pos.y + item_drop_settings.player_collect_height,z=pos.z}, item_drop_settings.radius_magnet)) do
		if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then

			object:get_luaentity().collect = true

			if object:get_luaentity().collect then
				if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then

					local pos1 = pos
					pos1.y = pos1.y+0.2
					local pos2 = object:getpos()
					local vec = {x=pos1.x-pos2.x, y=(pos1.y+item_drop_settings.player_collect_height)-pos2.y, z=pos1.z-pos2.z}

					vec.x = pos2.x + vec.x
					vec.y = pos2.y + vec.y
					vec.z = pos2.z + vec.z
					object:moveto(vec)

					object:get_luaentity().physical_state = false
					object:get_luaentity().object:set_properties({
						physical = false
					})

					object:setacceleration({x=0, y=0, z=0})
					object:setvelocity({x=0, y=0, z=0})

					--fix eternally falling items
					minetest.after(0, function()
						object:setacceleration({x=0, y=0, z=0})
						object:setvelocity({x=0, y=0, z=0})
					end)

					minetest.after(1, function(args)
						local lua = object:get_luaentity()
						if object == nil or lua == nil or lua.itemstring == nil then
							return
						end
						if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
							inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
							if object:get_luaentity().itemstring ~= "" then
								minetest.sound_play("item_drop_pickup", {
									pos = pos,
									max_hear_distance = 100,
									gain = 0.4,
								})
							end
							object:get_luaentity().itemstring = ""
							object:remove()
						else
							object:setvelocity({x=0,y=0,z=0})
							object:get_luaentity().physical_state = true
							object:get_luaentity().object:set_properties({
								physical = true
							})
						end
					end, {player, object})

				end
			end
		end
	end
end
