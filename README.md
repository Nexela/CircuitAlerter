#Circuit Alerter:

The circuit alerter is an alerter for the circuit network. Place a circuit alerter on the map and open up the GUI (default LMB) to customize the message. Anytime the condition is true it will broadcast an alert to the location of your choice with your message as well as putting the alert on your hud. The alert is fully customizable and supports a set of custom variables that can be included in the message.  Unlocks after researching "circuit network".

This mod is a work in progress so expect occasional updates as new new features, requests, and bug fixes get added in.

#####Message Examples:
Todo

#####Message Output Variables: (case sensitive)
Todo

#####Display this message to:
Todo

#####Alert Types:
* All alerts will show up in the expandable list at the top depending on who we are displaying to but we can also specify other locations
* Pop-up: Pops up on the center of the screen
* Goal: pops up in the top left as a player goal -- Not implemented yet
* Flying Text: Pops a flying message over the heads of anyone targeted (anyone close enough to that person can also see this message)
* Console: Prints to the console.
* Map Marker: Make a marker on the world map.
* Sound: Play a sound on this alert. -- Not implemented yet

#####Color Picker Support:
Easily select the color of your alert by adding the [Color Picker](https://mods.factorio.com/mods/Mooncat/color-picker) mod by [Mooncat](https://mods.factorio.com/mods/Mooncat), Currently this is the only way to change colors because I forgot to add it in an alternative way:)


---
####Circuit Poles: 
Circuit Poles are electric poles with no supply area, and default to connecting red circuit wires.  

Any time an electric pole or circuit pole is held in the hand a small gui pops up allowing you to change which wires are connected. This is not implemented yet.

Unlocks after researching "circuit network".

---
####TODO:
* Unique graphics for the small and medium circuit poles. [Help Wanted]

---
####Recommended mods:
This is a list of mods that compliment the circuit network.

* [Nixie Tubes:](https://mods.factorio.com/mods/justarandomgeek/nixie-tubes) Pretty tubes for displaying circuit information
* [Smart Display:](https://mods.factorio.com/mods/binbinhfr/SmartDisplay) Displays messages and circuit values on the surface/map
* [Train Speed Limits:](https://mods.factorio.com/mods/icedevml/TrainSpeedLimit) Set the speed limit of your train based on a signal condition. Great for slowing down trains in your base or areas of construction.
* [Signposts:](https://mods.factorio.com/mods/icedevml/Signposts) Put readable signs around your base with information.
* [Foreman:](https://mods.factorio.com/mods/Choumiko/Foreman) A blueprint manager

---
####Planned integrations:
Extending the capabilities of the following mods if they are installed: (Ideas only so far)

* YARM: Read the output of stored site.
* Signposts: Change the text on a sign to the alert message.

---
####Contributions and Thanks:

Some concepts for this mod came from existing mods no longer being developed. Other concepts may have bits and pieces borrowed from existing mods, but not as a replacement for those mods.

* perky: For the original base of this mod
* Afforess: for the [Factorio Standard Library](https://github.com/Afforess/factorio-Stdlib)
* [Mooncat:](https://mods.factorio.com/mods/Mooncat) for the awesome message editor.
* YARM/narc0tiq: for the [YARM](https://mods.factorio.com/mods/Narc/YARM) expando stuff.
* [binbinhfr:](https://mods.factorio.com/mods/binbinhfr) for utils and concepts. Be sure to check out his awesome mods.

---
#####MODS used while developing Circuit Stuff:
* Creative Mode, AutoTrash, AutoFill, Renamer, Picker (custom version), 
* Foreman, Time Tools, Smart Display, YARM
* Shuttle Train, Fat Controller, Smart Trains, FARL
* Train Speed Limits, Signposts, Item Count
* Color Picker
