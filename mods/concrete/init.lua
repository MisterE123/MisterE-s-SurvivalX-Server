
local curing_interval = 60
setting = tonumber(minetest.settings:get("concrete_abm_curing_interval"))
if setting then
	curing_interval = setting
end

local use_buckets = 0
setting = tonumber(minetest.settings:get("concrete_use_buckets"))
if setting then
	use_buckets = setting
end


minetest.register_craftitem("concrete:portland_cement", {
    description = "Bag of Portland Cement",
    inventory_image = "concrete_portland_cement.png"
})

minetest.register_node("concrete:concrete_cured", {
	description = "Concrete",
	tiles = {"concrete_cured.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),

})

minetest.register_node("concrete:concrete_stair", {
		description = "Concrete Stair",
		tiles = {"concrete_cured.png"},
    drawtype = "nodebox",
    paramtype = "light",
		paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
            {-0.5, 0, 0, 0.5, 0.5, 0.5},
        },
    },
		groups = {cracky = 3},
		sounds = default.node_sound_stone_defaults()

})


minetest.register_node("concrete:concrete_uncured_source", {
	description = "Batch of Wet Concrete",
	drawtype = "liquid",

	tiles = {"concrete_uncured.png"},

	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "concrete:concrete_uncured_flowing",
	liquid_alternative_source = "concrete:concrete_uncured_source",
	liquid_viscosity = 7,
	liquid_range = 4,
	post_effect_color = {a = 0, r = 0, g = 0, b = 0},
	groups = {liquid = 2},

})

minetest.register_node("concrete:concrete_uncured_flowing", {
	description = "Uncured Flowing Concrete",
	drawtype = "flowingliquid",

	tiles = {"concrete_uncured.png"},
	special_tiles = {
		{
			name = "concrete_uncured_animated.png",
			backface_culling = false,
			animation = {
				type = "horizantal_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "concrete_uncured_animated.png",
			backface_culling = true,
			animation = {
				type = "horizontal_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},

	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
  liquid_alternative_flowing = "concrete:concrete_uncured_flowing",
	liquid_alternative_source = "concrete:concrete_uncured_source",
	liquid_viscosity = 5,
	liquid_range = 4,
	post_effect_color = {a = 0, r = 0, g = 0, b = 0},
	groups = {liquid = 2, not_in_creative_inventory = 1},

})


-- bucket --

		bucket.register_liquid(
		        "concrete:concrete_uncured_source",
		        "concrete:concrete_uncured_flowing",
		        "concrete:bucket_concrete",
		        "concrete_bucket.png",
		        "Bucket of Concrete"
		)




minetest.register_abm({
  nodenames = {"concrete:concrete_uncured_flowing","concrete:concrete_uncured_source"},
  interval = curing_interval,
  chance = 1,
  action = function(pos)
    minetest.add_node(pos, {name = "concrete:concrete_cured"})
  end,
})



if minetest.get_modpath("moreblocks") then
	minetest.register_craft({
			type = "cooking",
	    output = "concrete:portland_cement",
	    recipe = "moreblocks:cobble_compressed",
			cooktime = 5,
	})

else
	minetest.register_craft({
			type = "cooking",
	    output = "concrete:portland_cement",
	    recipe = "default:stone",
			cooktime = 20,
	})
end

if use_buckets == 1 then
	minetest.register_craft({
	    type = "shaped",
	    output = "concrete:bucket_concrete",
	    recipe = {
	        {"concrete:portland_cement", "concrete:portland_cement",  "concrete:portland_cement"},
	        {"concrete:portland_cement", "bucket:bucket_water",  "concrete:portland_cement"},
	        {"concrete:portland_cement", "concrete:portland_cement",  "concrete:portland_cement"}
	    }
	})

else
	minetest.register_craft({
	    type = "shaped",
	    output = "concrete:concrete_uncured_source",
	    recipe = {
	        {"concrete:portland_cement", "concrete:portland_cement",  "concrete:portland_cement"},
	        {"concrete:portland_cement", "bucket:bucket_water",  "concrete:portland_cement"},
	        {"concrete:portland_cement", "concrete:portland_cement",  "concrete:portland_cement"}
	    },
			replacements = {
				{"bucket:bucket_water","bucket:bucket_empty"}
			},
	})
end


minetest.register_craft({
    type = "cooking",
    output = "concrete:concrete_cured 9",
    recipe = "concrete:bucket_concrete",
    cooktime = 10,
		replacements = {
			{"concrete:bucket_concrete","bucket:bucket_empty"}
		}
})

minetest.register_craft({
    output = "concrete:concrete_stair",
    recipe = {
        {"", "","concrete:concrete_cured"},
				{"", "concrete:concrete_cured","concrete:concrete_cured"},
				{"concrete:concrete_cured", "concrete:concrete_cured","concrete:concrete_cured"}
    }

})
