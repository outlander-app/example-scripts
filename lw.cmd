# debug 5

var container $lw.container
var belt outfitter's belt
var has_craft_belt $has_tailor_craft_belt
var mark $can.stamp

ECHO *******************************
ECHO **
ECHO ** This script assumes that you will have cloth or tanned leather in your right hand
ECHO ** and the tailoring book turned to the correct page before starting
ECHO **
ECHO ** When starting the script, type .lw <item>
ECHO **
ECHO ** Change var container to where you keep tools.
ECHO **
ECHO *******************************

action var yards $1 when material \((\d+) yards\)$
action var yards $1 when cloth \((\d+) yards\)$
action var yards 1 when \(1 yard\)$
action var have $1 when You count out (\d+) yards of material there\.$

var tool
var item %1

if_2 then goto %2

Glance:
    matchre Get.Needle %item
    matchre HaveCloth cloth
    matchre HaveSilk silk
    matchre HaveLeather leather
    matchre NotEnough Both of your hands are empty
    put inv held
    matchwait 5
    goto done

HaveCloth:
    var material cloth
    goto top
HaveSilk:
    var material silk
    goto top
HaveLeather:
    var material leather
    goto top

top:
    put get tailor book
    pause 0.5
    put read my book;count my %material
    waitfor A list of
    pause 0.5
    if %yards = %have then goto GetBook
    if %yards > %have then goto NotEnough
    put stow book
    waitforre ^You put your book
    put mark my %material at %yards yards
    match CutLeather You count out
    match NotEnough There is not enough
    matchwait

CutLeather:
  gosub swap.tool scissor
    put cut my %material with my scissor
    waitfor You carefully cut
    gosub stow.tool scissor
    put stow right
    waitfor You put
    put get my %material
    waitfor You pick up

GetBook:
    put get my tailor book;study my book
    waitfor Roundtime
    pause 0.5
    pause 0.5
    put stow my book
    waitfor You put
    gosub swap.tool scissor

FirstCut:
    put cut my %material with my scissor
    goto Matches

Matches:
    matchre %s ...wait|Sorry
    match Get.Awl needs holes punched
    match Get.Yard dimensions appear to have shifted and could benefit from some remeasuring.
    match Get.Pins could use some pins to
    match Get.Scissor With the measuring complete, now it is time to cut away more
    matchre Get.Needle Roundtime|must be holding the sewing needles to do that|That tool does not seem suitable|appear suitable for working on
    matchre Get.Stamp You cannot figure out how to do that|You realize that cannot be repaired|not damaged enough to warrant repair
    matchre LargePad You need another finished large cloth padding|reinforced with some large cloth padding
    match Smallpad You need another finished small cloth padding
    match Handle You need another finished leather shield handle
    match LongCord You need another finished long leather cord
    match MoreThread The needles need to have thread
    match Get.Slick A deep crease develops
    match Get.Slick wrinkles from all the handling and could use
    match Get.Needle New seams must now be sewn
    matchwait

MoreThread:
    put put my needle in my %container;get thread in my %container
    match Thread You get
    match NoThread What were you referring to?
    matchwait 3
    goto NoThread

Thread:
    put put my thread on needle in my %container
    waitfor You carefully thread
    put get needle in my %container
    goto Sew

NoThread:
    echo
    echo ########### NO THREAD ###########
    echo
    goto done

Sew:
    save Sew
  pause 0.5
    put play $play.song $play.style
    put push my %item with my sew needle
    goto Matches

Poke:
    save Poke
  pause 0.5
    put poke my %item with my %tool
    goto Matches

Measure:
    save Measure
  pause 0.5
    put measure my %item with my yardstick
    goto Matches

Cut:
    save Cut
  pause 0.5
    put cut my %item with my scissor
    goto Matches

Rub:
    save Rub
  pause 0.5
    put rub my %item with my slickstone
    goto Matches

Mark:
    put mark my %item with my stamp
    waitforre Roundtime|too badly damaged to be used
    pause 1
    #put put my stamp in my %container
    goto done

NotEnough:
    echo ****** Not Enough Material ******
    pause
    if "$righthand" != "Empty" then put put $righthand in my %container
    if "$lefthand" != "Empty" then gosub stow.tool
    pause
    goto done

done:
  gosub stow.tool
  send #parse LW DONE
  exit

Get.Needle:
  var last Get.Needle
  if %tool = yardstick then goto Get.Scissor
  if "$lefthand" = "sewing needles" then goto Sew
  pause 1
  gosub swap.tool sewing needles
  goto Sew

Get.Awl:
  var last Get.Awl
  gosub swap.tool awl
  goto Poke

Get.Pins:
  var last Get.Pins
  pause 1
  gosub swap.tool pins
  goto Poke

Get.Scissor:
    var last Get.Scissor
    pause 1
    gosub swap.tool scissor
    goto Cut

Get.Slick:
    var last Get.slick
    pause 1
    gosub swap.tool slickstone
    goto Rub

Get.Yard:
    var last Get.Yard
    pause 1
    gosub swap.tool yardstick
    goto Measure

Get.Stamp:
  var last Get.Stamp
  pause 1
  if "%mark" != "ON" then { goto done }
  gosub swap.tool stamp

  if "$lefthand" = "Empty" then goto done
  goto Mark

swap.tool:
  var tool $0
  if !contains("$lefthand", "%tool") then
  {
    if ("$lefthand" != "Empty") then { gosub stow.tool }
    pause 0.5
    matchre %last \.\.\.wait|Sorry
    matchre RETURN You get|You remove|You untie|already holding
    if "%has_craft_belt" = "YES" then { put untie my %tool from my %belt }
    else { put get my %tool }
    put untie my %tool
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

LargePad:
  var assemble Large Pad
  goto Assemble
SmallPad:
  var assemble Small Pad
  goto Assemble
Handle:
  var assemble shield handle
  goto Assemble
LongCord:
  var assemble long cord
  goto Assemble


Assemble:
  var tool Assemble
  gosub stow.tool
  put get %assemble in my %container
  waitfor You get
  put assemble my %assemble with my %item
  goto Get.Needle
