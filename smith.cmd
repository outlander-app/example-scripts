debuglevel 5

var container $primary.container
var hammer $forging.hammer
var item %1
var book %2
var mark $can.stamp

var belt forger's belt
var has_craft_belt $has_forging_craft_belt

var get_ingot NO
var need_hilt NO
var need_haft NO
var need_pole NO
var need_short_cord NO

# actions
action var need_hilt YES when You need another finished wooden hilt
action var need_haft YES when You need another finished wooden haft
action var need_pole YES when You need another finished long wooden pole
action var need_short_cord YES when You need another finished short leather cord
action var need_smallpadding YES when You need another finished small cloth padding
action var need_largepadding YES when You need another finished large cloth padding

IF_3 goto %3

put put my ingot on anvil
goto GetBook


matches:
  matchre shovel need some more fuel|The fire needs more fuel before you can do that|You must be holding the engraved shovel to do that
  matchre bellows the fire dims and produces less heat|You must be holding the leather bellows to do that
  matchre tongs could use some straightening|benefit from some soft reworking|metal now looks ready to be turned into wire
  matchre push ready for a quench hardening
  matchre pliers now ready for stitching together using pliers|links can be woven into|links appear ready to be woven into
  matchre oil metal looks to be in need of some oil to preserve and protect it
  matchre pounddone ready for grinding and polishing
  matchre gotoLast You must be holding some metal tongs in your other hand to do that
  matchre wait wait...
  matchre pound Roundtime
  matchwait

gotoLast:
  goto %last

wait:
  goto %last

get.ingot:
  pause 1
  put put my %tool in my %container
  put get ingot
  waitfor You pick up
  put put my ingot in my %container
  pause
  put get my %tool in my %container
  var get_ingot NO
  return

GetBook:
  pause 0.5
  put get my %book book;read my book
  pause 0.5
  send study my book
  waitfor Roundtime
  pause 0.5
  pause 0.5
  put stow my book
  waitfor You put
  gosub get.tool %hammer
  gosub get.tool tongs

firstpound:
  put pound ingot on anvil with my hammer
  goto matches

get.tool:
  var tool $0
  pause 0.5
  matchre %last \.\.\.wait|Sorry
  matchre RETURN You get|You remove
  put untie %tool from my %belt
  put get my %tool in my %container
  matchwait 5
  goto done

swap.tool:
  var tool $0
  if !contains("$lefthand", "%tool") then
  {
    if ("$lefthand" != "Empty") then { gosub stow.tool }
    gosub get.tool %tool
  }
  pause 0.5
  return

stow.tool:
  if "$lefthand" = "Empty" then return

  pause 0.5
  matchre RETURN You attach|You put|Tie what
  matchre stow.tool.2 doesn't seem to fit
  if "%has_craft_belt" = "YES" then { put tie my $lefthand to my %belt }
  else { put put my $lefthand in my %container }
  matchwait

stow.tool.2:
  put put my $lefthand in my %container
  return

stow.tool.right:
  if "$righthand" = "Empty" then return

  pause 0.5
  matchre RETURN You attach|You put|Tie what
  matchre stow.tool.right.2 doesn't seem to fit
  if "%has_craft_belt" = "YES" then { put tie my $righthand to my %belt }
  else { put put my $righthand in my %container }
  matchwait

stow.tool.right.2:
  put put my $righthand in my %container
  return

pound:
  var last pound
  pause 0.5
  gosub swap.tool tongs
  put pound %item on anvil with my hammer
  goto matches

tongs:
  var last tongs
  pause 0.5
  gosub swap.tool tongs
  put turn %item on anvil with my tongs
  goto matches

armordone:
  gosub stow.tools
  pause 1
  put get %item on anvil

  if "%need_largepadding" = "YES" then gosub large.padding
  if "%need_smallpadding" = "YES" then gosub small.padding
  return

pliers:
  var last pliers

  if !contains("$righthand", "%item") then
  {
    gosub armordone
  }

  pause 0.5
  gosub swap.tool pliers
  put pull my %item with my pliers
  goto matches

push:
  var last push
  pause 0.5
  put push tub
  goto matches

bellows:
  var last bellows
  pause 0.5
  gosub swap.tool bellows
  pause 0.5
  put push my bellows
  goto matches

shovel:
  var last shovel
  pause 0.5
  gosub swap.tool shovel
  pause 0.5
  put push fuel with my shovel
  goto matches


grindmatches:
  matchre turn.grind still rather slow
  matchre grind making it spin even faster|keeping it spinning fast
  matchre nogrind Turn what
  matchwait 1
  goto turn.grind

turn.grind:
  pause 0.5
  put turn grindstone
  goto grindmatches

nogrind:
  echo
  echo  *** Find a grindstone!  ***
  echo
  pause 2
  goto done

grind:
  put push grindstone with %item
  pause 4
  goto oil

oil:
  pause 1
  gosub swap.tool oil
  put pour my oil on my %item
  pause 4
  put stow my oil
  pause 1
  goto Get.Stamp

hilt:
  pause 0.5
  gosub Assemble hilt
  goto find.grind

haft:
  pause 0.5
  gosub Assemble haft
  goto find.grind

pole:
  pause 0.5
  gosub Assemble pole
  goto find.grind

cord:
  pause 0.5
  gosub Assemble cord
  goto find.grind

small.padding:
  pause 0.5
  gosub Assemble small padding
  return

large.padding:
  pause 0.5
  gosub Assemble large padding
  return

Assemble:
  pause 0.5
  put get my $0
  put assemble my %item with my $0
  pause 0.5
  return

Get.Stamp:
  var tool Stamp
  pause 1
  gosub stow.tool
  if "%mark" != "ON" then goto done
  gosub get.tool stamp
  goto Mark

Mark:
  put mark my %1 with my stamp
  waitforre Roundtime|too badly damaged to be used
  pause 1
  gosub stow.tool stamp
  goto done

stow.tools:
  gosub stow.tool
  gosub stow.tool.right
  return

pounddone:
  pause 1
  gosub stow.tools
  pause 1
  put get %item on anvil

  if "%need_hilt" = "YES" then gosub Assemble hilt
  if "%need_haft" = "YES" then gosub Assemble haft
  if "%need_pole" = "YES" then gosub Assemble pole
  if "%need_short_cord" = "YES" then gosub Assemble cord

  goto find.grind

find.grind:
  #if "$zoneid" = "116" then gosub to.grind.hib
  goto turn.grind

to.grind.hib:
  gosub AUTOMOVE 418
  return


#####################################
#         MOVEMENT ENGINE
#####################################
FINDROOM:
    send .findroom
    waitforre ^FOUND ROOM
    pause 0.5
    return

AUTOMOVE:
     var Destination $0
     if !$standing then gosub STAND
     if $roomid = %Destination then return
AUTOMOVE_GO:
     matchre AUTOMOVE_FAILED ^AUTOMAPPER MOVEMENT FAILED|^MOVE FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED
     matchre AUTOMOVE_RETURN ^SHOP CLOSED\!
     send #goto %Destination
     matchwait
AUTOMOVE_STAND:
     send STAND
     pause 0.5
     if $standing then return
     goto AUTOMOVE_STAND
AUTOMOVE_FAILED:
     pause 0.5
     goto AUTOMOVE_GO
AUTOMOVE_RETURN:
     return


#####################################
#              MISC
#####################################
PAUSE:
     if $roundtime > 0 then pause $roundtime
     pause 0.1
     pause 0.5
     return
STAND:
pause 0.2
     matchre STAND ^(?:\(|\[|\s*)Roundtime\s*\:
     matchre STAND ^\.\.\.wait\s+\d+\s+sec(?:onds?|s)?\.?|^Sorry\,
     matchre STAND ^You are so unbalanced you cannot manage to stand\.
     matchre STAND ^The weight of all your possessions prevents you from standing\.
     matchre STAND ^You are overburdened and cannot manage to stand\.
     matchre STAND ^You are still stunned
     matchre STAND ^You try
     matchre RETURN ^You are already standing\.
     matchre RETURN ^You stand back up\.
     matchre RETURN ^You stand up\.
     matchre RETURN ^There doesn't seem to be anything to stand on here
     matchre RETURN ^You swim back up
     matchre RETURN ^You are already standing\.
     matchre RETURN ^You're unconscious
     send STAND
     matchwait
RETURN:
     pause 0.5
     return
HIDE:
     pause 0.1
     matchre HIDE ^\.\.\.wait\s+\d+\s+sec(?:onds|s)?\.?|^Sorry\,|fail|You are too close|^You are a bit|^You are too busy
     matchre HIDE notices your attempt|reveals you|ruining your hiding place|discovers you
     matchre RETURN ^You melt|^You blend|^Eh\?|^You slip|^Roundtime|You look around
     send hide
     matchwait
SNEAK:
     var direction $0
     if (("%guild" = "Thief") && (%circle < 50)) then goto SNEAK.HIDE
SNEAKING:
     matchre SNEAK.PAUSE ^\.\.\.wait\s+\d+\s+sec(?:onds|s)?\.?|^Sorry\,
     matchre RETURN Roundtime|You sneak|You duck|You quickly slip
     send sneak %direction
     matchwait
SNEAK.PAUSE:
     pause
     goto SNEAKING
SNEAK.HIDE:
     pause 0.2
     matchre SNEAK.HIDE notices your attempt|reveals you|ruining your hiding place|discovers you
     matchre SNEAKING ^You melt|^You blend|^Eh\?|^You slip|^Roundtime|You look around
     send hide
     matchwait
UNHIDE:
     pause 0.1
     matchre UNHIDE ^\.\.\.wait\s+\d+\s+sec(?:onds|s)?\.?|^Sorry\,
     matchre RETURN ^But you are not hidden\!
     matchre RETURN ^You come out of hiding\.
     send UNHIDE
     matchwait 2
     return

done:
  pause 1
  echo
  echo  Done with your %item!
  echo
  pause 1
  put #parse SMITH DONE
