MOD_NAME = minetest.get_current_modname()

dofile(minetest.get_modpath(MOD_NAME).."/api.lua")
dofile(minetest.get_modpath(MOD_NAME).."/nodes.lua")
dofile(minetest.get_modpath(MOD_NAME).."/crafting.lua")

print ("[Mod] Telemosaic Loaded.")
