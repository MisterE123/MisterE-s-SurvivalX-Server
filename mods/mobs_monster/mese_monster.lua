
local S = mobs.intllib


-- Mese Monster by Zeg9

mobs:register_mob("mobs_monster:mese_monster", {
	type = "monster",
	passive = false,
	damage = 6,
	attack_type = "shoot",
	shoot_interval = 0.5,
	arrow = "mobs_monster:mese_arrow",
	shoot_offset = 2,
	hp_min = 45,
	hp_max = 100,
	armor = 80,
	collisionbox = {-0.5, -1.5, -0.5, 0.5, 0.5, 0.5},
	visual = "mesh",
	mesh = "zmobs_mese_monster.x",
	textures = {
		{"zmobs_mese_monster.png"},
	},
	blood_texture = "default_mese_crystal_fragment.png",
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_mesemonster_neutral",
		damage = "mobs_mesemonster_hit",
		death = "mobs_mesemonster_death",
		distance = 15
	},
	view_range = 16,
	walk_velocity = 0.5,
	run_velocity = 2,
	jump = true,
	jump_height = 8,
	fall_damage = 0,
	fall_speed = -6,
	stepheight = 2.1,
	drops = {
		{name = "default:mese_crystal", chance = 9, min = 0, max = 2},
		{name = "default:mese_crystal_fragment", chance = 1, min = 0, max = 2},
	},
	water_damage = 10,
	lava_damage = 10,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	},
})


mobs:spawn({
	name = "mobs_monster:mese_monster",
	nodes = {"default:stone"},
	min_light = 0,
	max_light = 14,
	chance = 5000,
	active_object_count = 1,
	max_height = -20,
	day_toggle = false
})


mobs:register_egg("mobs_monster:mese_monster", S("Mese Monster"), "default_mese_block.png", 1)


mobs:alias_mob("mobs:mese_monster", "mobs_monster:mese_monster") -- compatiblity


-- mese arrow (weapon)
mobs:register_arrow("mobs_monster:mese_arrow", {
	visual = "sprite",
--	visual = "wielditem",
	visual_size = {x = 0.5, y = 0.5},
	textures = {"default_mese_crystal_fragment.png"},
	--textures = {"default:mese_crystal_fragment"},
	velocity = 6,
--	rotate = 180,

	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 2},
		}, nil)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 2},
		}, nil)
	end,

	hit_node = function(self, pos, node)
	end
})

-- 9x mese crystal fragments = 1x mese crystal
minetest.register_craft({
	output = "default:mese_crystal",
	recipe = {
		{"default:mese_crystal_fragment", "default:mese_crystal_fragment", "default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment", "default:mese_crystal_fragment", "default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment", "default:mese_crystal_fragment", "default:mese_crystal_fragment"},
	}
})
