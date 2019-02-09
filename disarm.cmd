## Disarming script by Warneck
## Updates by Saracus

#debuglevel 5

## Character specific variables
var container1 $primary.container
var container2 $secondary.container
var containerToUse %container1
var componentcontainer $primary.container
var gempouch $gem.pouch

## Script actions
action var multi_trap ON when is not yet fully disarmed
action var multi_trap ON when more to torment you with
action var multi_lock ON when discover another lock protecting
action var guild $1;put #var guild $1 when Guild:\s+(Barbarian|Bard|Cleric|Commoner|Empath|Moon Mage|Necromancer|Paladin|Ranger|Thief|Trader|Warrior Mage)$
action var circle $1;put #var circle $1 when Circle:\s+(\d+)$

put exp survival 0
waitfor Overall state of mind
if ($Locksmithing.Ranks >= 15) then
{
  action (disarm) var mode careful when not likely to be a good thing
  action (disarm) var mode quick when An aged grandmother could|is a laughable matter|is a trivially constructed
  action (disarm) var mode normal when should not take long with your skills|is precisely at your skill level|will be a simple matter for you to
  action (disarm) var mode careful when with only minor troubles|got a good shot at|some chance of being able|with persistence you believe you could|would be a longshot|minimal chance|You really don't have any chance|Prayer would be a good start
  action (disarm) var mode toss when You could just jump off a cliff|same shot as a snowball|pitiful snowball encased in the Flames

  action (picklock) var mode blind when is a laughable matter|The lock is a trivially constructed piece of junk barely worth your time|An aged grandmother could
  action (picklock) var mode quick when will be a simple matter for you to
  action (picklock) var mode normal when should not take long with your skills|is precisely at your skill level|with only minor troubles
  action (picklock) var mode careful when got a good shot at|some chance of being able|with persistence you believe you could|would be a longshot|minimal chance|You really don't have any chance|Prayer would be a good start
  action (picklock) var mode toss when You could just jump off a cliff|same shot as a snowball|pitiful snowball encased in the Flames
  var mode
  action (disarm) on
  action (picklock) off
}
else
{
  var mode careful
}

## Scripts variables
var component_list tube|needle|seal|bladder|studs|blade|\brune\b|spring|hammer|disc|dart|reservoir|face|\bpin\b|vial|striker|cube|sphere|leg|crystal|circle|clay
var multi_trap ON
var multi_lock ON
var thief_hide NO
var harvest YES
var dismantle
var box_popping OFF
var check_for_boxes YES
var total.armor 0
var disarmit $righthandnoun
var use_lockpick_ring NO

check_ring:
  action (ring) var use_lockpick_ring YES when (lockpick ring)
  put inv;enc
  waitfor Encumbrance
  action (ring) off

top:

  checkArgs:
    if_1 then
    {
      gosub %1
      shift
      goto checkArgs
    }

  if $hidden = 1 then put shiver
  if ("%box_popping" = "ON") then goto guild_Check
  var LAST top
    matchre stowStuff right|left
    match guild_Check empty hands.
  put glance
  matchwait

stowStuff:
  var LAST stowStuff
    matchre guild_Check You|Stow
  put stow right;stow left
  matchwait

guild_Check:
    match barb Barbarian
    match bard Bard
    match cleric Cleric
    match moonmage Moon Mage
    match ranger Ranger
    match thief Thief
    match warmage Warrior Mage
    match guild_check2 Gender
  put info
  matchwait

barb:
  var dismantle bash
  goto guild_check2

bard:
  var dismantle shriek
  goto guild_check2

cleric:
  var dismantle pray
  goto guild_check2

moonmage:
  var dismantle focus
  goto guild_check2

ranger:
  var dismantle whistle
  goto guild_check2

thief:
  if (toupper("%thief_hide") = "NO") then
  {
    var dismantle thump
  }
  goto guild_check2

warmage:
  var dismantle fire
  goto guild_check2

popping:
  var box_popping ON
  var harvest NO
  var check_for_boxes NO
  return


guild_check2:
  if "%check_for_boxes" = "YES" then gosub BOX.CHECK
  if "%guild" = "Thief" && "%box_popping" != "NO" then
  {
    send khri stop
    send khri start secure
    waitforre Roundtime|already using|You have not recovered|You strain
  }
  gosub ARMOR.CHECK
  goto main


no_More_Stowing:
  echo **   No more room for stowing; exiting script   **
  put wear %armor
  goto done

main:
  if ("%box_popping" != "ON") then gosub container_Check1
  disarm_sub:
    if ("$lefthand" = "Empty") then
    {
      put swap
      pause 1
    }
    gosub disarm_ID
    if ("%mode" = "toss") then goto toss_box
    gosub disarm
    if "%harvest" = "YES" then gosub analyze
    if "%multi_trap" = "ON" then goto disarm_sub
  if %use_lockpick_ring = NO then gosub get_Pick
  lock_sub:
    gosub pick_ID
    if ("%mode" = "toss") then goto toss_box
    gosub pick
    if "%multi_lock" = "ON" then goto lock_sub
    gosub put_Away_Pick
  if "%box_popping" != "ON" then
  {
    gosub loot
    gosub dismantle
  }
  if "%harvest" = "YES" then gosub fix_Lock
  if "%box_popping" != "ON" then
  {
    gosub exp_Check
    goto main
  }
  else goto done

rt:
  pause
  goto %LAST

container_Check1:
  var containerToUse %container1
  pause 1
    matchre get_For_Disarm (coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|coffin|\bbox\b)
    match container_Check2 Encumbrance
  put rummage /b my %container1;enc
  matchwait

container_Check2:
  var containerToUse %container2
  pause 1
    matchre get_For_Disarm (coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|coffin|\bbox\b)
    match done Encumbrance
  put rummage /b my %container2;enc
  matchwait

get_For_Disarm:
  var LAST get_For_Disarm
  var disarmit $1
  get_Box:
    var LAST get_Box
      matchre rt ^\.\.\.wait|^Sorry, you may only type
      matchre RETURN You get|You are already
    put get my %disarmit in my %containerToUse
    matchwait

toss_Box:
  var LAST toss_Box
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    match You
  put drop my %disarmit
  matchwait

weapon:
  var LAST weapon
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    match stow_Weapon You
    put remove knuckles
  matchwait
  stow_Weapon:
  var LAST stow_Weapon
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    match RETURN You
  put stow knuckles
  matchwait

disarm_ID:
  action (disarm) on
  action (picklock) off

  var LAST disarm_ID
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    match weapon knuckles
    match disarm_ID fails to reveal to you
    matchre return You guess it is already disarmed|Surely any fool|Even your memory can not be that short|Roundtime|Somebody has already located
    #matchre return coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|box
  put disarm ID
  matchwait

disarm:
  var multi_trap OFF
disarmIt_Cont:
  var LAST disarmIt_Cont
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    matchre return You are certain the %disarmit is not trapped|Roundtime|You guess it is already disarmed|DISARM HELP for syntax help
    matchre setCareful This is not likely to be a good thing
    matchre disarmIt_Cont fumbling fails to disarm|unable to make any progress
  put disarm my %disarmit %mode
  matchwait

setCareful:
  var mode careful
  goto %LAST

analyze:
  var LAST analyze
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    match analyze You are unable to
    matchre harvest You already have made an extensive study|You are certain the %disarmit is not trapped|Roundtime|You guess it is already disarmed|DISARM HELP for syntax help|You've already analyzed
    matchre return fumbling fails to disarm|This is not likely to be a good thing
  put disarm ana
  matchwait

harvest:
  var LAST harvest
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    matchre return It appears that none of the trap components are accessible|The mangled remnants|The remnants
    matchre harvest Your laborious fumbling fails to harvest the trap component|You fumble
    match stow_Component Roundtime
  put disarm harvest
  matchwait

stow_Component:
  #if (matchre ("$righthand", "(%component_list)")) then gosub stow_It $0
  if ("$righthand" != "Empty") then
  {
    if (matchre("$roomobjs", "(disposal|waste) bin")) then
    {
      gosub bin
    }
    if (matchre("$roomobjs", "bucket")) then
    {
      gosub bucket
    }

    gosub empty_hand right
  }
  return

bin:
  matchre return You drop
  put put my $righthandnoun in bin
  matchwait 4
  goto bin

bucket:
  matchre return You drop
  put put my $righthandnoun in bucket
  matchwait 4
  goto bucket

empty_hand:
  var hand $0
  empty_hand.d:
    pause
    if ("$%handhand" = "Empty") then return
    matchre return You drop|already empty
    matchre empty_hand.d ...wait
    put empty %hand hand
    matchwait 2
    goto empty_hand.d

stow_It:
  var component $0
  stow_Comp:
    var LAST stow_Comp
      matchre rt ^\.\.\.wait|^Sorry, you may only type
      match return You
    put put %component in my %componentcontainer
    matchwait

get_Pick:
  var LAST get_Pick
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    matchre return You get|You are already
    match no_More_Picks What were you referring to
  put get my lockpick
  matchwait 30

no_More_Picks:
  echo
  echo ***  You have no more lockpicks  ***
  echo
  put stow $lefthand
  put stow $righthand
  goto done

put_Away_Pick:
  var LAST put_Away_Pick
  if ("$righthand" = "Empty") then return
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    matchre return You put|What were you
  put stow my lockpick
  matchwait

pick_ID:
  if "%box_popping" = "OFF" then
  {
    action (disarm) off
    action (picklock) on
  }

  if ( %use_lockpick_ring = NO && "$righthand" = "Empty") then gosub get_Pick
  var LAST pick_ID
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    matchre disarm_ERROR is not fully disarmed
    matchre pick_ID fails to teach you anything about the lock guarding it|just broke
    matchre return Somebody has already|not even locked|Roundtime
  put pick ID
  matchwait

pick:
  var LAST pick
  var multi_lock OFF
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    matchre pick You are unable to determine
    matchre pick_Cont Roundtime|has already helpfully been analyzed
  put pick anal
  matchwait
pick_Cont:
  if ( %use_lockpick_ring = NO && "$righthand" = "Empty") then gosub get_Pick
  var LAST pick_Cont
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    match pick_cont You are unable to make
    matchre return With a soft click|not even locked|Roundtime
  put pick %mode
  matchwait

loot:
  open_Box:
    var LAST open_Box
      matchre rt ^\.\.\.wait|^Sorry, you may only type
      match get_Gem_Pouch open
    put open my %disarmit
    matchwait
  get_Gem_Pouch:
    var LAST get_Gem_Pouch
      matchre rt ^\.\.\.wait|^Sorry, you may only type
      match fill_Gem_Pouch You get
    put get my %gempouch
    matchwait
  fill_Gem_Pouch:
    var LAST fill_Gem_Pouch
      matchre rt ^\.\.\.wait|^Sorry, you may only type
      matchre stow_Pouch You take|any gems|anything else|You fill|quickly fill|too full to fit
      matchre tie_Pouch too valuable to leave untied
    put fill my %gempouch with my %disarmit
    matchwait
  stow_Pouch:
    var LAST stow_Pouch
      matchre rt ^\.\.\.wait|^Sorry, you may only type
      matchre get_Coin You|Stow
    put stow my %gempouch
    matchwait
  get_Coin:
    var LAST get_Coin
      matchre rt ^\.\.\.wait|^Sorry, you may only type
      matchre get_Coin You pick up
      match get_nugget What were you
    put get coin from my %disarmit
    matchwait
  get_nugget:
    var LAST get_nugget
      matchre rt ^\.\.\.wait|^Sorry, you may only type
      matchre stow_nugget You pick up|You get
      match return What were you
    put get nugget from my %disarmit
    matchwait
  stow_nugget:
    var LAST stow_nugget
      matchre rt ^\.\.\.wait|^Sorry, you may only type
      matchre get_nugget You put your nugget
      matchre return What were you|Stow what?
    put stow my nugget
    matchwait
  tie_Pouch:
    put tie my %gempouch
    pause
    goto fill_Gem_Pouch

dismantle:
  var LAST dismantle
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    match return Roundtime
    match dismantle next 15 seconds.
  put dismantle my %disarmit %dismantle
  matchwait

fix_Lock:
  if ("%guild" != "Thief" || "%use_lockpick_ring" = "YES") then return
  gosub get_Pick
  fixing:
  var LAST fixing
    matchre rt ^\.\.\.wait|^Sorry, you may only type
    matchre go_On Roundtime|look like it|You can't figure out how
  put fix my lock
  matchwait
  go_On:
  gosub put_Away_Pick
  return

exp_Check:
  if $Locksmithing.LearningRate >= 30 then goto done
  return

return:
  return

waiting:
  pause
  goto %LAST

disarm_ERROR:
  echo
  echo Error while opening box
  echo Something bad happened
  echo
  put #beep
  put stow right
  pause 1
  put stow left
  pause 1
  goto done

BOX.CHECK:
    var containerToUse %container1
    pause 1
      matchre RETURN (coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|coffin|\bbox\b)
      match container_Check4 Encumbrance
    put rummage /b my %container1;enc
    matchwait

  container_Check4:
    var containerToUse %container2
    pause 1
      matchre RETURN (coffer|trunk|chest|strongbox|skippet|caddy|crate|casket|coffin|\bbox\b)
      match done Encumbrance
    put rummage /b my %container2;enc
    matchwait

############################################################################################
# ARMOR REMOVAL SECTION
############################################################################################
ARMOR.CHECK:
     var total.armor 0
ARMOR.CHECK.1:
     pause .1
     matchre REMOVE.AND.STOW.1 (hand claw|knuckles|cuirass|gloves|mitts|gauntlets|handguards|thorakes|jerkin|collar|balaclava|longcoat|sleeves|sallet|aventail|greaves|vambraces|shield|buckler|\btarge\b|coif|cowl|gauntlet|half plate|lorica|breastplate|field plate|tasset|ring mail|chain mail|\bmask\b|\bhelm\b|shirt|workcoat|coat|hood|pants|handwraps|ring robe)
     matchre ARMOR.COMPLETE You have nothing of that sort|You are wearing nothing of that sort|You aren't wearing anything like that|INVENTORY HELP
     send inv combat
     matchwait 5
     goto ARMOR.WARN
REMOVE.AND.STOW.1:
     var armor $0
REMOVE.ARMOR.1:
     pause 0.5
     var LAST REMOVE.ARMOR.1
     matchre REMOVE.ARMOR.1 ^\.\.\.wait\s+\d+\s+sec(?:onds|s)?\.?|^Sorry\,
     matchre STOW.ARMOR.1 ^You remove|^You loosen the straps securing|^You take|^You slide
     matchre STOW.ARMOR.1 ^You sling|^You work your way out of|^You pull|^You slip
     send remove %armor
     matchwait 5
STOW.ARMOR.1:
     pause 0.5
     var LAST STOW.ARMOR.1
     matchre STOW.ARMOR.1 ^\.\.\.wait|^Sorry, you may only type
     matchre ARMOR.DONE ^You put your|^You slip|^What were you
     matchre STOW.ARMOR.2 any more room in|closed|no matter how you arrange
     send put %armor in my %container1
     matchwait 5
STOW.ARMOR.2:
     pause 0.5
     var LAST STOW.ARMOR.2
     matchre STOW.ARMOR.2 ^\.\.\.wait|^Sorry, you may only type
     matchre ARMOR.DONE ^You put your|^You slip|^What were you
     matchre NO.MORE.STOWING any more room in|closed|no matter how you arrange
     send put %armor in my %container2
     matchwait 5
ARMOR.DONE:
     math total.armor add 1
     pause 0.5
     var armor%total.armor %armor
     goto ARMOR.CHECK.1
NO.MORE.STOWING:
     echo ***  YOU HAVE NO MORE FREE BAG SPACE FOR ARMOR! MAKE SOME ROOM!
     echo ***  GONNA JUST GO FOR IT ANYWAY, YOU WILL BE HINDERED!
     put wear %armor
     wait
     goto ARMOR.COMPLETE
ARMOR.COMPLETE:
     echo Armor Count: %total.armor
     if %total.armor < 1 then return
     echo Armor1: %armor1
     if %total.armor < 2 then return
     echo Armor2: %armor2
     if %total.armor < 3 then return
     echo Armor3: %armor3
     if %total.armor < 4 then return
     echo Armor4: %armor4
     if %total.armor < 5 then return
     echo Armor5: %armor5
     if %total.armor < 6 then return
     echo Armor6: %armor6
     if %total.armor < 7 then return
     echo Armor7: %armor7
     if %total.armor < 8 then return
     echo Armor8: %armor8
     if %total.armor < 9 then return
     echo Armor9: %armor9
     if %total.armor < 10 then return
     echo Armor10: %armor10
     pause
     return
############################################################################################
WEAR.ARMOR:
     echo **** PUTTING ARMOR BACK ON! ****
     send open my %container1
     send open my %container2
     pause 0.5
     if %total.armor = 0 then return
     if "%armor1" != "null" && %total.armor >= 1 then
          {
               send get my %armor1
               pause 0.5
               send wear my %armor1
               pause 0.5
          }
     if "%armor2" != "null" && %total.armor >= 2 then
          {
               send get my %armor2
               pause 0.5
               send wear my %armor2
               pause 0.5
          }
     if "%armor3" != "null" && %total.armor >= 3 then
          {
               send get my %armor3
               pause 0.5
               send wear my %armor3
               pause 0.5
          }
     if "%armor4" != "null" && %total.armor >= 4 then
          {
               send get my %armor4
               pause 0.5
               send wear my %armor4
               pause 0.5
          }
     if "%armor5" != "null" && %total.armor >= 5 then
          {
               send get my %armor5
               pause 0.5
               send wear my %armor5
               pause 0.5
          }
     if "%armor6" != "null" && %total.armor >= 6 then
          {
               send get my %armor6
               pause 0.5
               send wear my %armor6
               pause 0.5
          }
     if "%armor7" != "null" && %total.armor >= 7 then
          {
               send get my %armor7
               pause 0.5
               send wear my %armor7
               pause 0.5
          }
     if "%armor8" != "null" && %total.armor >= 8 then
          {
               send get my %armor8
               pause 0.5
               send wear my %armor8
               pause 0.5
          }
     if "%armor9" != "null" && %total.armor >= 9 then
          {
               send get my %armor9
               pause 0.5
               send wear my %armor9
               pause 0.5
          }
     if "%armor10" != "null" && %total.armor >= 10 then
          {
               send get my %armor10
               pause 0.5
               send wear my %armor10
               pause 0.5
          }
     return

STOWING:
     var location STOWING
     if "$righthandnoun" = "rope" then send coil my rope
     if "$righthand" = "bundle" || "$lefthand" = "bundle" then put wear bund;drop bun
     if matchre("$righthandnoun","(crossbow|bow|short bow)") then gosub unload
     if matchre("$righthand","(partisan|shield|buckler|crossbow|lumpy bundle|halberd|staff|longbow|khuj)") then gosub wear my $1
     if matchre("$lefthand","(partisan|shield|buckler|crossbow|lumpy bundle|halberd|staff|longbow|khuj)") then gosub wear my $1
     if matchre("$lefthand","(longbow|khuj)") then gosub stow my $1 in my %SHEATH
     if "$righthand" != "Empty" then gosub STOW right
     if "$lefthand" != "Empty" then gosub STOW left
     return

done:
  pause 1
  if "%box_popping" != "ON" then
  {
    gosub WEAR.ARMOR
  }
  pause 1
  send #parse DISARM DONE
exit
