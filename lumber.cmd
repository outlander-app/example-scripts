#debug 5

var item %1
var container backpack
var belt carpenter's belt 
var has_craft_belt $has_shaping_craft_belt
var wood.saw slender saw
var types log|limb|branch|stick
var currentType 0

if_3 then var currentType %3
if_2 then goto %2

Get.Item:
  pause 0.5
  matchre next What were you referring to
  matchre Get.Saw You get|already holding that
  put get my %item %types(%currentType)
  matchwait 3
  goto Get.Item

next:
  math currentType add 1
  if %currentType >= 4 then goto done
  goto Get.Item

Get.Saw:
  gosub swap.tool %wood.saw
  goto Cut

Cut:
  matchre Get.Drawknife you complete sawing|ready to be carved with a drawknife
  matchre Cut Roundtime
  matchre done that should only be used on raw wood
  put cut my %types(%currentType) with my saw
  matchwait 3
  goto Cut

Get.Drawknife:
  gosub swap.tool drawknife
  goto Scrape

Scrape:
  matchre stow You cannot figure out how to do that|At last your work completes
  matchre Scrape Roundtime
  put scrape my %types(%currentType) with my drawknife
  matchwait 3
  goto Scrape

stow:
  pause 1
  gosub stow.tool
  put stow my lumber
  pause 1
  goto Get.Item

swap.tool:
  var tool $0
  if !contains("$lefthand" != "%tool") then
  {
    if ("$lefthand" != "Empty") then gosub stow.tool
    pause 0.5
    matchre %last \.\.\.wait|Sorry
    matchre RETURN You get|You remove
    #if "%has_craft_belt" = "YES" then put untie my %tool
    #else put get my %tool
    put untie my %tool
    put get my %tool in my %container
    matchwait 5
    goto done
  }
  pause 0.5
  return

stow.tool:
  pause 0.5
  matchre RETURN You attach|You put|Tie what
  matchre stow.tool.2 doesn't seem to fit
  if "%has_craft_belt" = "YES" then put tie my $lefthandnoun to my %belt
  else put put my $lefthandnoun in my %container
  matchwait

stow.tool.2:
  put put my $lefthandnoun in my %container
  return

RETURN:
  pause 0.5
  return


done:
  pause 1
  put stow right
  put stow left
  put #parse LUMBER DONE