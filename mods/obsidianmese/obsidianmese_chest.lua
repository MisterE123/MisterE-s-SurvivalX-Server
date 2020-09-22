function obsidianmese.get_chest_formspec()
	local formspec =
		"size[8,9]"..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"list[current_player;obsidianmese:chest;0,0.3;8,4;]"..
		"list[current_player;main;0,4.85;8,1;]" ..
		"list[current_player;main;0,6.08;8,3;8]" ..
		"listring[current_player;obsidianmese:chest]" ..
		"listring[current_player;main]" ..
		default.get_hotbar_bg(0,4.85)
	return formspec
end

local function chest_lid_obstructed(pos)
	local above = {x = pos.x, y = pos.y + 1, z = pos.z}
	local def = minetest.registered_nodes[minetest.get_node(above).name]
	-- allow ladders, signs, wallmounted things and torches to not obstruct
	if def and
			(def.drawtype == "airlike" or
			def.drawtype == "signlike" or
			def.drawtype == "torchlike" or
			(def.drawtype == "nodebox" and def.paramtype2 == "wallmounted")) then
		return false
	end
	return true
end

local open_chests = {}

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if not player or not fields.quit then
		return
	end
	local pn = player:get_player_name()

	if not open_chests[pn] then
		return
	end

	local pos = open_chests[pn].pos
	local sound = open_chests[pn].sound
	local swap = open_chests[pn].swap
	local node = minetest.get_node(pos)

	open_chests[pn] = nil
	for k, v in pairs(open_chests) do
		if v.pos.x == pos.x and v.pos.y == pos.y and v.pos.z == pos.z then
			return true
		end
	end
	minetest.after(0.2, minetest.swap_node, pos, { name = "obsidianmese:" .. swap,
			param2 = node.param2 })
	minetest.sound_play(sound, {gain = 0.3, pos = pos, max_hear_distance = 10})
	return true
end)

function obsidianmese.register_chest(name, d)
	local def = table.copy(d)
	def.drawtype = "mesh"
	def.visual = "mesh"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.legacy_facedir_simple = true
	def.is_ground_content = false

	def.on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Obsidian Mese Chest")
		-- add particles
		local id_effect = obsidianmese.add_effects(pos)
		meta:set_int("id_effect", id_effect)
		minetest.get_node_timer(pos):start(20)
	end
	def.on_destruct = function(pos)
		-- delete particles
		local meta = minetest.get_meta(pos)
		local id_effect = meta:get_int("id_effect")

		if id_effect and id_effect ~= -1 then
			minetest.delete_particlespawner(id_effect)
		end
	end
	def.on_rightclick = function(pos, node, clicker)
		minetest.sound_play(def.sound_open, {gain = 0.3, pos = pos,
				max_hear_distance = 10})
		if not chest_lid_obstructed(pos) then
			minetest.swap_node(pos, {
					name = "obsidianmese:" .. name .. "_open",
					param2 = node.param2 })
		end
		minetest.after(0.2, minetest.show_formspec,
				clicker:get_player_name(),
				"obsidianmese:chest", obsidianmese.get_chest_formspec(pos))
		open_chests[clicker:get_player_name()] = { pos = pos,
				sound = def.sound_close, swap = name }
	end
	def.on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local id_effect = meta:get_int("id_effect")
		local player_near = obsidianmese.check_around_radius(pos)

		-- delete particles
		if id_effect and id_effect ~= -1 and not player_near then
			minetest.delete_particlespawner(id_effect)
			meta:set_int("id_effect", -1)
			id_effect = -1
		end

		-- add particles
		if player_near then
			-- delete particles before adding new ones
			if id_effect and id_effect ~= -1 then
				minetest.delete_particlespawner(id_effect)
			end

			id_effect = obsidianmese.add_effects(pos)
			meta:set_int("id_effect", id_effect)
		end
		minetest.get_node_timer(pos):start(20)
	end

	def.on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		minetest.log("action", player:get_player_name() ..
			" moves stuff in chest at " .. minetest.pos_to_string(pos))
	end
	def.on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" moves " .. stack:get_name() ..
			" to chest at " .. minetest.pos_to_string(pos))
	end
	def.on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" takes " .. stack:get_name() ..
			" from chest at " .. minetest.pos_to_string(pos))
	end
	def.on_blast = function() end

	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_opened.mesh = "chest_open.obj"
	for i = 1, #def_opened.tiles do
		if type(def_opened.tiles[i]) == "string" then
			def_opened.tiles[i] = {name = def_opened.tiles[i], backface_culling = true}
		elseif def_opened.tiles[i].backface_culling == nil then
			def_opened.tiles[i].backface_culling = true
		end
	end
	def_opened.drop = "obsidianmese:" .. name
	def_opened.groups.not_in_creative_inventory = 1
	def_opened.selection_box = {
		type = "fixed",
		fixed = { -1/2, -1/2, -1/2, 1/2, 3/16, 1/2 },
	}
	def_opened.can_dig = function()
		return false
	end

	def_closed.mesh = nil
	def_closed.drawtype = nil
	def_closed.tiles[6] = def.tiles[5] -- swap textures around for "normal"
	def_closed.tiles[5] = def.tiles[3] -- drawtype to make them match the mesh
	def_closed.tiles[3] = def.tiles[3].."^[transformFX"

	minetest.register_node("obsidianmese:" .. name, def_closed)
	minetest.register_node("obsidianmese:" .. name .. "_open", def_opened)

	-- convert old chests to this new variant
	minetest.register_lbm({
		label = "update obsidianmese chests to opening chests",
		name = "obsidianmese:upgrade_" .. name .. "_v2",
		nodenames = {"obsidianmese:" .. name},
		action = function(pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", nil)
			local inv = meta:get_inventory()
			local list = inv:get_list("obsidianmese:chest")
			if list then
				inv:set_size("main", 8*4)
				inv:set_list("main", list)
				inv:set_list("obsidianmese:chest", nil)
			end
		end
	})
end

obsidianmese.register_chest("chest", {
	description = "Obsidian Mese Chest",
	tiles = {
		"obsidianmese_chest_top.png",
		"obsidianmese_chest_top.png",
		"obsidianmese_chest_side.png",
		"obsidianmese_chest_side.png",
		"obsidianmese_chest_front.png",
		"obsidianmese_chest_inside.png"
	},
	sounds = default.node_sound_stone_defaults(),
	sound_open = "obsidianmese_chest_open",
	sound_close = "obsidianmese_chest_close",
	groups = {cracky = 1, level = 2},
	light_source = 6,
})

minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	inv:set_size("obsidianmese:chest", 8*4)
end)
