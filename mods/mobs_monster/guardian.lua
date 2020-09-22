local S = mobs.intllib

mobs:register_mob("mobs_monster:guardian", {
	type = "monster",
	hp_min = 80,
	hp_max = 120,
	passive = false,
	attack_type = "dogfight",
	pathfinding = false,
	view_range = 16,
	walk_velocity = 2,
	run_velocity = 4,
	damage = 8,
	reach = 3,
	collisionbox = {-0.99875, 0.5, -0.99875, 0.99875, 2.4975, 0.99875},
	visual = "mesh",
	mesh = "mobs_guardian.b3d",
	textures = {
		{"mobs_guardian1.png"},
		{"mobs_guardian2.png"},
	},
	blood_texture = "mobs_squid_blood.png",
	visual_size = {x=7, y=7},
	makes_footstep_sound = false,
	sounds = {
		attack = "mobs_squid_attack",
		death = "mobs_squid_death",
		distance = 16,
	},
	animation = {
		stand_speed = 25, walk_speed = 25, run_speed = 50,
		stand_start = 0,		stand_end = 20,
		walk_start = 0,		walk_end = 20,
		run_start = 0,		run_end = 20,
	},
	drops = {
		{name = "default:coral_orange", chance = 3, min = 1, max = 2},
		{name = "default:coral_brown", chance = 3, min = 1, max = 2}
	},
	fly = true,
	fly_in = {"default:water_source"},
	stepheight = 0.1,
	jump = false,
	water_damage = 0,
	lava_damage = 4,
	light_damage = 20,
})

 mobs:spawn({
 	name = "mobs_monster:guardian",
 	nodes = {"default:water_source"},
 	neighbors = {"default:water_source"},
 	min_light = 0,
 	max_light = 7,
 	active_object_count = 1,
 	chance = 60000,
 	max_height = 0,
 	min_height = -31000,
 	day_toggle = false
 })

mobs:register_egg("mobs_monster:guardian", S("Guardian"), "default_water.png", 1)
