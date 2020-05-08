#debuglevel 5

#############################################
# Configurable Variables
#############################################

# where to store the cloth
var container lootsack

# what khri to use if your character is a thief
var khri1 cunning
var khri2 sagacity

# set play.music to ON or OFF
var play.music ON
var play.song $play.song
var play.style $play.style

# choose what cloth to keep, bucket, or drop
var keep dragonar cloth|faeweave cloth|steelsilk cloth|titanese cloth|imperial weave cloth|dergatine cloth|arzumodine cloth|zenganne cloth
var bucket khaddar cloth|bourde cloth|wool cloth|silk cloth|burlap cloth|linen cloth|cotton cloth|felt cloth|farandine cloth|jaspe cloth|ruazin wool cloth
var drop something cloth

#############################################

action var item gizmo when something to the gizmo
action var item slider when something to the slider
action var item dial when something to the dial
action var item prong when something to the prong
action var item gadget when something to the gadget

action var action pull when You think you can pull
action var action pinch when You think you can pinch
action var action push when You think you can push
action var action poke when You think you can poke
action var action prod when You think you can prod

action var action $1;var item $2 when You think you can (pull|pinch|push|poke|prod) the (gizmo|slider|dial|prong|gadget)

action goto done when going to shut down in the next few seconds

action var guild $1;put #var guild $1 when Guild:\s+(Barbarian|Bard|Cleric|Commoner|Empath|Moon Mage|Necromancer|Paladin|Ranger|Thief|Trader|Warrior Mage)$
action var circle $1;put #var circle $1 when Circle:\s+(\d+)$

var action Empty
var item Empty

var local_spinneret_cloth 0
var local_spinneret_poison 0
var local_spinneret_web 0

put info
waitforre ^Debt:$

if_1 goto %1

gosub echostats
goto start

init:
  put #var spinneret_cloth_count 0
  put #var spinneret_poison_count 0
  put #var spinneret_web_count 0
  var local_spinneret_cloth 0
  var local_spinneret_poison 0
  var local_spinneret_web 0
  gosub echostats
  put #var save
  goto drat

start:
  if ("$guild" = "Thief") then
  {
    gosub startkhri
  }
  put push button
  goto appraise

startkhri:
  gosub khri %khri1
  gosub khri %khri2
  return

khri:
  var khri $0
  khri.s:
    pause 0.5
    matchre RETURN You already|You're already using|Roundtime|You have not recovered
    put khri %khri
    matchwait 3
  goto khri.s

RETURN:
  return

echostats:
  var overalltotal 0
  math overalltotal add $spinneret_cloth_count
  math overalltotal add $spinneret_poison_count
  math overalltotal add $spinneret_web_count

  var total 0
  math total add %local_spinneret_cloth
  math total add %local_spinneret_poison
  math total add %local_spinneret_web

  echo
  echo This Run -- Cloth: %local_spinneret_cloth, Poison: %local_spinneret_poison, Web: %local_spinneret_web, Total:  %total
  echo   Overall -- Cloth: $spinneret_cloth_count, Poison: $spinneret_poison_count, Web: $spinneret_web_count, Total:  %overalltotal
  echo
  put #var save
  return

appraise:

  gosub clear

  if ("%play.music" = "ON") then put play %play.song %play.style

  if ("%action" != "Empty" && "%item" != "Empty") then goto doit

  matchre appraise Roundtime
  matchre wait1 wait
  matchre start PUSH the BUTTON
  put appraise spinneret
  matchwait 3
  goto appraise

wait1:
  pause
  goto appraise

doit:
  matchre done improved your odds as much as you possibly can
  matchre next Roundtime
  matchre wait2 wait
  put %action %item
  matchwait

wait2:
  pause
  goto doit

next:
  var action Empty
  var item Empty
  goto appraise

poisoned:
  math local_spinneret_poison add 1
  var counter $spinneret_poison_count
  math counter add 1
  put #var spinneret_poison_count %counter
  gosub echostats
  if ("$guild" = "Thief") then
  {
    waitforre ^Your vision blurs slightly as a hot wave sweeps across your body|feel certain that the nerve poison is gone
    goto start
  }
  else goto drat

webbed:
  math local_spinneret_web add 1
  var counter $spinneret_web_count
  math counter add 1
  put #var spinneret_web_count %counter
  gosub echostats
  if ("$guild" = "Thief") then
  {
    send khri cunning
  }
  waitforre ^You finally manage to free yourself from the webbing|you slide out of the webbing with ease
  goto start

done:
  var action Empty
  var item Empty

  matchre webbed You are webbed
  matchre poisoned You are poisoned
  matchre check You quickly take it from the contraption before the panel closes
  matchre start Absolutely NOTHING
  matchre wait3 best to wait
  put pull lever
  matchwait 4
  goto done

wait3:
  pause
  goto done

check:
  math local_spinneret_cloth add 1
  var counter $spinneret_cloth_count
  math counter add 1
  put #var spinneret_cloth_count %counter
  gosub echostats
  if contains("%bucket", "$lefthand") then
  {
    put put my $lefthandnoun in bucket
    waitfor You drop
  }
  if contains("%bucket", "$righthand") then 
  {
    put put my $righthandnoun in bucket
    waitfor You drop
  }

  if contains("%drop", "$lefthand") then
  {
    put #echo >Log #33FF08 You found $lefthand.
    put empty left
    waitfor You drop
  }
  if contains("%drop", "$righthand") then 
  {
    put #echo >Log #33FF08 You found $righthand.
    put empty right
    waitfor You drop
  }

  if contains("%keep", "$lefthand") then
  {
    put #echo >Log #33FF08 You found $lefthand!!
    put put my $lefthandnoun in my %container
    waitfor You put
  }
  if contains("%keep", "$righthand") then
  {
    put #echo >Log #33FF08 You found $righthand!!
    put put my $righthandnoun in my %container
    waitfor You put
  }

  if "$righthand" != "Empty" then waitfor continue

  goto start

drat:
  send #parse SPINNERET POISONED