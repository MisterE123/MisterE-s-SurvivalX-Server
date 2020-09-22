-- main settings
-- dofile(minetest.get_modpath("enhancements").."/settings.txt")
local TOOLS_ENHANCE = true
local CLEAN_UNKNOWN = false
local EXTERNAL_CMD = true
local PLAYER_AFK = false
local SPAWN_POINT = true
local ITEM_DROP = true
local TP_REQUEST = true
local PLAYER_ANIM = false
local AREAS_ENHANCE = false


defaultx = {}

--
-- tools enhancements
--
if TOOLS_ENHANCE then
	dofile(minetest.get_modpath("enhancements").."/swords.lua")
	dofile(minetest.get_modpath("enhancements").."/axe.lua")
	dofile(minetest.get_modpath("enhancements").."/shovels.lua")
	-- dofile(minetest.get_modpath("enhancements").."/pickaxe.lua")

	print("[Mod][enhancements] TOOLS_ENHANCE enabled")
end

--
-- clean-up unknown nodes and entities (configuration in that file)
--
if CLEAN_UNKNOWN then
	dofile(minetest.get_modpath("enhancements").."/clean_unknown.lua")

	print("[Mod][enhancements] CLEAN_UNKNOWN enabled")
end

--
-- allow external command from outside of minetest (see readme)
--
if EXTERNAL_CMD then
	dofile(minetest.get_modpath("enhancements").."/external_cmd.lua")

	print("[Mod][enhancements] EXTERNAL_CMD enabled")
end

--
-- detect AFK players
--
if PLAYER_AFK then
	dofile(minetest.get_modpath("enhancements").."/afk.lua")

	print("[Mod][enhancements] PLAYER_AFK enabled")
end

--
-- go to and set SPAWN_POINT
--
if SPAWN_POINT then
	dofile(minetest.get_modpath("enhancements").."/spawn.lua")

	print("[Mod][enhancements] SPAWN_POINT enabled")
end

--
-- pick dropped items by holding shift (sneak)
--
if ITEM_DROP then
	dofile(minetest.get_modpath("enhancements").."/item_drop.lua")

	print("[Mod][enhancements] ITEM_DROP enabled")
end

--
-- teleport request to/from another player
--
if TP_REQUEST then
	dofile(minetest.get_modpath("enhancements").."/teleport_request.lua")

	print("[Mod][enhancements] TP_REQUEST enabled")
end

-- manage privileges i areas mod - if using areas mod only for admin purposes
-- WIP DON'T ENABLE!
if AREAS_ENHANCE and minetest.get_modpath("areas") then
	dofile(minetest.get_modpath("enhancements").."/areas.lua")

	print("[Mod][enhancements] AREAS_ENHANCE enabled")
end

minetest.register_craft({
	type = "shapeless",
	output = "default:bronze_ingot",
	recipe = {"default:steel_ingot", "default:copper_ingot"},
})
