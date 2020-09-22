## Description: ##
This mod provides a api to handle factions as well as reputation of players in different factions.
It supports temporary faction members to allow mobs joining a faction.
This mod is inspired by old faction mod sadly providing a chat interface only. If you currently used old faction mod you can use this one with very few changes.

## Notes: ##

* Factions are world specific.
* data storage is not compatible with old faction mod (sorry)
* formspec gui is missing

## License: ##
WTFPL

## Dependencies: ##
* default

## Version ##
* 0.1.5

## Chatcommand Documentation: ##

initial privs have to be given by server admin, there are 2 privs for factions:

**factions_admin:**

Can do everything with any faction including creating a faction.

**factions_user:**

players allowed to use factions in general.

Further there can be faction admins, those can invite/remove any player having factions_user right to the faction they are admin for, as well as give other users admin right for their faction too.

### User commands: ###

**/factions** -> info on your current factions

**/factions info <factionname>** -> show description of faction

**/factions list** -> show list of factions

**/factions leave <factionname>** -> leave specified faction

**/factions join <factionname>** -> join specified faction


### Admin commands: ###

**/factions create <factionname>** -> create a new faction

**/factions delete <factionname>** -> delete a faction

**/factions leave <factionname> <playername>** -> remove player from faction

**/factions invite <factionname> <playername>** -> invite player to faction

**/factions set_free <factionname> <true/false>** -> set faction free to join

**/factions admin <factionname> <playername> <true/false>** -> make player admin of faction

**/factions description <factionname> <text>** -> set description for faction


## Changelog: ##

0.1.5

* add default group players

0.1.4

* fix various issues becoming obvious on integration to mobf

0.1.3

* fix crash on adding first member

0.1.2

* fix crash on specifying invalid faction to chathandler

0.1.1

* fixed bug in chathandlers
* fixed invalid help text

0.1.0

* Initial version