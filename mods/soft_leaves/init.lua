--[[
    Soft leaves - Allows to walk through and to climb on leaves.
	Copyright © 2018, 2019 Hamlet <hamlatmesehub@riseup.net> and contributors.

	Licensed under the EUPL, Version 1.2 or – as soon they will be
	approved by the European Commission – subsequent versions of the
	EUPL (the "Licence");
	You may not use this work except in compliance with the Licence.
	You may obtain a copy of the Licence at:

	https://joinup.ec.europa.eu/software/page/eupl
	https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017D0863

	Unless required by applicable law or agreed to in writing,
	software distributed under the Licence is distributed on an
	"AS IS" basis,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
	implied.
	See the Licence for the specific language governing permissions
	and limitations under the Licence.

--]]


--
-- Global mod's namespace
--

soft_leaves = {}


--
-- Leaves' table
--

local leaf_nodes = {
	"default:acacia_bush_leaves",
	"default:acacia_leaves",
	"default:aspen_leaves",
	"default:blueberry_bush_leaves",
	"default:blueberry_bush_leaves_with_berries",
	"default:bush_leaves",
	"default:jungleleaves",
	"default:leaves",
	"default:pine_bush_needles",
	"default:pine_needles"
}


--
-- Nodes' overrider
--

for element = 1, #leaf_nodes do
	minetest.override_item(leaf_nodes[element], {

		liquid_viscosity = 7,
		liquidtype = "source",
		liquid_alternative_flowing = leaf_nodes[element],
		liquid_alternative_source = leaf_nodes[element],
		liquid_renewable = false,
		liquid_range = 0,
		walkable = false,

	})
end


--
-- Flush the leaves' table for memory saving
--

leaf_nodes = nil


--
-- Global function to allow third party mods to support soft leaves.
--

soft_leaves.overrider = function(nodestring)
	minetest.override_item(nodestring, {
		climbable = true,
		walkable = false
	})
end


--
-- Minetest engine debug logging
--

if (minetest.settings:get("debug_log_level") == nil)
or (minetest.settings:get("debug_log_level") == "action")
or (minetest.settings:get("debug_log_level") == "info")
or (minetest.settings:get("debug_log_level") == "verbose")
then
	minetest.log("action", "[Mod] Soft Leaves [v0.2.0] loaded.")
end
