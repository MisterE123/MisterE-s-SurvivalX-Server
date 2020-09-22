local path = minetest.get_modpath("pvp_block")

dofile(path.."/api.lua")
dofile(path.."/nodes.lua")

pvp_block:load()

print("Mod: PvP Block Loaded.")
