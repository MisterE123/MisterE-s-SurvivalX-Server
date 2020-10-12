

minetest.register_chatcommand("skybox_list", {
	description = "Lists all available skyboxes",
	func = function()
		local list = ""
		for _, skyboxdef in ipairs(epic_skybox.list) do
			list = list .. skyboxdef.name .. ","
		end

		return true, list
	end
})
