-- 
-- define unknown nodes
-- 

-- workbench advanced [DOM]
-- plantlife_modpack:
-- - flowers_plus
-- - along_shore
-- - bushes
-- - trunks
-- - cavestuff
-- - dryplants
-- - ferns
-- - molehills
-- - youngtrees

local old_nodes = {
	"workbench:D",
	"flowers:waterlily_s1",
	"flowers:waterlily_s2",
	"flowers:waterlily_s3",
	"flowers:waterlily_s4",
	"flowers:seaweed",
	"flowers:seaweed_2",
	"flowers:seaweed_3",
	"flowers:seaweed_4",
	"flowers:waterlily_225",
	"flowers:waterlily_45",
	"flowers:waterlily_675",
	"flowers:sunflower",
	"flowers:cotton_plant",
	"flowers:flower_cotton",
	"flowers:flower_cotton_pot",
	"flowers:potted_dandelion_white",
	"flowers:potted_cotton_plant",
	"flowers:cotton",
	"flowers:cotton_wad",
	"sunflower:sunflower",
	"bushes:youngtree2_bottom",
	"bushes:bushbranches",
	"bushes:bushbranches1",
	"bushes:bushbranches2",
	"bushes:bushbranches3",
	"bushes:bushbranches4",
	"bushes:BushLeaves",
	"bushes:BushLeaves1",
	"bushes:BushLeaves2",
	"trunks:twig",
	"trunks:twig_1",
	"trunks:twig_2",
	"trunks:twig_3",
	"trunks:twig_4",
	"trunks:twig_5",
	"trunks:twig_6",
	"trunks:twig_7",
	"trunks:twig_8",
	"trunks:twig_9",
	"trunks:twig_10",
	"trunks:twig_11",
	"trunks:twig_12",
	"trunks:twig_13",
	"trunks:twigs",
	"trunks:twigs_slab",
	"trunks:twigs_roof",
	"trunks:twigs_roof_corner",
	"trunks:twigs_roof_corner_2",
	"trunks:moss_fungus",
	"trunks:moss",
	"trunks:treeroot",
	"trunks:jungletreeroot",
	"trunks:pine_treeroot",
	"trunks:tree_coniferroot",
	"trunks:tree_mangroveroot",
	"trunks:tree_palmroot",
	"trunks:apple_tree_trunkroot",
	"trunks:beech_trunkroot",
	"trunks:birch_trunkroot",
	"trunks:fir_trunkroot",
	"trunks:oak_trunkroot",
	"trunks:palm_trunkroot",
	"trunks:rubber_tree_trunkroot",
	"trunks:rubber_tree_trunk_emptyroot",
	"trunks:sequoia_trunkroot",
	"trunks:spruce_trunkroot",
	"trunks:willow_trunkroot",
	"cavestuff:pebble_1",
	"cavestuff:pebble_2",
	"cavestuff:desert_pebble_1",
	"cavestuff:desert_pebble_2",
	"cavestuff:stalactite_1",
	"cavestuff:stalactite_2",
	"cavestuff:stalactite_3",
	"dryplants:grass_short",
	"dryplants:grass",
	"dryplants:sickle",
	"dryplants:hay",
	"dryplants:wetreed",
	"dryplants:reedmace_sapling",
	"dryplants:reedmace_top",
	"dryplants:reedmace",
	"dryplants:reedmace_bottom",
	"dryplants:reed",
	"dryplants:reed_slab",
	"dryplants:wetreed_slab",
	"dryplants:reed_roof",
	"dryplants:wetreed_roof",
	"dryplants:reed_roof_corner",
	"dryplants:wetreed_roof_corner",
	"dryplants:reed_roof_corner_2",
	"dryplants:wetreed_roof_corner_2",
	"dryplants:juncus",
	"dryplants:juncus_02",
	"dryplants:reedmace_height_2",
	"dryplants:reedmace_height_3_spikes",
	"dryplants:reedmace_height_3",
	"dryplants:reedmace_water_entity",
	"dryplants:reedmace_spikes",
	"dryplants:reedmace_water",
	"ferns:fiddlehead",
	"ferns:ferntuber",
	"ferns:tree_fern_leaves",
	"ferns:tree_fern_leaves_02",
	"ferns:sapling_tree_fern",
	"ferns:fiddlehead_roasted",
	"ferns:ferntuber_roasted",
	"ferns:fern_01",
	"ferns:fern_02",
	"ferns:fern_03",
	"ferns:fern_04",
	"ferns:sapling_giant_tree_fern",
	"ferns:fern_trunk_big",
	"ferns:fern_trunk_big_top",
	"ferns:tree_fern_leaves_giant",
	"ferns:tree_fern_leave_big",
	"ferns:tree_fern_leave_big_end",
	"ferns:horsetail_01",
	"ferns:horsetail_02",
	"ferns:horsetail_03",
	"ferns:horsetail_04",
	"ferns:fern_trunk",
	"molehills:molehill",
	"youngtrees:bamboo",
	"youngtrees:youngtree2_middle",
	"youngtrees:youngtree_top",
	"youngtrees:youngtree_middle",
	"youngtrees:youngtree_bottom"
}

-- spacial case (replace with {"default:dirt_with_grass"})

-- plantlife_modpack:
-- - woodsoils

local old_nodes2 = {
	"woodsoils:dirt_with_leaves_1",
	"woodsoils:dirt_with_leaves_2",
	"woodsoils:grass_with_leaves_1",
	"woodsoils:grass_with_leaves_2",
	"woodsoils:grass_with_leaves_2"
}

--
-- define unknown entities
--

local old_entities = {}

-- 
-- assign a flag to nodes what should be removed
-- 

for _,node_name in ipairs(old_nodes) do
	minetest.register_node(":"..node_name, {
		groups = {old=1},
	})
end

for _,node_name2 in ipairs(old_nodes2) do
	minetest.register_node(":"..node_name2, {
		groups = {old2=1},
	})
end

-- 
-- remove unknown nodes
-- 

-- remove node {"air"}
if #old_nodes > 0 then
	minetest.register_lbm({
		name="enhancements:clean_unknown_to_air",
		nodenames = {"group:old"},
		run_at_every_load = true,
		action = function(pos, node)
			minetest.remove_node(pos)
			minetest.log("action", "[Mod][clean_unknown] Cleaning node "..node.name.." at position "..minetest.pos_to_string(pos))
		end,
	})
end

-- set node {"default:dirt_with_grass"}
if #old_nodes2 > 0 then
	minetest.register_lbm({
		name="enhancements:clean_unknown_to_dirt",
		nodenames = {"group:old2"},
		run_at_every_load = true,
		action = function(pos, node)
			minetest.set_node(pos, {name="default:dirt_with_grass"})
			minetest.log("action", "[Mod][clean_unknown] Cleaning node "..node.name.." at position "..minetest.pos_to_string(pos))
		end,
	})
end

-- 
-- remove unknown entities
-- 

if #old_entities > 0 then
	for _,entity_name in ipairs(old_entities) do
		minetest.register_entity(":"..entity_name, {
			on_activate = function(self, staticdata)
				self.object:remove()
				minetest.log("action", "[Mod][clean_unknown] Cleaning entity "..entity_name)
			end,
		})
	end
end
