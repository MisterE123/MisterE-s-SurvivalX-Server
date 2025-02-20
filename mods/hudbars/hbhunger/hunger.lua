
-- Keep these for backwards compatibility
function hbhunger.save_hunger(player)
	hbhunger.set_hunger(player)
end

function hbhunger.load_hunger(player)
	hbhunger.get_hunger(player)
end

-- Poison player
local function poisenp(tick, time, time_left, player)

	time_left = time_left + tick

	if time_left < time then
		minetest.after(tick, poisenp, tick, time, time_left, player)
	else
		--reset hud image
	end

	if player:get_hp() - 1 > 0 then

		player:set_hp(player:get_hp() - 1)
	end

end

function hbhunger.item_eat(hunger_change, replace_with_item, poisen, heal)

	return function(itemstack, user, pointed_thing)

		if itemstack:take_item() ~= nil and user ~= nil then

			local name = user:get_player_name()
			local h = tonumber(hbhunger.hunger[name])
			local hp = user:get_hp()

			minetest.sound_play("hbhunger_eat_generic", {
				object = user,
				max_hear_distance = 10,
				gain = 1.0
			})

			-- Saturation
			if h < 30 and hunger_change then

				h = h + hunger_change

				if h > 30 then h = 30 end

				hbhunger.hunger[name] = h
				hbhunger.set_hunger(user)
			end

			-- Healing
			if hp < 20 and heal then

				hp = hp + heal

				if hp > 20 then hp = 20 end

				user:set_hp(hp)
			end

			-- Poison
			if poisen then

				--set hud-img
				poisenp(1.0, poisen, 0, user)
			end

			if replace_with_item then

				if itemstack:is_empty() then

					itemstack:add_item(replace_with_item)
				else
					local inv = user:get_inventory()

					if inv:room_for_item("main", {name = replace_with_item}) then

						inv:add_item("main", replace_with_item)
					else
						local pos = user:getpos()

						pos.y = math.floor(pos.y + 0.5)

						core.add_item(pos, replace_with_item)
					end
				end
			end

		end

		return itemstack
	end
end

local function overwrite(name, hunger_change, replace_with_item, poisen, heal)

	local tab = minetest.registered_items[name]

	if tab == nil then return end

	tab.on_use = hbhunger.item_eat(hunger_change, replace_with_item, poisen, heal)

	minetest.registered_items[name] = tab
end

if minetest.get_modpath("default") then

	overwrite("default:apple", 2)
end

if minetest.get_modpath("farming") then

	overwrite("farming:bread", 4)
end

if minetest.get_modpath("flowers") then

	overwrite("flowers:mushroom_brown", 2)
	overwrite("flowers:mushroom_red", 0, "", 6)
end

if minetest.get_modpath("mobs") then

	if mobs and mobs.mod and mobs.mod == "redo" then

		overwrite("mobs:butter", 1)
		overwrite("mobs:cheese", 4)
		overwrite("mobs:meat", 8)
		overwrite("mobs:meat_raw", 2)
		overwrite("mobs:rat_cooked", 4)
		overwrite("mobs:honey", 2)
		overwrite("mobs:mutton_raw", 3, "", 3)
		overwrite("mobs:mutton_cooked", 6)
		overwrite("mobs:pork_raw", 3, "", 3)
		overwrite("mobs:pork_cooked", 8)
		overwrite("mobs:chicken_cooked", 6)
		overwrite("mobs:chicken_raw", 2, "", 3)
		overwrite("mobs:chicken_egg_fried", 2)

		if minetest.get_modpath("bucket") then

			overwrite("mobs:bucket_milk", 3, "bucket:bucket_empty")
		end
	else
		overwrite("mobs:meat", 6)
		overwrite("mobs:meat_raw", 3)
		overwrite("mobs:rat_cooked", 5)
	end
end

if minetest.get_modpath("nssm") then
	overwrite ('nssm:werewolf_leg',3)
	overwrite ('nssm:heron_leg',2)
	overwrite ('nssm:chichibios_heron_leg',4)
	overwrite ('nssm:crocodile_tail',3)
	overwrite ('nssm:duck_legs',1)
	overwrite ('nssm:ant_leg',1)
	overwrite ('nssm:spider_leg',1)
	overwrite ('nssm:tentacle',2)
	overwrite ('nssm:worm_flesh',2,"",2) -- poisonous
	overwrite ('nssm:amphibian_heart',1)
	overwrite ('nssm:raw_scrausics_wing',1)
	-- superfoods
	overwrite ('nssm:phoenix_nuggets',20,"",nil,20)
	overwrite ('nssm:phoenix_tear',20,"",nil,20)
end

if minetest.get_modpath("moretrees") then

	overwrite("moretrees:coconut_milk", 1)
	overwrite("moretrees:raw_coconut", 2)
	overwrite("moretrees:acorn_muffin", 3)
	overwrite("moretrees:spruce_nuts", 1)
	overwrite("moretrees:pine_nuts", 1)
	overwrite("moretrees:fir_nuts", 1)
end

if minetest.get_modpath("dwarves") then

	overwrite("dwarves:beer", 2)
	overwrite("dwarves:apple_cider", 1)
	overwrite("dwarves:midus", 2)
	overwrite("dwarves:tequila", 2)
	overwrite("dwarves:tequila_with_lime", 2)
	overwrite("dwarves:sake", 2)
end

if minetest.get_modpath("animalmaterials") then

	overwrite("animalmaterials:milk", 2)
	overwrite("animalmaterials:meat_raw", 3)
	overwrite("animalmaterials:meat_pork", 3)
	overwrite("animalmaterials:meat_beef", 3)
	overwrite("animalmaterials:meat_chicken", 3)
	overwrite("animalmaterials:meat_lamb", 3)
	overwrite("animalmaterials:meat_venison", 3)
	overwrite("animalmaterials:meat_undead", 3, "", 3)
	overwrite("animalmaterials:meat_toxic", 3, "", 5)
	overwrite("animalmaterials:meat_ostrich", 3)
	overwrite("animalmaterials:fish_bluewhite", 2)
	overwrite("animalmaterials:fish_clownfish", 2)
end

if minetest.get_modpath("fishing") then

	overwrite("fishing:fish_raw", 2)
	overwrite("fishing:fish_cooked", 5)
	overwrite("fishing:sushi", 6)
	overwrite("fishing:shark", 4)
	overwrite("fishing:shark_cooked", 8)
	overwrite("fishing:pike", 4)
	overwrite("fishing:pike_cooked", 8)
end

if minetest.get_modpath("glooptest") then

	overwrite("glooptest:kalite_lump", 1)
end

if minetest.get_modpath("bushes") then

	overwrite("bushes:sugar", 1)
	overwrite("bushes:strawberry", 2)
	overwrite("bushes:berry_pie_raw", 3)
	overwrite("bushes:berry_pie_cooked", 4)
	overwrite("bushes:basket_pies", 15)
end

-- bushes_classic mod, as found in the plantlife modpack
if minetest.get_modpath("bushes_classic") then

	local berries = {
		"strawberry",
		"blackberry",
		"blueberry",
		"raspberry",
		"gooseberry",
		"mixed_berry"
	}

	for _, berry in pairs(berries) do

		if berry ~= "mixed_berry" then
			overwrite("bushes:" .. berry, 1)
		end

		overwrite("bushes:" .. berry .. "_pie_raw", 2)
		overwrite("bushes:" .. berry .. "_pie_cooked", 5)
		overwrite("bushes:basket_" .. berry, 15)
	end
end

if minetest.get_modpath("mushroom") then

	overwrite("mushroom:brown", 1)
	overwrite("mushroom:red", 1, "", 3)

	-- mushroom potions: red = strong poison, brown = light restorative
	if minetest.get_modpath("vessels") then

		overwrite("mushroom:brown_essence", 1, "vessels:glass_bottle", nil, 4)
		overwrite("mushroom:poison", 1, "vessels:glass_bottle", 10)
	end
end

if minetest.get_modpath("docfarming") then

	overwrite("docfarming:carrot", 3)
	overwrite("docfarming:cucumber", 2)
	overwrite("docfarming:corn", 3)
	overwrite("docfarming:potato", 4)
	overwrite("docfarming:bakedpotato", 5)
	overwrite("docfarming:raspberry", 3)
end

if minetest.get_modpath("farming_plus") then

	overwrite("farming_plus:carrot_item", 3)
	overwrite("farming_plus:banana", 2)
	overwrite("farming_plus:orange_item", 2)
	overwrite("farming:pumpkin_bread", 4)
	overwrite("farming_plus:strawberry_item", 2)
	overwrite("farming_plus:tomato_item", 2)
	overwrite("farming_plus:potato_item", 4)
	overwrite("farming_plus:rhubarb_item", 2)
end

-- name, hunger_change, replace_with_item, poisen, heal
if minetest.get_modpath("farming_addons") then
	-- beetroot
	overwrite("farming_addons:beetroot", 3)
	overwrite("farming_addons:beetroot_soup", 6, "farming_addons:bowl")
	-- carrot
	overwrite("farming_addons:carrot", 3)
	overwrite("farming_addons:carrot_golden", 10, nil, nil, 10)
	-- coffee
	overwrite("farming_addons:coffee_cup", 4, "vessels:drinking_glass")
	overwrite("farming_addons:coffee_cup_hot", 6, "vessels:drinking_glass", nil, 4)
	-- corn
	overwrite("farming_addons:corn_pop", 1)
	overwrite("farming_addons:corn_popcorn", 5)
	-- melon
	overwrite("farming_addons:melon", 2)
	overwrite("farming_addons:golden_melon", 10, nil, nil, 10)
	-- potato
	overwrite("farming_addons:potato", 2)
	overwrite("farming_addons:bakedpotato", 6)
	overwrite("farming_addons:poisonouspotato", -6, nil, 5)
	-- pumpkin
	overwrite("farming_addons:pumpkin_pie", 6)
	-- hog stew
	overwrite("farming_addons:hog_stew", 8, "farming_addons:bowl")
	-- cocoa
	overwrite("farming_addons:cookie", 2)
	overwrite("farming_addons:chocolate", 3)
end

if minetest.get_modpath("mtfoods") then

	overwrite("mtfoods:dandelion_milk", 1)
	overwrite("mtfoods:sugar", 1)
	overwrite("mtfoods:short_bread", 4)
	overwrite("mtfoods:cream", 1)
	overwrite("mtfoods:chocolate", 2)
	overwrite("mtfoods:cupcake", 2)
	overwrite("mtfoods:strawberry_shortcake", 2)
	overwrite("mtfoods:cake", 3)
	overwrite("mtfoods:chocolate_cake", 3)
	overwrite("mtfoods:carrot_cake", 3)
	overwrite("mtfoods:pie_crust", 3)
	overwrite("mtfoods:apple_pie", 3)
	overwrite("mtfoods:rhubarb_pie", 2)
	overwrite("mtfoods:banana_pie", 3)
	overwrite("mtfoods:pumpkin_pie", 3)
	overwrite("mtfoods:cookies", 2)
	overwrite("mtfoods:mlt_burger", 5)
	overwrite("mtfoods:potato_slices", 2)
	overwrite("mtfoods:potato_chips", 3)
	overwrite("mtfoods:casserole", 3)
	overwrite("mtfoods:glass_flute", 2)
	overwrite("mtfoods:orange_juice", 2)
	overwrite("mtfoods:apple_juice", 2)
	overwrite("mtfoods:apple_cider", 2)
	overwrite("mtfoods:cider_rack", 2)
end

if minetest.get_modpath("fruit") then

	overwrite("fruit:apple", 2)
	overwrite("fruit:pear", 2)
	overwrite("fruit:bananna", 3)
	overwrite("fruit:orange", 2)
end

if minetest.get_modpath("mush45") then

	overwrite("mush45:meal", 4)
end

if minetest.get_modpath("seaplants") then

	overwrite("seaplants:kelpgreen", 1)
	overwrite("seaplants:kelpbrown", 1)
	overwrite("seaplants:seagrassgreen", 1)
	overwrite("seaplants:seagrassred", 1)
	overwrite("seaplants:seasaladmix", 6)
	overwrite("seaplants:kelpgreensalad", 1)
	overwrite("seaplants:kelpbrownsalad", 1)
	overwrite("seaplants:seagrassgreensalad", 1)
	overwrite("seaplants:seagrassgreensalad", 1)
end

if minetest.get_modpath("mobfcooking") then

	overwrite("mobfcooking:cooked_pork", 6)
	overwrite("mobfcooking:cooked_ostrich", 6)
	overwrite("mobfcooking:cooked_beef", 6)
	overwrite("mobfcooking:cooked_chicken", 6)
	overwrite("mobfcooking:cooked_lamb", 6)
	overwrite("mobfcooking:cooked_venison", 6)
	overwrite("mobfcooking:cooked_fish", 6)
end

if minetest.get_modpath("creatures")  then

	overwrite("creatures:meat", 6)
	overwrite("creatures:flesh", 3)
	overwrite("creatures:rotten_flesh", 3, "", 3)
end

if minetest.get_modpath("ethereal") then

	overwrite("ethereal:strawberry", 1)
	overwrite("ethereal:banana", 4)
	overwrite("ethereal:pine_nuts", 1)
	overwrite("ethereal:bamboo_sprout", 0, "", 3)
	overwrite("ethereal:fern_tubers", 1)
	overwrite("ethereal:banana_bread", 7)
	overwrite("ethereal:mushroom_plant", 2)
	overwrite("ethereal:coconut_slice", 2)
	overwrite("ethereal:golden_apple", 4, "", nil, 10)
	overwrite("ethereal:wild_onion_plant", 2)
	overwrite("ethereal:mushroom_soup", 5, "ethereal:bowl")
	overwrite("ethereal:hearty_stew", 10, "ethereal:bowl")

	if minetest.get_modpath("bucket") then

		overwrite("ethereal:bucket_cactus", 2, "bucket:bucket_empty")
	end

	overwrite("ethereal:fish_raw", 2)
	overwrite("ethereal:fish_cooked", 5)
	overwrite("ethereal:seaweed", 1)
	overwrite("ethereal:yellowleaves", 1, "", nil, 1)
	overwrite("ethereal:sashimi", 4)
	overwrite("ethereal:orange", 2)
end

if minetest.get_modpath("farming") and farming.mod == "redo" then

	overwrite("farming:bread", 6)
	overwrite("farming:potato", 1)
	overwrite("farming:baked_potato", 6)
	overwrite("farming:cucumber", 4)
	overwrite("farming:tomato", 4)
	overwrite("farming:carrot", 3)
	overwrite("farming:carrot_gold", 6, "", nil, 8)
	overwrite("farming:corn", 3)
	overwrite("farming:corn_cob", 5)
	overwrite("farming:melon_slice", 2)
	overwrite("farming:pumpkin_slice", 1)
	overwrite("farming:pumpkin_bread", 9)
	overwrite("farming:coffee_cup", 2, "farming:drinking_cup")
	overwrite("farming:coffee_cup_hot", 3, "farming:drinking_cup", nil, 2)
	overwrite("farming:cookie", 2)
	overwrite("farming:chocolate_dark", 3)
	overwrite("farming:donut", 4)
	overwrite("farming:donut_chocolate", 6)
	overwrite("farming:donut_apple", 6)
	overwrite("farming:raspberries", 1)
	overwrite("farming:blueberries", 1)
	overwrite("farming:muffin_blueberry", 4)

	if minetest.get_modpath("vessels") then

		overwrite("farming:smoothie_raspberry", 2, "vessels:drinking_glass")
	end

	overwrite("farming:rhubarb", 1)
	overwrite("farming:rhubarb_pie", 6)
	overwrite("farming:beans", 1)
	overwrite("farming:grapes", 2)
end

if minetest.get_modpath("kpgmobs") then

	overwrite("kpgmobs:uley", 3)
	overwrite("kpgmobs:meat", 6)
	overwrite("kpgmobs:rat_cooked", 5)
	overwrite("kpgmobs:med_cooked", 4)

	if minetest.get_modpath("bucket") then

		overwrite("kpgmobs:bucket_milk", 4, "bucket:bucket_empty")
	end
end

if minetest.get_modpath("jkfarming") then

	overwrite("jkfarming:carrot", 3)
	overwrite("jkfarming:corn", 3)
	overwrite("jkfarming:melon_part", 2)
	overwrite("jkfarming:cake", 3)
end

if minetest.get_modpath("jkanimals") then

	overwrite("jkanimals:meat", 6)
end

if minetest.get_modpath("jkwine") then

	overwrite("jkwine:grapes", 2)
	overwrite("jkwine:winebottle", 1)
end

if minetest.get_modpath("cooking") then

	overwrite("cooking:meat_beef_cooked", 4)
	overwrite("cooking:fish_bluewhite_cooked", 3)
	overwrite("cooking:fish_clownfish_cooked", 1)
	overwrite("cooking:meat_chicken_cooked", 2)
	overwrite("cooking:meat_cooked", 2)
	overwrite("cooking:meat_pork_cooked", 3)
	overwrite("cooking:meat_toxic_cooked", -3)
	overwrite("cooking:meat_venison_cooked", 3)
	overwrite("cooking:meat_undead_cooked", 1)
end

-- ferns mod of plantlife_modpack
if minetest.get_modpath("ferns") then

	overwrite("ferns:fiddlehead", 1, "", 1)
	overwrite("ferns:fiddlehead_roasted", 3)
	overwrite("ferns:ferntuber_roasted", 3)
	overwrite("ferns:horsetail_01", 1)
end

-- Xanadu server only
if minetest.get_modpath("xanadu") then

	overwrite("xanadu:cinnamon_roll", 4)
	overwrite("xanadu:pumpkin_pie", 10)
	overwrite("xanadu:french_toast", 2)
	overwrite("xanadu:icecream_strawberry", 3)
	overwrite("xanadu:icecream_melon", 4)
	overwrite("xanadu:milkshake_strawberry", 3, "vessels:drinking_glass")
	overwrite("xanadu:milkshake_banana", 4, "vessels:drinking_glass")
	overwrite("xanadu:iced_coffee", 3, "vessels:drinking_glass")
	overwrite("xanadu:pizza_slice", 3)
	overwrite("xanadu:cupcake", 4)
	overwrite("xanadu:cupcake_chocolate", 4)
	overwrite("xanadu:juice_apple", 4, "vessels:drinking_glass")
	overwrite("xanadu:juice_coconut", 4, "vessels:drinking_glass")
	overwrite("xanadu:juice_orange", 4, "vessels:drinking_glass")
	overwrite("xanadu:juice_cactus", 2, "vessels:drinking_glass")
	overwrite("xanadu:hotchocolate", 6, "bucket:bucket_empty")
	overwrite("xanadu:milk_chocolate", 3)
	overwrite("xanadu:chocolate_donut", 3)
	overwrite("xanadu:bacon", 4)
	overwrite("xanadu:burger", 7)
	overwrite("xanadu:fries", 6)
	overwrite("wine:glass_wine", 2)
	overwrite("wine:glass_beer", 2)
	overwrite("wine:glass_mead", 2)
	overwrite("wine:glass_cider", 2)
	overwrite("xanadu:potato_salad", 8, "ethereal:bowl", nil, 2)
	overwrite("xanadu:gingerbread_man", 2)
	overwrite("xanadu:taco", 4)
	overwrite("mobs:clownfish_raw", 2)
	overwrite("mobs:bluefish_raw", 2)
end

-- player-action based hunger changes
function hbhunger.handle_node_actions(pos, oldnode, player, ext)

	if not player or not player:is_player() then
		return
	end

	local name = player:get_player_name()
	local exhaus = hbhunger.exhaustion[name]

	if exhaus == nil then return end

	local new = HUNGER_EXHAUST_PLACE

	-- placenode event
	if not ext then
		new = HUNGER_EXHAUST_DIG
	end

	-- assume its send by main timer when movement detected
	if not pos and not oldnode then
		new = HUNGER_EXHAUST_MOVE
	end

	exhaus = exhaus + new

	if exhaus > HUNGER_EXHAUST_LVL then

		exhaus = 0

		local h = tonumber(hbhunger.hunger[name])

		h = h - 1

		if h < 0 then h = 0 end

		hbhunger.hunger[name] = h
		hbhunger.set_hunger(player)
	end

	hbhunger.exhaustion[name] = exhaus
end

--minetest.register_on_placenode(hbhunger.handle_node_actions)
minetest.register_on_dignode(hbhunger.handle_node_actions)
