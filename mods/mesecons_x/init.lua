minetest.register_node("mesecons_x:balrog_spawner", {
    description = "server balrog spawner",
    tiles = {"default_chest_top.png"},
    is_ground_content = false,
    mesecons = {effector = {
		    rules = mesecon.rules.default,
		    action_on = function (pos, node)
			       -- spawn a balrog above it
             local spawn_pos = {x=pos.x + math.random(-7,7),y=pos.y + 12, z = pos.z + math.random(-7,7) }
             minetest.add_entity(spawn_pos, "spawners_mobs:balrog")
		    end,

	      }},
    groups = {cracky=3,},
})
