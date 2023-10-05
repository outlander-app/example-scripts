# debug 5

var item %1
var material lumber
var container $primary.container
var belt carpenter's belt
var has_craft_belt $has_shaping_craft_belt
var mark ON

var need_string NO
var need_backer NO
var need_strips NO
var need_long_pole NO

action var need_string YES when You need another finished bow string to continue
action var need_backer YES when You need another bone, wood or horn backing material
action var need_strips YES when You need another finished leather strips
action var need_long_pole YES when You need another finished long wooden pole

action var yards $1 when \((\d+) pieces\)$
action var yards 1 when \(1 pieces\)$
action var have $1 when You count out (\d+) pieces of lumber remaining\.$

if_2 then goto %2

Glance:
  matchre Get.Knife %item
  matchre Top lumber
  matchre NotEnough Both of your hands are empty
  put inv held
  matchwait

Top:
  put get my shaping book
  pause 0.5
  put read my book;count my %material
  pause 0.5
  put enc
  waitfor Encumbrance
  pause 0.5
  if %yards = %have then goto GetBook
  if %yards > %have then goto NotEnough
  put stow book
  match CutLumber You count out
  match NotEnough There is not enough
  put mark my %material at %yards
  matchwait

CutLumber:
  #var orig_has_craft_belt %has_craft_belt
  #var has_craft_belt NO
  gosub swap.tool scissors
  put cut my %material with my scissors
  waitfor You carefully cut
  gosub stow.tool
  #var has_craft_belt %orig_has_craft_belt
  put stow right
  waitfor You put
  put get my %material
  waitfor You pick up

GetBook:
  put get my shaping book;study my book
  waitfor Roundtime
  pause 1
  put stow my book
  waitfor You put
  goto Get.Drawknife

fletch:
  matchre Get.Rasp A bulbous knot
  matchre Get.Knife more fine detail carved
  matchre Get.Shaper Shaping with a wood shaper is needed to smooth the upper and lower limbs|Shaping with a wood shaper is needed|You need another finished leather strips
  matchre Get.Clamps now must be pushed with clamps or a vise|ready to be clamped together
  matchre Get.Stain Some wood stain should be applied to the wood to finish it|You need another finished bow string to continue
  matchre Get.Glue Glue should now be applied|You need another bone, wood or horn backing material to continue
  matchre Get.Stamp Applying the final touches, you complete working
  matchwait

Get.Drawknife:
  pause 1
  gosub swap.tool drawknife
  var tool drawknife
  pause 0.5
DrawScrape:
  save DrawScrape
  put carve my lumber with my drawknife
  goto fletch

Get.Knife:
  pause 1
  if "%need_strips" = "YES" then gosub Strips
  if "%need_long_pole" = "YES" then gosub LongPole
  if "%need_backer" = "YES" then gosub Backer
  gosub swap.tool carving knife
  var tool rasp
  pause 0.5
Carve:
  save Carve
  put carve my %item with my knife
  goto fletch

Get.Rasp:
  pause 1
  if "%need_strips" = "YES" then gosub Strips
  if "%need_long_pole" = "YES" then gosub LongPole
  if "%need_backer" = "YES" then gosub Backer
  gosub swap.tool rasp
  var tool rasp
  pause 0.5
Scrape:
  save Scrape
  put scrape my %item with my rasp
  goto fletch

Get.Shaper:
  pause 1
  if "%need_strips" = "YES" then gosub Strips
  if "%need_long_pole" = "YES" then gosub LongPole
  if "%need_backer" = "YES" then gosub Backer
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
  if "%need_backer" = "YES" then gosub Backer
  gosub swap.tool glue
  var tool glue
  pause 0.5
Glue:
  save Glue
  put apply my glue to my %item
  goto fletch

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

Bowstring:
  pause 0.5
  gosub swap.tool bow string
  put assemble my bow string with my %item
  var need_string NO
  pause 0.5
  return

Backer:
  pause 0.5
  gosub swap.tool backer
  put assemble my backer with my %item
  var need_backer NO
  pause 0.5
  return

Strips:
  pause 0.5
  gosub swap.tool strips
  put assemble my strips with my %item
  waitforre You place your strips
  var need_strips NO
  pause 0.5
  return

LongPole:
  gosub Place.Pole
  gosub Place.Pole
  gosub Place.Pole
  gosub Place.Pole
  var need_long_pole NO
  pause 0.5
  return

Place.Pole:
  pause 0.5
  gosub swap.tool long pole
  put assemble my pole with my %item
  waitforre You place your pole
  return

swap.tool:
  var tool $0
  if !contains("$lefthand", "%tool") then
  {
    if ("$lefthand" != "Empty") then { gosub stow.tool }
    pause 0.5
    matchre %last \.\.\.wait|Sorry
    matchre RETURN You get|You remove|You untie
    if "%has_craft_belt" = "YES" then {
      put untie my %tool from my %belt
      put untie my %tool
    }
    else { put untie my %tool }
    put get my %tool in my %container
    matchwait 500
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

NotEnough:
  echo **** Not enough material  ****
  goto done

done:
  gosub stow.tool
  put #parse WOODWORK DONE
