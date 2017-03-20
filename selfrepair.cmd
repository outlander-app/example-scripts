# Self repair crafting tools

debug 5

var container $primary.container
var forging.hammer $forging.hammer
var has_craft_belt NO
var belt

var target %1

gosub %target
goto done

all:
  gosub stamp
  gosub outfit
  gosub shaping
  gosub engine
  gosub forge
  return

stamp:
  gosub repair.all stamp
  return

outfit:
  var tools needles|scissors|slickstone|yardstick|hide scraper|awl
  var belt outfit belt
  var has_craft_belt YES
  gosub repair.all %tools
  return

shaping:
  var tools carving knife|shaper|rasp|drawknife|clamps|slender saw
  var belt carp belt
  var has_craft_belt YES
  gosub repair.all %tools
  return

engine:
  var tools chisels|rifflers|rasp|fine saw|pliers
  var belt engine belt
  var has_craft_belt YES
  gosub repair.all %tools
  return

forge:
  var tools %forging.hammer|tongs|bellows|shovel|rod
  var belt forger belt
  var has_craft_belt YES
  gosub repair.all %tools
  return

repair.all:
  var list $0
  var list_count 0
  eval list_max countsplit("%list","|")

  if %list_max = 0 then var list_max 1

  repair.loop:
    if %list_count < %list_max then {
      gosub repair %list(%list_count)
      math list_count add 1
      goto repair.loop
    }

  gosub tie.all %list

  return

repair:
  put .metal_repair $0
  waitforre ^REPAIR DONE
  return

tie.all:
  var list $0
  var list_count 0
  eval list_max countsplit("%list","|")

  tie.loop:
    if %list_count < %list_max then {
      gosub tie %list(%list_count)
      math list_count add 1
      goto tie.loop
    }
  return

tie:
  var item $0
  send get my %item
  pause 0.5
  matchre RETURN You attach|You put|Tie what
  matchre tie.tool.2 doesn't seem to fit
  if "%has_craft_belt" = "YES" then put tie my %item to my %belt
  else put put my %item in my %container
  matchwait 2
  goto tie.tool.2

tie.tool.2:
  put put my %item in my %container
  return

RETURN:
  return

done:
  put #parse SELF-REPAIR DONE
