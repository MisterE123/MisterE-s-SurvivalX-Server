-- Minetest Survival X mod: default
-- See README.txt for licensing and other information.

-- Definitions made by this mod that other mods can use too

x_default = {}
x_default.storage = minetest.get_mod_storage()

-- Load files
local default_path = minetest.get_modpath("x_default")

dofile(default_path.."/functions.lua")
dofile(default_path.."/trees.lua")
dofile(default_path.."/nodes.lua")
dofile(default_path.."/tools.lua")
dofile(default_path.."/treasure_chest_list.lua")
dofile(default_path.."/chests.lua")
dofile(default_path.."/craftitems.lua")
dofile(default_path.."/crafting.lua")
dofile(default_path.."/pvp.lua")
dofile(default_path.."/item_drop.lua")
dofile(default_path.."/chatcommands.lua")
dofile(default_path.."/mapgen.lua")
-- dofile(default_path.."/clean_unknown.lua")

x_default:sync_treasure_chests_storage()