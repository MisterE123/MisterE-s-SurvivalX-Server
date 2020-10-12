
epic_skybox = {
  -- list<skyboxdef>
  list = {}
}

local MP = minetest.get_modpath("epic_skybox")

dofile(MP.."/alias.lua")
dofile(MP.."/register.lua")
dofile(MP.."/skyboxes.lua")
dofile(MP.."/functions.lua")
dofile(MP.."/chatcommands.lua")
dofile(MP.."/epic_block.lua")
