Due to a new feature in Minetest, players can be disconnected by mods even before they actually join the game. This has several advantages over the traditional ban on join followed shortly by unban:

The player file does not actually get created, thus avoiding cluttering up the world's 'players' directory.
The join/leave callbacks do not actually get called, thus saving some processing and/or memory (and avoids spamming the chat with join/leave messages).
Does not modify the ban list in any way. "Kick user"-type mods usually implement the "kick" as a ban followed shortly by an unban, but this had the problem that if the server crashes between those actions, the player will be banned permanently until manually unbanned.

Now I present you the true and only No More Guests®©™ mod!

All this mod does is simply disconnect all "Guest" accounts (players named "Guest" followed by a number, a feature that some (most?) server owners find annoying.

In addition to this, and thanks to VanessaE for the ideas, it also disallows all-numeric names, names containing enther "guest" or "admin" (case insensitive), and names containing excessive numbers.

Also, thanks to sfan5 for letting me steal^Wborrow his code to detect "junk names". This mod does not allow players with gibberish names.