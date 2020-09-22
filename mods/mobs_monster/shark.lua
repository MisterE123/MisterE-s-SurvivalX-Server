-- Shark Monster

mobs:register_mob("mobs_monster:shark", {
   type = "monster",
   attack_type = "dogfight",
   damage = 6,
   reach = 2,
   hp_min = 25,
   hp_max = 50,
   armor = 100,
   collisionbox = {-0.38, -0.25, -0.38, 0.38, 0.25, 0.38},
   visual = "mesh",
   visual_size = {x = 1, y = 1},
   mesh = "mobs_shark.b3d",
   textures = {
      {"mobs_shark_shark_mesh.png"},
   },
   makes_footstep_sound = false,
   walk_velocity = 2,
   run_velocity = 3,
   jump = false,
   fly = true,
   fly_in = "default:water_source",
   fall_speed = -9,
   stepheight = 0.1,
   rotate = 270,
   view_range = 10,
   water_damage = 0,
   lava_damage = 10,
   light_damage = 0,
   drops = {
      {name = "default:mese_crystal", chance = 15, min = 1, max = 3},
      {name = "default:clay_lump", chance = 15, min = 1, max = 3},
   },
   animation = {
      speed_normal =24,
      speed_run = 24,
      stand_start = 1,
      stand_end = 80,
      walk_start = 80,
      walk_end = 160,
      run_start = 80,
      run_end = 160
   }
})

mobs:register_egg("mobs_monster:shark", "Shark", "mobs_shark_shark_item.png", 0)

mobs:spawn_specific("mobs_monster:shark",
   {"default:water_source"}, {"default:water_source"}, 4, 20, 30, 9000, 1, -30, -3)