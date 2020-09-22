minetest.register_node("pvp_block:pvpblock", {
	description = "PvP Block",
	tiles = {"pvpblock.png"},
	groups = {cracky = 2, stone = 1},
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),

	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)

		if placer and placer:is_player() then
			table.insert(pvp_block.blocks, {
					pos = vector.round(pos),
					owner = placer:get_player_name()
				}
			)

			pvp_block:save()
			meta:set_string("infotext", "owner: "..placer:get_player_name())
		end
	end,

	on_punch = function(pos, node, puncher, pointed_thing)
		local pname = puncher:get_player_name()
		if not pname or pname == "" then
			return
		end
		local privs = minetest.get_player_privs(pname)
		if not privs.privs then
			return
		end
		minetest.chat_send_player(pname, "--- Select positions by punching two nodes.")
		pvp_block.pos0[pname] = vector.round(pos)
		pvp_block.set_pos[pname] = "pos1"
	end,

	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local pos0 = vector.round(pos)
		local pname = clicker:get_player_name()

		for i, block in ipairs(pvp_block.blocks) do
			if vector.equals(pos0, block.pos) then
				pvp_block.pos1[pname] = block.pos1
				pvp_block.pos2[pname] = block.pos2
				pvp_block.mark_pos1(pname)
				pvp_block.mark_pos2(pname)
				minetest.chat_send_player(pname, "--- Position 1 set to "..minetest.pos_to_string(block.pos1))
				minetest.chat_send_player(pname, "--- Position 2 set to "..minetest.pos_to_string(block.pos2))
				break
			end
		end
	end,

	on_destruct = function(pos)
		for i, block in ipairs(pvp_block.blocks) do
			if vector.equals(block.pos, pos) then
				table.remove(pvp_block.blocks, i)
				pvp_block:save()
			end
		end
	end,
})

minetest.register_entity("pvp_block:pos1", {
	initial_properties = {
		visual = "cube",
		visual_size = {x=1.1, y=1.1},
		textures = {"pvpblock_pos1.png", "pvpblock_pos1.png",
			"pvpblock_pos1.png", "pvpblock_pos1.png",
			"pvpblock_pos1.png", "pvpblock_pos1.png"},
		collisionbox = {-0.55, -0.55, -0.55, 0.55, 0.55, 0.55},
		physical = false,
	},
	on_step = function(self, dtime)
		if pvp_block.marker1[self.player_name] == nil then
			self.object:remove()
		end
	end,
	on_punch = function(self, hitter)
		self.object:remove()
		pvp_block.marker1[self.player_name] = nil
	end,
})

minetest.register_entity("pvp_block:pos2", {
	initial_properties = {
		visual = "cube",
		visual_size = {x=1.1, y=1.1},
		textures = {"pvpblock_pos2.png", "pvpblock_pos2.png",
			"pvpblock_pos2.png", "pvpblock_pos2.png",
			"pvpblock_pos2.png", "pvpblock_pos2.png"},
		collisionbox = {-0.55, -0.55, -0.55, 0.55, 0.55, 0.55},
		physical = false,
	},
	on_step = function(self, dtime)
		if pvp_block.marker2[self.player_name] == nil then
			self.object:remove()
		end
	end,
	on_punch = function(self, hitter)
		self.object:remove()
		pvp_block.marker2[self.player_name] = nil
	end,
})

-- minetest.register_craft({
--  output = 'pvp_block:pvpblock',
--  recipe = {
--    {'default:pick_mese', 'farming:hoe_mese', 'default:sword_mese'},
--    {'default:sandstone', 'default:goldblock', 'default:sandstone'},
--    {'default:stonebrick', 'default:mese', 'default:stonebrick'},
--  }
-- })
