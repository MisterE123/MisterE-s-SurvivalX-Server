
local S = mobs.intllib


-- Stone Monster by PilzAdam

mobs:register_mob("mobs_monster:stone_monster", {
	type = "monster",
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 3,
	damage = 4,
	hp_min = 25,
	hp_max = 85,
	armor = 80,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.9, 0.4},
	visual = "mesh",
	mesh = "mobs_stone_monster.b3d",
	textures = {
		{"mobs_stone_monster.png"},
		{"mobs_stone_monster2.png"}, -- by AMMOnym
		{"mobs_stone_monster3.png"},
	},
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_stonemonster_neutral",
		damage = "mobs_stonemonster_hit",
		attack = "mobs_stonemonster_attack",
		death = "mobs_stonemonster_death",
		distance = 15
	},
	walk_velocity = 2,
	run_velocity = 3,
	jump_height = 0,
	stepheight = 1.1,
	floats = 0,
	view_range = 16,
	drops = {
		{name = "default:cobble", chance = 1, min = 0, max = 2},
		{name = "default:coal_lump", chance = 3, min = 0, max = 2},
		{name = "default:iron_lump", chance = 5, min = 0, max = 2},
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
	name = "mobs_monster:stone_monster",
	nodes = {"default:stone", "default:desert_stone", "default:sandstone"},
	min_light = 0,
	max_light = 7,
	chance = 7000,
	max_height = 0,
	day_toggle = false,
})


mobs:register_egg("mobs_monster:stone_monster", S("Stone Monster"), "default_stone.png", 1)


mobs:alias_mob("mobs:stone_monster", "mobs_monster:stone_monster") -- compatibility
