#Circuit Alerter: (Working, Functional)

The circuit alerter is an alerter for the circuit network. Place a circuit alerter on the map and open up the GUI (default LMB) to customize the message. Anytime the condition is true it will display an alert to the location of your choice with your message. The alert is fully customizable and supports a set of custom variables that can be included in the message.  Unlocks after researching "circuit network".

#####Message Examples:

#####Message Output Variables: (case sensitive)
* $t: time of day
* $a: time of alert (in minutes:secs since world creation)
* $1: first condition
* $2: second condition
* $>: comparator
* $I: all connected signals as name:count
* $e: evolution factor
* $p: pollution level
* $P: player who made the alert
* $F: force the alerter is on
* $S: surface the alerter is on.
* $X: position of the alerter.

#####Display this message to:
* Player: player who made the alerter (default) or force if built by robots.
* Force: all players in the force that made the alerter.
* Surface: all players on the surface.
* ForceOnSurface: All players on the force that made the alerter that are on the same surface as the alerter
* All: everyone

#####Alert Types:
* All alerts will show up in the expandable list at the top depending on who we are displaying to but we can also specify other locations
* Pop-up: Pops up on the center of the screen
* Goal: pops up in the top left as a player goal
* Flying Text: Pops a flying message over the alerter and anyone it is displaying too (anyone close enough can see this message)
* Console: Prints to the console.
* Map Marker: Make a marker on the map.
* Sound: Play a sound on this alert.

---
####Circuit Poles: (Working, Functional, no gui yet)
Circuit Poles are electric poles with no supply area, and default to connecting red circuit wires.  
Any time an electric pole or circuit pole is held in the hand a small gui pops up allowing you to change which wires are connected. Unlocks after researching "circuit network".

---
####TODO:
* Unique graphics for the small and medium circuit poles. [Help Wanted]

---
####Recommended mods:
This is a list of mods that compliment the circuit and rail networks.

* [Nixie Tubes:](https://mods.factorio.com/mods/justarandomgeek/nixie-tubes) Pretty tubes for displaying circuit information
* [Smart Display:](https://mods.factorio.com/mods/binbinhfr/SmartDisplay) Displays messages and circuit values on the surface/map
* [Train Speed Limits:](https://mods.factorio.com/mods/icedevml/TrainSpeedLimit) Set the speed limit of your train based on a signal condition. Great for slowing down trains in your base or areas of construction.
* [Signposts:](https://mods.factorio.com/mods/icedevml/Signposts) Put readable signs around your base with information.
* [Smart Trains:](https://github.com/Choumiko/SmartTrains/releases) For reading the contents of the whole train and dynamic scheduling.
* [Shuttle Train:](https://mods.factorio.com/mods/simwir/ShuttleTrain) Your own personal train(s) that you can call to you and send to anywhere.
* [FARL:](https://mods.factorio.com/mods/Choumiko/FARL) The automatic rail layer
* [Foreman:](https://mods.factorio.com/mods/Choumiko/Foreman) A blueprint manager

---
####Planned integrations:
Extending the capabilities of the following mods if they are installed: (Ideas only so far)

* YARM: Read the output of stored site.
* Signposts: Change the text on a sign to the alert message.

---
####Contributions and Thanks:

Some concepts for this mod came from existing mods no longer being developed. Other concepts may have bits and pieces borrowed from existing mods, but not as a replacement for those mods.  Except for some of the rail logic stuff. I was 90% through the code when it got updated:)

* perky: For the original base of this mod
* Afforess: for the [Factorio Standard Library](https://github.com/Afforess/factorio-Stdlib)
* [Mooncat:](https://mods.factorio.com/mods/Mooncat) for the awesome message editor.
* XCodersTeam: for the rail logic graphics and code.
* YARM/narc0tiq: for the [YARM](https://mods.factorio.com/mods/Narc/YARM) expando stuff.
* [binbinhfr:](https://mods.factorio.com/mods/binbinhfr) for utils and concepts. Be sure to check out his awesome mods.

---
#####MODS used while developing Circuit Stuff:
* Creative Mode, AutoTrash, AutoFill, Renamer, Picker (custom version), 
* Foreman, Time Tools, Smart Display, YARM
* Shuttle Train, Fat Controller, Smart Trains, FARL
* Train Speed Limits, Signposts, Item Count
