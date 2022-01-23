debug 5

# Footsteps nearby make you wonder if you're pushing your luck.
# You don't see any likely marks in the area

var burgle_item $burgle_item

action var need_exit YES when Footsteps nearby make you wonder
action var surface counter when "Someone Else's Home, Kitchen"
action var surface bed when "Someone Else's Home, Bedroom"
action var surface table when "Someone Else's Home, Work Room"
action var surface desk when "Someone Else's Home, Sanctum"
action var surface rack when "Someone Else's Home, Armory"
action var surface bookshelf when "Someone Else's Home, Library"
var reverse_directions northeast-southwest northwest-southeast southeast-northwest southwest-northeast east-west west-east north-south south-north
var valid_directions northeast|northwest|southeast|southwest|east|west|north|south

var need_exit NO
var back_path

check_start:
  match start The heat has died down
  match need_to_wait You should wait at least
  put burgle recall
  matchwait

start:
  put get my %burgle_item
  if contains("%burgle_item", "rope") then {
    send uncoil my rope
  }
  gosub hide
  pause 1
  put burgle
  waitfor Obvious exits
  goto burgle

burgle:
  gosub search
  goto move_to_exit


search:
  search_do:

    if "%need_exit" = "YES" then goto move_to_exit

    match search_wait ...
    match search_do find nothing that looks valuable
    match RETURN you decide to take it
    match RETURN You've already picked
    put search %surface
    matchwait 2
    goto search_do

search_wait:
  pause 1
  goto search_do

hide:
  if "%need_exit" = "YES" then goto move_to_exit
  pause 0.1
  matchre hide ^\.\.\.wait\s+\d+\s+sec(?:onds|s)?\.?|^Sorry\,|fail|You are too close|^You are a bit|^You are too busy
  matchre hide notices your attempt|reveals you|ruining your hiding place|discovers you
  matchre RETURN ^You melt|^You blend|^Eh\?|^You slip|^Roundtime|You look around
  send hide
  matchwait

RETURN:
  pause 0.1
  return

move_to_exit:
  put go window
  goto done

done:
  if contains("%burgle_item", "rope") then {
    send coil my rope
  }

  send stow my %burgle_item
  pause
  put #parse BURGLE DONE
  exit

need_to_wait:
  put #parse BURGLE WAIT