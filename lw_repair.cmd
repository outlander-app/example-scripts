debuglevel 5

var container backpack
var belt outfitter's belt
var has_craft_belt $has_tailor_craft_belt

GET:
	matchre GET.STOW You get|You are already holding that
	matchre HOLD already in your inventory
	put get my %1
	matchwait 10
	goto END

GET.STOW:
	var inv.action STOW
	goto REPAIR.MAIN

HOLD:
	matchre HOLD.WEAR You loosen|You work|You pull|You take
	put hold my %1
	matchwait 10
	goto END

HOLD.WEAR:
	var inv.action WEAR
	goto REPAIR.MAIN

WEAR.ITEM:
	pause 1
	put wear my %1
	return

STOW.ITEM:
	pause 1
	put stow my %1
	return

STOW.TOOLS:
	pause 0.5
	gosub stow.tool
	pause 0.5
	return

REPAIR.MAIN:
	gosub REPAIR
	gosub stow.tool
	gosub %inv.action.ITEM
	goto END

REPAIR:
	goto Get.Needle

Matches:
	match %s ...wait
	match MoreThread The needles need to have thread put on
	match Get.Needle You rub and press
	match Get.Slick ready to be rubbed with a slickstone
	match Sew Stitch after stitch
	matchre RETURN not damaged enough to warrant repair|You realize that cannot be repaired|suffered too much damage
	matchwait

Get.Needle:
	pause 1
	gosub swap.tool needle
	goto Sew

Get.Slick:
	pause 1
	gosub swap.tool slickstone
	goto Rub

Sew:
	save Sew
	put push my %1 with my sew needle
	goto Matches

Rub:
	save Rub
	put rub my %1 with my slickstone
	goto Matches

swap.tool:
  var tool $0
  if !contains("$lefthand", "%tool") then
  {
	  if ("$lefthand" != "Empty") then { gosub stow.tool }
    pause 0.5
    matchre %last \.\.\.wait|Sorry
    matchre RETURN You get|You remove
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
	return

END:
put #parse REPAIR DONE