-- 
-- Manage players privileges in 'areas' mod if using the mod only for admin purposes
-- 

-- TODO:
-- - create tables from where you can read/write the privileges
-- - don't repeat grand/revoke on globalstep - only once when in/out of area - check within tables!

minetest.register_globalstep(function(dtime)
	for _, player in pairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local pos = vector.round(player:getpos())
		local privs = minetest.get_player_privs(name)

		if not privs then
			print("[Mod][enhancements-areas] player does not exist error!")
		end

		if areas:canInteract(pos, name) then
			print("grant")
		else
			print("revoke")
		end
	end
end)