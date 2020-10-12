

-- sets a players skybox
function epic_skybox.set_skybox(player, skyboxdef)
	if skyboxdef.textures then
		player:set_sky({r=0, g=0, b=0}, "skybox", skyboxdef.textures)
	elseif skyboxdef.color then
		player:set_sky(skyboxdef.color, "plain", {})
	else
		player:set_sky({r=0, g=0, b=0}, "regular", {})
	end
end
