
--[[
skyboxdef = {
	name = "",
	color = {r=0, g=0, b=0},
	textures = {}
}
--]]

-- register a new skybox
epic_skybox.register = function(skyboxdef)
	table.insert(epic_skybox.list, skyboxdef)
end
