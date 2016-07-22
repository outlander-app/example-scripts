debug 5

var item %1
var container $lw.container
var belt outfitter's belt
var has_craft_belt $has_tailor_craft_belt
var tool

if_2 then goto %2

GetBook:
  put get my tailor book;study my book
  waitfor Roundtime
  pause 0.5
  pause 0.5
  put stow my book
  waitfor You put
  gosub swap.tool scissor

FirstCut:
  put cut my %item with my scissor
  goto Matches

Matches:
  match %s ...wait
  matchre done not damaged enough to warrant repair
  matchre Get.Yard benefit from some remeasuring
  matchre Get.Scissor cut away more of the fabric with scissors
  matchre Get.Pins use some pins to keep it straight|use some pins to align them
  match Get.Slick A deep crease develops
  match Get.Slick wrinkles from all the handling and could use 
  matchre LargePad ready to be reinforced with some large cloth padding
  matchre Get.Needle Roundtime|not seem suitable for that task
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
  put rub %item with my slickstone
  goto Matches

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
  if "$lefthand" = "Empty" then return

  put stop play
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

done:
  gosub stow.tool
  put #parse TAILORING DONE