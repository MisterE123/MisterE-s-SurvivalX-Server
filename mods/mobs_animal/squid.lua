local S = mobs.intllib

mobs:register_mob("mobs_animal:squid", {
	type = "animal",
	passive = false,
	attack_type = "dogfight",
	group_attack = true,
	reach = 2,
	damage = 4,
	hp_min = 45,
	hp_max = 65,
	armor = 100,
	collisionbox = {-0.4, -0.1, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "mobs_squid.b3d",
	textures = {
		{"mobs_squid1.png"},
		{"mobs_squid2.png"}
	},
	sounds = {
		attack = "mobs_squid_attack",
		death = "mobs_squid_death",
		distance = 16,
	},
	animation = {
		stand_start = 1,
		stand_end = 60,
		walk_start = 1,
		walk_end = 60,
		run_start = 1,
		run_end = 60,
	},
	drops = {
		{name = "default:coral_orange", chance = 3, min = 1, max = 2},
		{name = "default:coral_brown", chance = 3, min = 1, max = 2}
	},
	visual_size = {x=1.75, y=1.75},
	makes_footstep_sound = false,
	stepheight = 0.1,
	fly = true,
	fly_in = {"default:water_source"},
	jump = false,
	fall_speed = 0.5,
	view_range = 10,
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 4,
	blood_texture = "mobs_squid_blood.png",
})

-- mobs:spawn({
-- 	name = "mobs_animal:squid",
-- 	nodes = {"default:water_source"},
-- 	neighbors = {"default:water_source"},
-- 	min_light = 0,
-- 	max_light = 15,
-- 	active_object_count = 1,
-- 	chance = 7000,
-- 	max_height = 0,
-- 	min_height = -31000,
-- 	day_toggle = true
-- })

-- mobs:register_egg("mobs_animal:squid", S("Squid"), "default_water.png", 1)