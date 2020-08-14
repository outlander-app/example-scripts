#debug 5

var material stack
var container $bw.container
var mark $can.stamp
var belt engineer's belt 
var has_craft_belt $has_engine_craft_belt
var saw $engineer.saw

START:

action var yards $1 when \((\d+) pieces\)$
action var yards 1 when \(1 piece\)$
action var have $1 when You count out (\d+) pieces of material there\.$

if_2 goto %2

Glance:
  put inv held
  match Get.Saw %1
  match Top stack
  match NotEnough Both of your hands are empty.
  matchwait

Top:
  put get carv book
  pause 0.5
  put read my book;count my %material
  waitfor A list of
  pause 0.5
  if %yards = %have then goto GetBook
  if %yards > %have then goto NotEnough
  put stow book
  put mark my %material at %yards pieces
  match CutStack You count out
  match NotEnough There is not enough
  matchwait

CutStack:
  pause 0.5
  gosub swap.tool %saw
  put cut my %material with my %saw
  waitfor You carefully cut
  gosub stow.tool
  put stow %material
  waitfor You put
  put get %material
  waitfor You pick up

GetBook:
  put get my carv book;study my book
  waitfor Roundtime
  pause 1
  put stow my book
  waitfor You put
  gosub swap.tool %saw

FirstCut:
  put carve my %material with my %saw
  goto Matches

Matches:
  match %s ...wait
  matchre Get.Rasp uneven|must be holding the rasp to do that
  matchre Get.Polish discolored areas|must be holding the polish to do that
  matchre Get.Rifflers jagged shards|must be holding the rifflers to do that
  matchre Get.Saw You must be holding the saw to do that
  match Get.Saw Roundtime
  matchre NotEnough It would be better to find a creature to carve|I could not find what you were referring to
  matchre Mark2 carefully hammer the stamp|The stamp is too badly damaged to be used for that.
  match END You cannot figure out how to do that
  matchwait 3
  put %lastcommand
  goto Matches


Get.Saw:
  pause 1
  gosub swap.tool %saw

Carve:
  save Carve
  put carve my %1 with my %saw
  goto Matches

Get.Rasp:
  pause 1
  gosub swap.tool rasp
  pause 0.5
Scrape:
  save Scrape
  put scrape my %1 with my rasp
  goto Matches

Get.Polish:
  pause 1
  gosub swap.tool polish
Polish:
  save Polish
  put apply my polish to my %1
  goto Matches

Get.Rifflers:
  pause 1
  gosub swap.tool rifflers
  pause 0.5
Rub:
  save Rub
  put rub my %1 with my rifflers
  goto Matches

Mark:
  if "%mark" != "ON" then return
  gosub swap.tool stamp
  put mark my %1 with my stamp
  goto Matches

Mark2:
  pause
  gosub stow.tool
  return

swap.tool:
  var tool $0
  if !contains("$lefthand", "%tool") then
  {
	  if ("$lefthand" != "Empty") then { gosub stow.tool }
    pause 0.5
    matchre %last \.\.\.wait|Sorry
    matchre RETURN You get|You remove|You untie

    if "%has_craft_belt" = "YES" then { put untie my %tool from my %belt }
    else { put get my %tool }

    if "%has_craft_belt" = "YES" then { put untie my %tool }
    put get my %tool in my %container
    matchwait 5
    goto done
  }
  pause 0.5
  return

stow.tool:
  if "$lefthand" = "Empty" then return

  put stop play
  pause 0.5
  matchre RETURN You attach|You put|Tie what
  matchre stow.tool.2 doesn't seem to fit
  if "%has_craft_belt" = "YES" then { put tie my $lefthandnoun to my %belt }
  else { put put my $lefthandnoun in my %container }
  matchwait

stow.tool.2:
  put put my $lefthandnoun in my %container
  return

RETURN:
  pause 0.5
  return


NotEnough:
  echo ****** Not Enough Material ******
  if "$lefthand" != "Empty" then gosub stow.tool
  if "$righthand" != "Empty" then put put my $righthandnoun in my %container
  goto Done

END:
  gosub stow.tool
  gosub Mark
  goto Done

Done:
  pause 1
  send #parse BW DONE