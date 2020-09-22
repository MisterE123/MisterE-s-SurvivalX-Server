
local S = mobs.intllib


-- Dirt Monster by PilzAdam

mobs:register_mob("mobs_monster:dirt_monster", {
	type = "monster",
	group_attack = true,
	passive = false,
	attack_type = "dogfight",
	pathfinding = true,
	reach = 3,
	damage = 3,
	hp_min = 25,
	hp_max = 65,
	armor = 100,
	collisionbox = {-0.4, -1, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "mobs_stone_monster.b3d",
	textures = {
		{"mobs_dirt_monster.png"},
		{"mobs_dirt_monster2.png"}
	},
	blood_texture = "default_dirt.png",
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_dirtmonster_neutral",
		damage = "mobs_dirtmonster_hit",
		attack = "mobs_dirtmonster_attack",
		death = "mobs_dirtmonster_death",
		distance = 15
	},
	view_range = 16,
	walk_velocity = 1,
	run_velocity = 3,
	jump = true,
	drops = {
		{name = "default:dirt", chance = 1, min = 0, max = 2},
	},
	water_damage = 5,
	lava_damage = 10,
	light_damage = 10,
	fear_height = 4,
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


local spawn_on = "default:dirt_with_grass", "default:dirt_with_dry_grass"

if minetest.get_modpath("ethereal") then
	spawn_on = "ethereal:gray_dirt"
end

mobs:spawn({
	name = "mobs_monster:dirt_monster",
	nodes = {spawn_on},
	min_light = 0,
	max_light = 7,
	chance = 7000,
	active_object_count = 2,
	min_height = 0,
	day_toggle = false,
})


mobs:register_egg("mobs_monster:dirt_monster", S("Dirt Monster"), "default_dirt.png", 1)


mobs:alias_mob("mobs:dirt_monster", "mobs_monster:dirt_monster") -- compatibility
