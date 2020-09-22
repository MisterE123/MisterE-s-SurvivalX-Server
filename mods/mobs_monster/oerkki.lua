
local S = mobs.intllib


-- Oerkki by PilzAdam

mobs:register_mob("mobs_monster:oerkki", {
	type = "monster",
	group_attack = true,
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 3,
	damage = 6,
	hp_min = 35,
	hp_max = 85,
	armor = 100,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.9, 0.4},
	visual = "mesh",
	mesh = "mobs_oerkki.b3d",
	textures = {
		{"mobs_oerkki.png"},
		{"mobs_oerkki2.png"},
	},
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_oerkki_neutral",
		damage = "mobs_oerkki_hit",
		attack = "mobs_oerkki_attack",
		death = "mobs_oerkki_death",
		distance = 15
	},
	walk_velocity = 2,
	run_velocity = 4,
	view_range = 16,
	jump = true,
	drops = {
		{name = "default:obsidian", chance = 3, min = 0, max = 2},
		{name = "default:gold_lump", chance = 2, min = 0, max = 2},
	},
	water_damage = 10,
	lava_damage = 10,
	light_damage = 0,
	fear_height = 4,
	animation = {
		stand_start = 0,
		stand_end = 23,
		walk_start = 24,
		walk_end = 36,
		run_start = 37,
		run_end = 49,
		punch_start = 37,
		punch_end = 49,
		speed_normal = 15,
		speed_run = 15,
	},
	replace_rate = 5,
	replace_what = {"default:torch"},
	replace_with = "air",
	replace_offset = -1,
	immune_to = {
		{"default:sword_wood", 0}, -- no damage
		{"default:gold_lump", -10}, -- heals by 10 points
	},
})


mobs:spawn({
	name = "mobs_monster:oerkki",
	nodes = {"default:stone"},
	min_light = 0,
	max_light = 14,
	chance = 7000,
	max_height = -50,
	active_object_count = 2,
	day_toggle = false
})


mobs:register_egg("mobs_monster:oerkki", S("Oerkki"), "default_obsidian.png", 1)


mobs:alias_mob("mobs:oerkki", "mobs_monster:oerkki") -- compatiblity
