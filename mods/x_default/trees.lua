--
-- Grow trees from saplings
--

-- 'can grow' function

function x_default.can_grow(pos)
	local node_under = minetest.get_node_or_nil({x = pos.x, y = pos.y - 1, z = pos.z})
	if not node_under then
		return false
	end
	local name_under = node_under.name
	local is_soil = minetest.get_item_group(name_under, "soil")
	if is_soil == 0 then
		return false
	end
	local light_level = minetest.get_node_light(pos)
	if not light_level or light_level < 13 then
		return false
	end
	return true
end

-- 'is snow nearby' function

local function is_snow_nearby(pos)
	return minetest.find_node_near(pos, 1, {"group:snowy"})
end

-- Grow sapling

function x_default.grow_sapling(pos)
	if not default.can_grow(pos) then
		-- try again 5 min later
		minetest.get_node_timer(pos):start(300)
		return
	end

	local node = minetest.get_node(pos)

	if node.name == "x_default:christmas_tree_sapling" then
		minetest.log("action", "A christmas tree sapling grows into a tree at "..minetest.pos_to_string(pos))
		local snow = is_snow_nearby(pos)
		if snow then
			x_default.grow_snowy_christmas_tree(pos)
		else
			x_default.grow_christmas_tree(pos)
		end
	end
end

-- New pine tree

function x_default.grow_christmas_tree(pos)
	local path
	if math.random() > 0.5 then
		path = minetest.get_modpath("x_default").."/schematics/christmas_tree_from_sapling.mts"
		minetest.place_schematic({x = pos.x - 2, y = pos.y, z = pos.z - 2}, path, "0", nil, false)
	else
		path = minetest.get_modpath("x_default").."/schematics/small_christmas_tree_from_sapling.mts"
		minetest.place_schematic({x = pos.x - 1, y = pos.y, z = pos.z - 1}, path, "0", nil, false)
	end
end

function x_default.grow_snowy_christmas_tree(pos)
	local path
	if math.random() > 0.5 then
		path = minetest.get_modpath("x_default").."/schematics/snowy_christmas_tree_from_sapling.mts"
		minetest.place_schematic({x = pos.x - 2, y = pos.y, z = pos.z - 2}, path, "0", nil, false)
	else
		path = minetest.get_modpath("x_default").."/schematics/snowy_small_christmas_tree_from_sapling.mts"
		minetest.place_schematic({x = pos.x - 1, y = pos.y, z = pos.z - 1}, path, "0", nil, false)
	end
end
