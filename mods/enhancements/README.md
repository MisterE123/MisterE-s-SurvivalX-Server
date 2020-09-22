# enhancements
Adds various enhancements to Minetest game and server tools.

To install, rename to "enhancements" and place in the mods/ directory.

* scale and override different tools
* clean-up server - unknown nodes and entities
* [external_cmd]server chat messages from outside Minetest game
* detect AFK player
* spawn - set and go to static spawn point
* teleport request (/tpr /tphr to teleport to player)
* playeranim - Adds animations to the players' head and right arm
* areas - control privilages (WIP)

External Commands
------------------
This mod allows sending chat messages from outside minetest. Support for server commands is planned.
The following command will send a chat message to all players on the server:

	echo [message] > [mod folder]/message
	echo [message] > [world folder]/message

The mod folder depends on where you installed the mod; it is usually “~/.minetest/mods/minetest/external_cmd”
Also can be added to the World directory. You have to create a "SERVER" user and grant him all privs - this account should not be active and used only for displaying the images.

Areas Enhance - WIP
--------------------

Manage players privileges in 'areas' mod if using the mod only for admin purposes

TODO:
* create tables from where you can read/write the privileges
* don't repeat grand/revoke on globalstep - only once when in/out of area - check within tables!

Detect AFK player
------------------

AFK (away from keyboard) is detected when player doesn't move for certain time, player will sit down.

Item drop mod for MINETEST-C55
-------------------------------------
by PilzAdam

Introduction:
This mod adds Minecraft like drop/pick up of items to Minetest.

How to install:
Unzip the archive an place it in minetest-base-directory/mods/minetest/
if you have a windows client or a linux run-in-place client. If you have
a linux system-wide instalation place it in ~/.minetest/mods/minetest/.
If you want to install this mod only in one world create the folder
worldmods/ in your worlddirectory.
For further information or help see:
http://wiki.minetest.com/wiki/Installing_Mods

How to use the mod:
Just install it an everything works.

For developers:
You dont have to use get_drops() anymore because of changes in the
builtin files of minetest.

License:
Sourcecode: WTFPL (see below)
Sound: WTFPL (see below)

See also:
http://minetest.net/

         DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.

Teleport Request
-----------------
This mod is released under WTFPL.
It adds ability to teleport to other players with their permission by using the /tpr command which requires "interact" privilege and the /tphr command which requires the "interact " privilege.
