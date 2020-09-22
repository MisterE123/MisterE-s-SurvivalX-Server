-- Simple Skins mod for minetest
-- Adds a simple skin selector to the inventory by using unified_inventory
-- Released by TenPlus1, modified by SaKeL and based on Zeg9's code under MIT license

skins = {}
skins.skins = {}
skins.modpath = minetest.get_modpath("simple_skins")
skins.sfinv = minetest.get_modpath("sfinv")


-- Load support for intllib

local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")


-- Load player-selectable skin list

skins.list = {}

local id = 1
local f
while true do
	f = io.open(skins.modpath.."/textures/character_"..id..".png")
	if not f then break end
	f:close()
	table.insert(skins.list, "character_"..id)
	id = id + 1
end
-- skins.list[id] = nil
id = id - 1

-- Load Metadata

skins.meta = {}
local f, data
for _, i in pairs(skins.list) do
	skins.meta[i] = {}
	f = io.open(skins.modpath.."/meta/"..i..".txt")
	data = nil
	if f then
		data = minetest.deserialize("return {"..f:read('*all').."}")
		f:close()
	end
	data = data or {}
	skins.meta[i].name = data.name or ""
	skins.meta[i].author = data.author or ""
end


-- Load player skins from file for backwards compatibility

skins.file = minetest.get_worldpath().."/simple_skins.mt"

local input = io.open(skins.file, "r")
local data = nil
if input then
	data = input:read('*all')
	io.close(input)
end
if data and data ~= "" then
	local lines = string.split(data, "\n")
	for _, line in pairs(lines) do
		data = string.split(line, " ", 2)
		skins.skins[data[1]] = data[2]
	end
end


-- Skin selection page
local textlist_cache = ""
skins.formspec = {}
skins.formspec.main = function(name, idx)
	local meta
	local selected = idx
	local label_name = "unknown"
	local label_author = "unknown"

	-- loop through the whole list
	if not selected then
		selected = 1
		textlist_cache = ""

		for i = 1, #skins.list do
			-- no comma for the last one
			if i == #skins.list then
				textlist_cache = textlist_cache..i.." - "..minetest.formspec_escape(skins.meta[skins.list[i]].name)
			else
				textlist_cache = textlist_cache..i.." - "..minetest.formspec_escape(skins.meta[skins.list[i]].name)..","
			end

			if skins.skins[name] == skins.list[i] then
				selected = i
				meta = skins.meta[skins.skins[name]]
			end
		end

		if meta then
			if meta.name then
				label_name = minetest.formspec_escape(meta.name)
			end
			if meta.author then
				label_author = minetest.formspec_escape(meta.author)
			end
		end
	else
	-- do not loop, take the cached textlist
		label_name = minetest.formspec_escape(skins.meta["character_"..selected].name)
		label_author = minetest.formspec_escape(skins.meta["character_"..selected].author)
	end

	local formspec = "size[6.0,8.6]"..
		"position[0.05,0.5]"..
		"anchor[0.0,0.5]"..
		"bgcolor[#00000000;false]"..
		"background[5,5;1,1;gui_formbg.png;true]"..
		"label[0.0,1.0;Tip: Switch to 3rd person view to see the skin appearance (F7)]"..
		"label[0.0,1.5;"..S("Select Player Skin:").."]"..
		"button_exit[1.75,7.7;2.4,1.5;simple_skins:saveandclose;Save & Close]"..
		"label[0.0,0.0;"..S("Name: ")..label_name.."]"..
		"label[0.0,0.5;"..S("Author: ")..label_author.."]"..
		"textlist[0.0,2.0;5.8,5.7;skins_set;"..textlist_cache..";"..selected..";false]"

	return formspec
end


-- Update player skin

skins.update_player_skin = function(player)
	if not player then
		return
	end

	local name = player:get_player_name()
	player:set_properties({
		textures = {skins.skins[name]..".png"},
	})
	player:set_attribute("simple_skins:skin", skins.skins[name])
end


-- Load player skin on player join

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	-- Do we already have a skin in player attributes?
	local skin = player:get_attribute("simple_skins:skin")
	if skin then
		skins.skins[name] = skin
	else
		-- If no skin found use default
		skins.skins[name] = "character_1"
	end
	skins.update_player_skin(player)
end)


-- Formspec control

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	local event = minetest.explode_textlist_event(fields["skins_set"])

	-- print("fields: ", dump(fields))
	-- print("event: ", dump(event))
	-- print("formname: ", formname)

	if event.type == "INV" then
		-- print(unified_inventory.current_page[name])
		if unified_inventory.current_page[name] == "simple_skins" then
			unified_inventory.set_inventory_formspec(player, "craft")
		else
			unified_inventory.set_inventory_formspec(player, unified_inventory.current_page[name])
		end
	end

	if fields.simple_skins or fields.skins_set then

		if event.type == "CHG" then
			local index = event.index
			if index > id then
				index = id
			end

			skins.skins[name] = skins.list[index]
			skins.update_player_skin(player)

			minetest.show_formspec(name, "simple_skins:formspec", skins.formspec.main(name, index))
		else
			minetest.show_formspec(name, "simple_skins:formspec", skins.formspec.main(name, nil))
		end
	end
end)

unified_inventory.register_button("simple_skins", {
	type = "image",
	image = "inventory_plus_skins.png",
	tooltip = "Change player skin"
})

print (S("[Mod] Simple Skins Loaded."))
