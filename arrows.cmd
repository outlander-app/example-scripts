#debug 5

var arrowhead %1
var container $primary.container
var belt carpenter's belt 
var has_craft_belt $has_shaping_craft_belt
var mark ON

var need_arrowhead NO
var need_flights NO
var excess_shafts NO
var done NO

action var need_arrowhead YES when You need another ([\w-]+) arrowheads
action var need_flights YES when You need another arrow flights
action var excess_shafts YES when You place the excess parts at your feet
action var done YES when Applying the final touches, you complete working

if_2 then goto %2

Glance:
  put inv held
  match Get.Knife arrows
  match GetBook shafts
  match NotEnough Both of your hands are empty.
  matchwait

GetBook:
  put get my shaping book;study my book
  waitfor Roundtime
  pause 1
  put stow my book
  waitfor You put
  goto Get.Shaper

fletch:
  matchre done You cannot figure out how to do that
  matchre Get.Knife A handful of rough edges require carving with a knife to remove|ready to be trimmed with a carving knife
  matchre Get.Glue ready for an application of glue|You need another ([\w-]+) arrowheads|You need another arrow flights
  matchre Get.Stamp Applying the final touches, you complete working
  matchre Get.Shaper Roundtime
  matchwait

Get.Drawknife:
  pause 1
  gosub swap.tool drawknife
  var tool drawknife
  pause 0.5
DrawScrape:
  save DrawScrape
  put scrape my shaft with my drawknife
  goto fletch

Get.Knife:
  pause 1
  if "%need_arrowhead" = "YES" then gosub Arrowhead
  if "%need_flights" = "YES" then gosub Flights
  gosub swap.tool carving knife
  var tool rasp
  pause 0.5
Carve:
  save Carve
  put carve my $righthandnoun with my knife
  goto fletch

Get.Shaper:
  pause 1
  if "%need_arrowhead" = "YES" then gosub Arrowhead
  if "%need_flights" = "YES" then gosub Flights
  if "%done" = "YES" then goto done
  gosub swap.tool shaper
  var tool shaper
  pause 0.5
Shape:
  save Shape
  put shape my $righthandnoun with my shaper
  goto fletch

Get.Glue:
  pause 1
  if "%need_arrowhead" = "YES" then gosub Arrowhead
  if "%need_flights" = "YES" then gosub Flights
  gosub swap.tool glue
  var tool glue
  pause 0.5
Glue:
  save Glue
  put apply my glue to my arrows
  goto fletch

Get.Stamp:
  pause 1
  if "%mark" != "ON" then goto done
  gosub swap.tool stamp

  if "$lefthand" = "Empty" then goto done

Mark:
  put mark my %1 with my stamp
  waitforre Roundtime|too badly damaged to be used
  pause 1
  goto done

Arrowhead:
  pause 0.5
  gosub swap.tool %arrowhead arrowheads
  put assemble my arrows with my arrowhead
  waitforre You place
  var need_arrowhead NO
  pause 0.5
  return

Flights:
  pause 0.5
  gosub swap.tool flights
  put assemble my arrows with my flights
  waitforre You place
  var need_flights NO
  pause 0.5
  return

swap.tool:
  var tool $0
  if !contains("$lefthand", "%tool") then
  {
    if ("$lefthand" != "Empty") then { gosub stow.tool }
    pause 0.5
    matchre %last \.\.\.wait|Sorry
    matchre RETURN You get|You remove|You untie
    if "%has_craft_belt" = "YES" then { put untie my %tool from %belt }
    else { put untie my %tool }
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
  gosub stow.tool
  put stow my shafts
  put #parse WOODWORK DONE