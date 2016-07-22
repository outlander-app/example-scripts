#debug 5

var item %1
var container $primary.container
var belt carpenter's belt 
var has_craft_belt $has_shaping_craft_belt

var need_string NO
var need_strips NO

action var need_string YES when You need another finished bow string to continue
action var need_strips YES when ready to be strengthened with some leather strips

if_2 then goto %2

GetBook:
  put get my shaping book;study my book
  waitfor Roundtime
  pause 1
  put stow my book
  waitfor You put
  goto Get.Clamps

fletch:
  matchre Get.Rasp A bulbous knot
  matchre Get.Backer ready to be reinforced with some backer material
  matchre Get.Strips when ready to be strengthened with some leather strips|ready to be assembled with leather strips
  matchre Get.Knife more fine detail carved
  matchre Get.Shaper Shaping with a wood shaper is needed
  matchre Get.Clamps The bow now must be pushed with clamps or a vice to hold it in place
  matchre Get.Stain Some wood stain should be applied to the wood to finish it|You need another finished bow string to continue
  matchre Get.Glue Glue should now be applied so assembly can begin
  matchre done Applying the final touches, you complete working|cable-backing process|successful lamination process|successful lightening process|The bow has already had its draw strength adjusted
  matchwait

Get.Drawknife:
  pause 1
  gosub swap.tool drawknife
  var tool drawknife
  pause 0.5
DrawScrape:
  save DrawScrape
  put scrape my lumber with my drawknife
  goto fletch

Get.Knife:
  pause 1
  gosub swap.tool carving knife
  var tool rasp
  pause 0.5
Carve:
  save Carve
  put carve my %item with my knife
  goto fletch

Get.Rasp:
  pause 1
  gosub swap.tool rasp
  var tool rasp
  pause 0.5
Scrape:
  save Scrape
  put scrape my %item with my rasp
  goto fletch

Get.Shaper:
  pause 1
  gosub swap.tool shaper
  var tool shaper
  pause 0.5
Shape:
  save Shape
  put shape my %item with my shaper
  goto fletch

Get.Clamps:
  pause 1
  gosub swap.tool clamps
  var tool clamps
  pause 0.5
Clamp:
  save Clamp
  put push my %item with my clamps
  goto fletch

Get.Glue:
  pause 1
  gosub swap.tool glue
  var tool glue
  pause 0.5
Glue:
  save Glue
  put apply my glue to my %item
  goto fletch

Get.Backer:
  pause 1
  gosub swap.tool backer
  pause 0.5
Backer:
  save Backer
  put assemble my backer with my %item
  goto Get.Clamps

Get.Strips:
  pause 1
  gosub swap.tool strips
  pause 0.5
Strips:
  save Strips
  put assemble my strips with my %item
  goto Get.Knife

Get.Stain:
  pause 1
  if "%need_string" = "YES" then gosub Bowstring
  gosub swap.tool wood stain
  var tool clamps
  pause 0.5
Stain:
  save Stain
  put apply my stain to my %item
  goto fletch

Bowstring:
  pause 0.5
  gosub swap.tool bow string
  put assemble my bow string with my %item
  pause 0.5
  return

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
    put untie my %tool from my %belt
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
  if "$lefthand" != "Empty" then put put my $lefthandnoun in my %container
  put #parse FLETCHING DONE