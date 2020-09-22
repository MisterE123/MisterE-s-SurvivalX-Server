--
-- Treasure Chest
--
local x_default_treasure_chest_timer = 0
local x_default_treasure_chest_trigger = 60 -- 1 minute
local x_default_treasure_chest_particle_timer = 0
local x_default_treasure_chest_particle_trigger = 20
local x_default_treasure_chest_remaining_msg_0 = false
local x_default_treasure_chest_remaining_msg_1 = false
local x_default_treasure_chest_remaining_msg_2 = false
local x_default_treasure_chest_remaining_msg_3 = false
local x_default_treasure_chest_remaining_msg_4 = false
local x_default_treasure_chest_remaining_msg_5 = false
-- after how long will be chest refilled
local x_default_treasure_chest_refill_timer = 21600 -- 6 hours
local open_chests = {}
local treasure_chests_storage = {}
local enable_particles = minetest.settings:get_bool("enable_particles")

function x_default:sync_treasure_chests_storage()
	treasure_chests_storage = x_default.storage:to_table().fields.treasure_chests
	treasure_chests_storage = minetest.deserialize(treasure_chests_storage) or {}
end

function save_treasure_chests_storage(pos, remove)
	if remove then
		for k, v in pairs(treasure_chests_storage) do
			if minetest.pos_to_string(v.pos) == minetest.pos_to_string(pos) then
				table.remove(treasure_chests_storage, k)
			end
		end
		-- print("table remove", dump(treasure_chests_storage))
	end

	local datastring = minetest.serialize(treasure_chests_storage)
	if not datastring then
		return
	end

	x_default.storage:set_string("treasure_chests", datastring)
end

-- particles
function treasure_chest_add_effects(pos)
	if not enable_particles then return end

	return minetest.add_particlespawner({
		amount = 4,
		time = 0,
		minpos = {x=pos.x-0.5, y=pos.y+2, z=pos.z-0.5},
		maxpos = {x=pos.x+0.5, y=pos.y+4, z=pos.z+0.5},
		minvel = {x=0, y=-0.5, z=0},
		maxvel = {x=0,  y=-1.5,  z=0},
		minacc = vector.new(),
		maxacc = vector.new(),
		minexptime = 2,
		maxexptime = 3,
		minsize = 3,
		maxsize = 6,
		texture = "x_default_treasure_chest_particle_animated.png",
		animation = {
			type = "vertical_frames",
			-- Width of a frame in pixels
			aspect_w = 16,
			-- Height of a frame in pixels
			aspect_h = 16,
			-- Full loop length
			length = 2.0,
		},
		glow = 7
	})
end

function get_chest_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," .. pos.z
	local formspec =
		"size[8,9]"..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"list[nodemeta:" .. spos .. ";main;0,0.3;8,4;]" ..
		"list[current_player;main;0,4.85;8,1;]" ..
		"list[current_player;main;0,6.08;8,3;8]" ..
		"listring[nodemeta:" .. spos .. ";main]" ..
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

function chest_lid_close(pn)
	local chest_open_info = open_chests[pn]
	local pos = chest_open_info.pos
	local sound = chest_open_info.sound
	local swap = chest_open_info.swap

	open_chests[pn] = nil
	for k, v in pairs(open_chests) do
		if v.pos.x == pos.x and v.pos.y == pos.y and v.pos.z == pos.z then
			return true
		end
	end

	local node = minetest.get_node(pos)
	minetest.after(0.2, minetest.swap_node, pos, { name = "x_default:" .. swap,
			param2 = node.param2 })
	minetest.sound_play(sound, {gain = 0.3, pos = pos, max_hear_distance = 10})
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "x_default:treasure_chest" then
		return
	end
	if not player or not fields.quit then
		return
	end
	local pn = player:get_player_name()

	if not open_chests[pn] then
		return
	end

	chest_lid_close(pn)
	return true
end)

minetest.register_on_leaveplayer(function(player)
	local pn = player:get_player_name()
	if open_chests[pn] then
		chest_lid_close(pn)
	end
end)

function register_chest(name, d)
	local def = table.copy(d)
	def.drawtype = "mesh"
	def.visual = "mesh"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.legacy_facedir_simple = true
	def.is_ground_content = false

	def.on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Treasure Chest")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*3)

		table.insert(treasure_chests_storage, { pos=pos, remaining=x_default_treasure_chest_refill_timer})
		save_treasure_chests_storage()
		-- add particles
		local id_effect = treasure_chest_add_effects(pos)
		if id_effect and id_effect ~= -1 then
			meta:set_int("id_effect", id_effect)
		end
	end

	def.on_destruct = function(pos)
		save_treasure_chests_storage(pos, true)
		-- delete particles
		local meta = minetest.get_meta(pos)
		local id_effect = meta:get_int("id_effect")

		if id_effect and id_effect ~= -1 then
			minetest.delete_particlespawner(id_effect)
		end
	end

	def.can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end

	def.on_rightclick = function(pos, node, clicker)
		minetest.sound_play(def.sound_open, {gain = 0.3, pos = pos,
				max_hear_distance = 10})
		if not chest_lid_obstructed(pos) then
			minetest.swap_node(pos, {
					name = "x_default:" .. name .. "_open",
					param2 = node.param2 })
		end
		minetest.after(0.2, minetest.show_formspec,
				clicker:get_player_name(),
				"x_default:treasure_chest", get_chest_formspec(pos))
		open_chests[clicker:get_player_name()] = { pos = pos,
				sound = def.sound_close, swap = name }
	end

	def.on_blast = function() end

	def.allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return 0
	end

	def.allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		return 0
	end

	def.on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" takes " .. stack:get_name() ..
			" from treasure chest at " .. minetest.pos_to_string(pos))
	end

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

	def_opened.drop = "x_default:" .. name
	def_opened.groups.not_in_creative_inventory = 1
	def_opened.selection_box = {
		type = "fixed",
		fixed = { -1/2, -1/2, -1/2, 1/2, 3/16, 1/2 },
	}

	def_opened.can_dig = function()
		return false
	end

	def_opened.on_blast = function() end

	def_closed.mesh = nil
	def_closed.drawtype = nil
	def_closed.tiles[6] = def.tiles[5] -- swap textures around for "normal"
	def_closed.tiles[5] = def.tiles[3] -- drawtype to make them match the mesh
	def_closed.tiles[3] = def.tiles[3].."^[transformFX"

	minetest.register_node("x_default:" .. name, def_closed)
	minetest.register_node("x_default:" .. name .. "_open", def_opened)
end

register_chest("treasure_chest", {
	description = "Treasure Chest",
	tiles = {
		"x_default_treasure_chest_top.png",
		"x_default_treasure_chest_top.png",
		"x_default_treasure_chest_side.png",
		"x_default_treasure_chest_side.png",
		"x_default_treasure_chest_front.png",
		"x_default_treasure_chest_inside.png"
	},
	sounds = default.node_sound_stone_defaults(),
	sound_open = "x_default_treasure_chest_open",
	sound_close = "x_default_treasure_chest_close",
	groups = {cracky = 1, level = 2, not_in_creative_inventory = 1},
	light_source = 6,
})

minetest.register_globalstep(function(dtime)
	x_default_treasure_chest_timer = x_default_treasure_chest_timer + dtime
	x_default_treasure_chest_particle_timer = x_default_treasure_chest_particle_timer + dtime

	for k, chest in pairs(treasure_chests_storage) do
		treasure_chests_storage[k].remaining = treasure_chests_storage[k].remaining - dtime

		if x_default_treasure_chest_timer >= x_default_treasure_chest_trigger then
			-- treasure_chests_storage is empty
			if #treasure_chests_storage == 0 then
				x_default_treasure_chest_timer = 0
				return
			end

			local remaining = chest.remaining

			-- print(k.." remaining", remaining)

			if remaining > x_default_treasure_chest_trigger then
				x_default_treasure_chest_trigger = remaining / 3

				if x_default_treasure_chest_trigger < 60 then
					x_default_treasure_chest_trigger = 60
				end

				-- print("new trigger", x_default_treasure_chest_trigger)
			end

			-- less than 20 minutes
			if remaining > 600 and remaining < 1200 and not x_default_treasure_chest_remaining_msg_1 then
				minetest.chat_send_all(minetest.colorize("#CE93D8", "Treasure chest will be refilled in less than 20 minutes. (inside PvP arena)"))
				x_default_treasure_chest_remaining_msg_1 = true

			-- less than 10 minutes
			elseif remaining > 300 and remaining < 600 and not x_default_treasure_chest_remaining_msg_2 then
				minetest.chat_send_all(minetest.colorize("#CE93D8", "Treasure chest will be refilled in less than 10 minutes. (inside PvP arena)"))
				x_default_treasure_chest_remaining_msg_2 = true

			-- less than 5 minutes
			elseif remaining > 180 and remaining < 300 and not x_default_treasure_chest_remaining_msg_3 then
				minetest.chat_send_all(minetest.colorize("#CE93D8", "Treasure chest will be refilled in less than 5 minutes. (inside PvP arena)"))
				x_default_treasure_chest_remaining_msg_3 = true

			-- less than 3 minutes
			elseif remaining > 60 and remaining < 180 and not x_default_treasure_chest_remaining_msg_4 then
				minetest.chat_send_all(minetest.colorize("#CE93D8", "Treasure chest will be refilled in less than 3 minutes. (inside PvP arena)"))
				x_default_treasure_chest_remaining_msg_4 = true

			-- less than 1 minute
			elseif remaining < 60 and not x_default_treasure_chest_remaining_msg_5 then
				minetest.chat_send_all(minetest.colorize("#CE93D8", "Treasure chest will be refilled in less than 1 minutes. (inside PvP arena)"))
				x_default_treasure_chest_remaining_msg_5 = true

			-- refill chest
			elseif remaining <= 0 and not x_default_treasure_chest_remaining_msg_0 then

				local meta = minetest.get_meta(chest.pos);
				local inv = meta:get_inventory()
				local inv_main = inv:get_list("main")
				local inv_size = inv:get_size("main")

				-- fill-up chest
				for idx, stack in pairs(inv_main) do
					-- empty first
					if not stack:is_empty() then
						local stack_new = ItemStack("")
						inv:set_stack("main", idx, stack_new)
					end

					for i = 1, inv_size do
						local stack_new = ItemStack(x_default.treasure_chest_list[math.random(1, #x_default.treasure_chest_list)])

						if stack_new:get_stack_max() > 1 then
							stack_new:set_count(math.random(1, stack_new:get_stack_max()))
						end

						inv:set_stack("main", i, stack_new)
					end
				end

				minetest.sound_play("x_default_treasure_chest_fillup", {
					pos = chest.pos,
					max_hear_distance = 32,
					gain = 1
				})

				minetest.chat_send_all(minetest.colorize("#CE93D8", "Treasure chest was refilled! (inside PvP arena)"))

				x_default_treasure_chest_remaining_msg_0 = false
				x_default_treasure_chest_remaining_msg_1 = false
				x_default_treasure_chest_remaining_msg_2 = false
				x_default_treasure_chest_remaining_msg_3 = false
				x_default_treasure_chest_remaining_msg_4 = false
				x_default_treasure_chest_remaining_msg_5 = false
				chest.remaining = x_default_treasure_chest_refill_timer
			end

			save_treasure_chests_storage()
			x_default_treasure_chest_timer = 0
		end
	end


	-- for particles
	if x_default_treasure_chest_particle_timer >= x_default_treasure_chest_particle_trigger then
		-- treasure_chests_storage is empty
		if #treasure_chests_storage == 0 then
			x_default_treasure_chest_particle_timer = 0
			return
		end

		for k, chest in pairs(treasure_chests_storage) do
			local meta = minetest.get_meta(chest.pos)
			local id_effect = meta:get_int("id_effect")
			local player_near = false

			for _,obj in ipairs(minetest.get_objects_inside_radius(chest.pos, 16)) do
				if obj:is_player() then
					player_near = true
					break
				end
			end

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

				id_effect = treasure_chest_add_effects(chest.pos)
				meta:set_int("id_effect", id_effect)
			end
		end

		x_default_treasure_chest_particle_timer = 0
	end
end)