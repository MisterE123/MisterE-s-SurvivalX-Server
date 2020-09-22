-- chat3/init.lua
-- implemented chat_anticurse by SaKeL:
-- Minetest 0.4.10+ mod: chat_anticurse
-- punish player for cursing by disconnecting them
--
--  Created in 2015 by Andrey. 
--  This mod is Free and Open Source Software, released under the LGPL 2.1 or later.
-- 
-- See README.txt for more information.

chat_anticurse = {}
chat_anticurse.simplemask = {}

chat3 = {}

chat3.settings = {}
chat3.storage = minetest.get_mod_storage()

local modpath = minetest.get_modpath("chat3")

---
--- Handle Settings
---

-- [function] Get float setting
function chat3.settings.get_int(key)
	local res = minetest.settings:get(key)
	if res then
		return tonumber(res)
	end
end

-- [function] Get boolean setting
function chat3.settings.get_bool(key, default)
	local retval = minetest.settings:get_bool(key)

	if default and retval == nil then
		retval = default
	end

	return retval
end

local prot = {} -- Table of protocol versions - to be used later

local bell   = chat3.settings.get_bool("chat3.bell")
local shout  = chat3.settings.get_bool("chat3.shout")
local prefix = minetest.settings:get("chat3.shout_prefix") or "!"
local near   = chat3.settings.get_int("chat3.near") or 12
local ignore = chat3.settings.get_bool("chat3.ignore", true)
local alt    = chat3.settings.get_bool("chat3.alt_support", true)

if prefix:len() > 1 then
	prefix = "!"
end

-- some english and some russian curse words
-- i don't want to keep these words as cleartext in code, so they are stored like this.
local x1="a"
local x2="i"
local x3="u"
local x4="e"
local x5="o"
local y1="y"
local y2="и"
local y3="о"
local y4="е"
local y5="я"

chat_anticurse.simplemask[1] = " c"..x3.."nt "
chat_anticurse.simplemask[2] = " d" .. ""..x2.."ck"
chat_anticurse.simplemask[3] = " p"..x4.."n" .. "is"
chat_anticurse.simplemask[4] = " p" .. ""..x3.."ssy"
chat_anticurse.simplemask[5] = " h"..x5.."" .. "r".."ny "
chat_anticurse.simplemask[6] = " b"..x2.."" .. "tch "
chat_anticurse.simplemask[7] = " b"..x2.."" .. "tche"
chat_anticurse.simplemask[8] = " s"..x4.."" .. "x"
chat_anticurse.simplemask[9] = " "..y4.."б" .. "а"
chat_anticurse.simplemask[10] = " бл"..y5.."" .. " "
chat_anticurse.simplemask[11] = " ж" .. ""..y3.."п"
chat_anticurse.simplemask[12] = " х" .. ""..y1.."й"
chat_anticurse.simplemask[13] = " ч" .. "л"..y4.."н"
chat_anticurse.simplemask[14] = " п"..y2.."" .. "зд"
chat_anticurse.simplemask[15] = " в"..y3.."" .. "збуд"
chat_anticurse.simplemask[16] = " в"..y3.."з" .. "б"..y1.."ж"
chat_anticurse.simplemask[17] = " сп"..y4.."" .. "рм"
chat_anticurse.simplemask[18] = " бл"..y5.."" .. "д"
chat_anticurse.simplemask[19] = " бл"..y5.."" .. "ть"
chat_anticurse.simplemask[20] = " с" .. ""..y4.."кс"
chat_anticurse.simplemask[21] = " f" .. ""..x3.."ck"
chat_anticurse.simplemask[22] = ""..x1.."rs"..x4.."h"..x5.."l"..x4..""
-- chat_anticurse.simplemask[23] = " "..x1.."s" .. "s "

chat_anticurse.check_message = function(name, message)
	local checkingmessage = string.lower( name.." "..message .." " )
	local uncensored = 0

	-- check for any swear occurance from simplemask
	for i=1, #chat_anticurse.simplemask do
		-- split sentence in to words and check every word
		-- print("find mask: ", chat_anticurse.simplemask[i]:gsub("%s+", ""))

		for j in string.gmatch(checkingmessage, "%S+") do
			-- remove any remaining spaces from chat word and simplemask word and check for any swear occurance
			-- print("in chat word: ", j:gsub("%s+", ""))
			if string.find(j:gsub("%s+", ""), chat_anticurse.simplemask[i]:gsub("%s+", ""), 1, true) ~= nil then
				-- print("found: ", j:gsub("%s+", ""))
				uncensored = 2
				break
			end
		end

		if uncensored == 2 then break end
	end
	
	--additional checks
	if string.find(checkingmessage, " c"..x3.."" .. "m ", 1, true) ~=nil and 
		not (string.find(checkingmessage, " c"..x3.."" .. "m " .. "se", 1, true) ~=nil) and
		not (string.find(checkingmessage, " c"..x3.."" .. "m " .. "to", 1, true) ~=nil) then
		uncensored = 2
	end
	return uncensored
end

---
--- Load Features
---

if ignore then dofile(modpath.."/ignore.lua") end -- Load ignore
if alt then dofile(modpath.."/alt.lua") end -- Load alt

---
--- Exposed Functions (API)
---

-- [function] Colorize
function chat3.colorize(name, colour, msg)
	local vers = prot[name]
	if vers and vers >= 27 then
		return minetest.colorize(colour, msg)
	else
		return msg
	end
end

-- [function] Check if mentioned (should highlight or not)
function chat3.is_mentioned(name, msg)
	name, msg = name:lower(), msg:lower()

	-- Direct mentions
	local direct_mention = msg:find(name, 1, true)

	-- Alt mentions
	local alt_mention
	if alt then
		local list = chat3.alt.get(name)
		for alt, i in pairs(list) do
			alt_mention = msg:find(alt, 1, true) or alt_mention
		end
	end

	return direct_mention or alt_mention
end

-- [function] Process
function chat3.send(name, msg, prefix, source)
	if minetest.get_modpath("ranks") and source ~= "ranks" then
		return
	end

	local sender = minetest.get_player_by_name(name)
	local privs = minetest.get_player_privs(name)

	if not privs.shout then
		return
	end

	for _, player in pairs(minetest.get_connected_players()) do
		local rname  = player:get_player_name()
		local colour = "#ffffff"

		local vers = prot[rname]
		if (not vers or (vers and (vers >= 29 or (vers < 29 and name ~= rname))))
				and (not ignore or not chat3.ignore.is(rname, name)) then
			-- Check for near
			if near ~= 0 then -- and name ~= rname then
				if vector.distance(sender:getpos(), player:getpos()) <= near then
					colour = "#88ffff"
				end
			end

			-- Check for mentions
			if chat3.is_mentioned(rname, msg) then
				colour = "#00ff00"

				-- Chat bell
				if bell and name ~= rname then
					local pbell = player:get_attribute("chat3:bell")
					if pbell ~= "false" then
						minetest.sound_play("chat3_bell", {
							gain = 4,
							to_player = rname,
						})
					end
				end
			end

			-- Check for shout
			if shout and msg:sub(1, 1) == prefix then
				colour = "#ff0000"

				-- Chat bell
				if bell and name ~= rname then
					local pbell = player:get_attribute("chat3:bell")
					if pbell ~= "false" then
						minetest.sound_play("chat3_bell", {
							gain = 4,
							to_player = rname,
						})
					end
				end
			elseif name == rname then
			-- if same player, set to white (not for shouting)
				colour = "#ffffff"
			end

			-- Send message
			local send = chat3.colorize(rname, colour, "<"..name.."> "..msg)
			-- if prefix then
			-- 	send = prefix..send
			-- end

			minetest.chat_send_player(rname, send)
		end
	end

	-- Log message
	minetest.log("action", "CHAT: ".."<"..name.."> "..msg)

	-- Prevent from sending normally
	return true
end

---
--- Events/Definitions
---

-- [event] On join player
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local info = minetest.get_player_information(name)

	if not info then
		minetest.log("warning", "[chat3] Didn't found player_information for player: "..name..". Falling back to old chat.")
		prot[name] = 0
	else
		prot[name] = info.protocol_version
	end

end)

-- [event] On chat message
minetest.register_on_chat_message(function(name, msg)
	local uncensored = chat_anticurse.check_message(name, msg)
	local privs = minetest.get_player_privs(name)

	if uncensored == 1 then
		if privs.privs then return end
		minetest.kick_player(name, "Hey! Was there a bad word?")
		minetest.log("action", "Player "..name.." warned for cursing. Chat:"..msg)
		return true
	end

	if uncensored == 2 then
		if privs.privs then return end
		minetest.kick_player(name, "Cursing or words, inappropriate to game server. Kids may be playing here!")
		minetest.chat_send_all("Player <"..name.."> warned for cursing" )
		minetest.log("action", "Player "..name.." warned for cursing. Chat:"..msg)
		return true
	end

	return chat3.send(name, msg, prefix)
end)

-- [redefine] /msg
if minetest.chatcommands["msg"] then
	local old_command = minetest.chatcommands["msg"].func
	minetest.override_chatcommand("msg", {
		func = function(name, param)
			local uncensored = chat_anticurse.check_message(name, param)
			local privs = minetest.get_player_privs(name)

			if uncensored == 1 then
				if privs.privs then return end
				minetest.kick_player(name, "Hey! Was there a bad word?")
				minetest.log("action", "Player "..name.." warned for cursing. Msg:"..param)
				return
			end

			if uncensored == 2 then
				if privs.privs then return end
				minetest.kick_player(name, "Cursing or words, inappropriate to game server. Kids may be playing here!")
				minetest.chat_send_all("Player <"..name.."> warned for cursing" )
				minetest.log("action", "Player "..name.." warned for cursing. Msg:"..param)
				return
			end

			local sendto, message = param:match("^(%S+)%s(.+)$")
			if not sendto then
				return false, "Invalid usage, see /help msg."
			end
			if not minetest.get_player_by_name(sendto) then
				return false, "The player " .. sendto
						.. " is not online."
			end

			if ignore and chat3.ignore.is(sendto, name) then
				return false, chat3.colorize(name, "red",
						"Could not send message, you are on "..sendto.."'s ignore list.")
			else

				minetest.log("action", "PM from " .. name .. " to " .. sendto
						.. ": " .. message)
				minetest.chat_send_player(sendto, chat3.colorize(sendto, '#ffff00',
						"PM from " .. name .. ": ".. message))

				if bell then
					local player = minetest.get_player_by_name(sendto)
					local pbell = player:get_attribute("chat3:bell")
					if pbell ~= "false" then
						minetest.sound_play("chat3_bell", {
							gain = 4,
							to_player = sendto,
						})
					end
				end

				if ignore and chat3.ignore.is(name, sendto) then
					return true, "Message sent.\n"..chat3.colorize(name, "red",
							"Warning: "..sendto.." will not be able to respond to this"
							.." message unless you remove them from your ignore list.")
				else
					return true, "Message sent."
				end
			end
		end,
	})
end

-- [redefine] /me
if minetest.chatcommands["me"] then
	local old_command = minetest.chatcommands["me"]
	minetest.override_chatcommand("me", {
		func = function(name, param)
			local uncensored = chat_anticurse.check_message(name, param)
			local privs = minetest.get_player_privs(name)

			if uncensored == 1 then
				if privs.privs then return end
				minetest.kick_player(name, "Hey! Was there a bad word?")
				minetest.log("action", "Player "..name.." warned for cursing. Msg:"..param)
				return
			end

			if uncensored == 2 then
				if privs.privs then return end
				minetest.kick_player(name, "Cursing or words, inappropriate to game server. Kids may be playing here!")
				minetest.chat_send_all("Player <"..name.."> warned for cursing" )
				minetest.log("action", "Player "..name.." warned for cursing. Me:"..param)
				return
			end

			for _, player in pairs(minetest.get_connected_players()) do
				local rname = player:get_player_name()

				if not ignore or not chat3.ignore.is(rname, name) then
					minetest.chat_send_player(rname, "* "..name.." "..param)
				end
			end
		end,
	})
end

-- [chatcommand] Chatbell
if bell then
	minetest.register_chatcommand("chatbell", {
		description = "Enable/disable chatbell when you are mentioned in the chat",
		func = function(name)
			local player = minetest.get_player_by_name(name)
			if player then
				local bell = player:get_attribute("chat3:bell")
				if not bell or bell == "" or bell == "true" then
					player:set_attribute("chat3:bell", "false")
					return true, "Disabled Chatbell"
				else
					player:set_attribute("chat3:bell", "true")
					return true, "Enabled Chatbell"
				end
			end
		end,
	})
end
