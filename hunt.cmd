#
#  hunt.cmd - version 0.5
#  Requires Outlander 0.10.11 or higher
#

# debuglevel 5

#
#  User defined variables
#
var health_threshold 50
var fatigue_threshold 70
var should_loot_coins YES
var should_loot_gems YES
var should_loot_boxes NO
var loot_option loot
var arrange 5
var berserk_on_fatigue YES
var fatigue_berserk avalanche
var bard_scream havoc
var sling_ammo shard
var crossbow_ammo bolt
var bow_ammo arrow


#
#  Script Variables
#
var kill_count 0
var use_offhand NO
var check_exp NO
var exp_type
var exp_threshold 15
var max_exp 34
var weapon
var attack_style attack
var is_thrown NO
var is_ranged NO
var sheath_style sheath
var should_stealth NO
var FULL_AIM NO
var ranged_hidden_attack poach
var ranged_action
var use_screams NO
var hide_if_locked NO
var arrange_action arrange
var tm_mode NO
var tm_spell
var tm_mana

#
#  Critter variables
#
var skinnablecritters rat|hog|goblin|boar|eel|bobcat|cougar|reaver|wolf|snowbeast|gargoyle|togball|ape|tusky|wyvern

#
#  Actions
#
action put #beep;put #flash when ^(.+) (say|says|asks|exlaims|whispers)
action (info) var guild $1;put #var guild $1 when Guild:\s+(Barbarian|Bard|Cleric|Commoner|Empath|Moon Mage|Necromancer|Paladin|Ranger|Thief|Trader|Warrior Mage)$
action (info) var circle $1;put #var circle $1 when Circle:\s+(\d+)$
action (skill) var skill Polearms when .*polearm skills\.$|polearm skill\.$
action (skill) var skill Large_Blunt when .*heavy blunt skills\.$|heavy blunt skill\.$|large blunt skill\.$
action (skill) var skill Small_Blunt when .*small blunt skill\.$
action (skill) var skill Large_Edged when .*large edged skill\.$
action (skill) var skill Small_Edged when .*small edged skills\.$|small edged skill\.$
action (skill) var skill Twohanded_Edged when .*two-handed edged skill\.$
action (skill) var skill Twohanded_Blunt when .*two-handed blunt skill\.$
action (skill) var skill Staves when .*stave skill\.$
action (skill) var skill Bow;var is_ranged YES;var ranged_ammo %bow_ammo when .*bow skill\.$
action (skill) var skill Crossbow;var is_ranged YES;var ranged_ammo %crossbow_ammo when .*crossbow skill\.$
action (skill) var skill Slings;var is_ranged YES;var ranged_ammo %sling_ammo when .*sling skill\.$

if_1 then goto start
else {
  echo
  echo  *** You need to provide a weapon to use ***
  echo  *** .hunt spear
  echo  *** .hunt offhand nightstick
  echo
  exit
}

start:
  gosub checkinfo
  start.loop:
    if_2 then {
      gosub %1
      shift
      goto start.loop
    }
  var weapon %1
  gosub wield
  goto begin

throw:
  var attack_style throw
  var is_thrown YES
  return

lob:
  var attack_style lob
  var is_thrown YES
  return

hurl:
  var attack_style hurl
  var is_thrown YES
  return

offhand:
  echo
  echo  *** Offhand ***
  echo
  var use_offhand YES
  return

exp:
  echo
  echo  *** Checking EXP  ***
  echo
  var check_exp YES
  var exp_threshold 15

  if matchre("%2", "^\d+$") then {
    var exp_threshold %2
    shift
  }

  if %exp_threshold > %max_exp then var exp_threshold %max_exp

  return

ambush:
  var should_stealth YES
  return

backstab:
  var should_stealth YES
  var attack_style backstab
  return

poach:
  var should_stealth YES
  var hide_if_locked YES
  return

snipe:
  var should_stealth YES
  var ranged_hidden_attack snipe
  var hide_if_locked YES
  return

scream:
  var use_screams YES
  return

arrange:
  if matchre("%2", "^\d+$") then {
    var arrange %2
    shift
  }

  if %arrange > 5 then var arrange 5

  if "%2" == "all" then {
    var arrange_action arrange all
    shift
  }

  return

tm:
  var tm_mode YES
  shift
  var tm_spell %1
  shift
  var tm_mana %1
  return

wield:

  if %weapon = log || %weapon = rock then goto appraise_weapon

  matchre appraise_weapon You draw|You slip|already holding|You deftly
  matchre remove_weapon remove it first
  matchre no_weapon Wield what?
  matchre get_weapon as it is lying at your feet
  send wield %weapon
  matchwait

get_weapon:
  send get %weapon
  goto wield

no_weapon:
  echo
  echo  *** Could not find %weapon ***
  echo
  goto end

appraise_weapon:

  if %weapon = log {
    var skill Heavy_Thrown
    goto display_weapon
  }

  if %weapon = rock {
    var skill Light_Thrown
    goto display_weapon
  }

  if %is_thrown = YES {
    action (skill) var skill Light_Thrown when light thrown|small edged|small blunt
    action (skill) var skill Heavy_Thrown when heavy thrown|heavy blunt|large edged|two-handed
  }

  send appraise my %weapon quick
  waitfor Roundtime
  pause 0.5

  display_weapon:
    action (skill) off

    if %use_offhand = YES && $righthand != Empty then send swap

    echo
    echo *** %skill ***
    echo

  return

remove_weapon:
  send hold %weapon
  var sheath_style wear
  goto appraise_weapon

checkinfo:
  put info
  waitfor Encumbrance
  action (info) off
  return

#
#  Start of Combat
#
begin:

  if %is_ranged = YES then {
    action (ranged) var FULL_AIM YES when You think you have your best shot possible
    action (ranged) var FULL_AIM NO when stop concentrating on aiming
    goto ranged_combat
  }

  if %tm_mode = YES then {
    put .tmhelper
    goto tm_combat
  }

attack:
  gosub clear
  var last_combat attack

  pause 0.5

  if %guild = Bard && %use_screams = YES then gosub bard

  if $hidden = 0 && %should_stealth = YES then gosub stealth

  matchre check_loot Roundtime
  matchre wait_for_mobs There is nothing|close enough to attack|What are you trying to attack|It would help if you were closer
  if %use_offhand == YES then put %attack_style left
  else put %attack_style
  matchwait 10
  goto attack

wait_for_mobs:
  gosub clear
  send advance
  pause 5
  goto %last_combat

#
#  Ranged Combat
#

ranged_combat:

  gosub clear

  var last_combat ranged_combat

  pause 0.5

  if %guild = Bard && %use_screams = YES then gosub bard
  if %guild = Ranger && %skill = Bow then var ranged_action arrows

  gosub load
  gosub aim
  if %should_stealth = YES then gosub stealth
  gosub aiming
  gosub fire

  gosub check_loot

  goto ranged_combat

aiming:
  if %FULL_AIM = YES then {
    var FULL_AIM NO
    return
  }
  action (ranged) off
  waitforre best shot possible|You stop concentrating on aiming your weapon.
  var FULL_AIM NO
  action (ranged) on
  return

aim:
  matchre aim.after.load isn't loaded
  matchre aim.fire already targetting that
  matchre return best shot possible now|begin to target|You shift your
  matchre wait_for_mobs ^There is nothing else to face!|^What are you trying to attack
  send aim
  matchwait 5
  goto aim

aim.fire:
  var FULL_AIM YES
  return

aim.after.load:
  gosub load
  goto aim

fire:
  matchre fire You can not poach|are not hidden
  matchre return ^I could not find what you were|isn't loaded|Roundtime
  if $hidden = 1 then send %ranged_hidden_attack
  else send fire
  matchwait 5
  goto fire

load:
    matchre gather_ammo ^You don't have the proper ammunition readily available for your
    matchre gather_ammo ^You must|your hand jams|^You can not load
    # matchre RANGE_REMOVE_CHECK (\w+) makes the task more difficult|while wearing a (.+)|while wearing an (.+)
    # matchre Repeater.Load ammunition chamber|already loaded with as much ammunition as it can hold
    matchre return Roundtime|is already
    var FULL_AIM NO
    put load %ranged_action
    matchwait 5
    goto load

gather_ammo:

  ammo.loop:
    matchre return ^Stow what|^You must unload|^You get some
    matchre ammo.loop ^You pick up|^You put|^You stow|^You get
    pause 0.5
    put stow %ranged_ammo
    matchwait

ranged_unload:
  send unload my %weapon
  pause 1
  send stow my %ranged_ammo
  return

#
# Hiding routine
#

stealth:
  if %hide_if_locked = NO && $Stealth.LearningRate >= 34 then return

  if %guild = Thief || %guild = Ranger then {

    if %circle >= 50 then {
      goto stalk
    }

  }

hide:

  # if (%guild = Thief || %guild = Ranger) && %circle >= 50 then goto stalk

  match hide ...
  matchre hide Your attempt to hide fails|notices your
  matchre stalk You blend in with your surroundings|You melt into the background|already hidden
  pause 0.5
  put hide
  matchwait

stalk:
  match stalk ...
  matchre hide You must be hidden first|try being out of sight
  matchre return You move into position to stalk|already|There is nothing else to face|Stalk what|Face what
  pause 0.5
  put stalk
  matchwait

check_loot:
  gosub get_thrown
  gosub health
  if matchre("$roomobjs", "(%skinnablecritters) ((which|that) appears dead|\(dead\))") then gosub skin
  if matchre("$roomobjs", "((which|that) appears dead|\(dead\))") then {
    gosub stats
    send %loot_option
    gosub handle_loot
    if %is_ranged = YES {
      gosub gather_ammo
      gosub check_exp
    }
  }

  if %is_ranged != YES {
    gosub check_exp
  }

  gosub fatigue
  goto %last_combat

get_thrown:
  if %is_thrown = YES then put get my %weapon
  return

#
#  TM Combat
#

tm_combat:
  var skill Targeted_Magic
  gosub clear

  var last_combat tm_combat

  pause 0.5

  if %guild = Bard && %use_screams = YES then gosub bard

  gosub tm_prep
  gosub tm_aiming
  gosub tm_cast

  gosub check_loot

  goto tm_combat

tm_prep:
  put target %tm_spell %tm_mana
  match RETURN You begin to weave
  match tm_quick_cast But you're already preparing a spell!
  matchwait 2
  goto tm_prep
  return

tm_aiming:
  waitforre Your formation of a targeting pattern
  pause 0.5
  return

tm_cast:
  put cast
  pause 0.5
  return

tm_quick_cast:
  put cast
  pause 0.5
  goto tm_prep

check_exp:
  if %check_exp = YES {
    if $%skill.LearningRate >= %exp_threshold {
      echo
      echo  *** %skill finished **
      echo
      goto end
    }
  }
  return

stats:
  gosub calc_stats
  gosub show_stats
  return

calc_stats:
  math kill_count add 1
  var g_kill_count $global_kill_count
  math g_kill_count add 1
  put #var global_kill_count %g_kill_count
  return

show_stats:
  echo
  echo   *** Kills this run: %kill_count
  echo   *** All-time kills: $global_kill_count
  echo
  return

skin:
  gosub do_arrange
  send skin
  pause 2
  # if $righthand != %weapon then send empty right
  # if $lefthand != %weapon then send empty left
  return

do_arrange:
  var count 0
  arrange.loop:
    if %count < %arrange {
      matchre RETURN You complete arranging|That has already been arranged as much as you can manage
      matchre arrange_add Roundtime
      put %arrange_action
      matchwait 3
      goto arrange.loop
    }
  return

arrange_add:
  math count add 1
  goto arrange.loop

handle_loot:
  pause 1
  if %should_loot_coins = YES then {
    gosub loot_coins
  }
  if %should_loot_gems = YES then {
    gosub loot_gems
  }
  return

loot_coins:
  matchre loot_coins You pick up
  matchre RETURN I could not find|What were you referring
  send get coin
  matchwait 3
  goto loot_coins

loot_gems:
  matchre loot_gems You pick up
  matchre RETURN I could not find|What were you referring|Stow what
  send stow gem
  matchwait 3
  goto loot_gems

RETURN:
  return

bard:

  if $Bardic_Lore.LearningRate >= 34 then return

  matchre toggle.scream looking somewhat like a fish
  matchre return Roundtime|a few more seconds to use it again
  put scream %bard_scream
  matchwait 5
  return

toggle.scream:
  var use_screams NO
  return

health:
  if $health <= %health_threshold {
    gosub clear
    goto abort
  }
  return

fatigue:
  if $stamina <= %fatigue_threshold {

    if $guild == Barbarian && %berserk_on_fatigue == YES {
      echo
      echo *** BERSERK %fatigue_berserk! ***
      echo
      send berserk %fatigue_berserk
    }

    echo
    echo  *** Recovering stamina ***
    echo
    pause 0.5
    send bob
    pause 5
    goto fatigue
  }
  return

abort:

  var abort_count 0

  abort.loop:

    if %abort_count >= 3 {
      goto aborted
    }

    math abort_count add 1
    put #beep
    echo
    echo  *** Seek medical attention!  $health/100  ***
    echo
    send retreat
    send retreat
    pause 3
    goto abort.loop

aborted:
  if %is_ranged = YES then gosub gather_ammo
  gosub sheath_weapon
  put #parse HUNT ABORTED
  put look
  exit

sheath_weapon:
  if %is_ranged = YES then gosub ranged_unload

  pause 0.5

  matchre wear_weapon where\?
  matchre return ^You sheath|^You sling|^You attach|^You strap|^With a flick of your wrist|^You hang|you sheath|^Sheathe what\?|^You easily strap|^With fluid and stealthy movements|^You slip|^You secure
  send %sheath_style my %weapon
  matchwait

wear_weapon:
  pause 0.5
  matchre stow_weapon You can't wear that!|can't wear any more items like that
  matchre return You sling|Wear what?|You attach
  put wear my %weapon
  matchwait

stow_weapon:
  pause 0.5
  matchre return You put|easily strap|already in your inventory
  put stow my %weapon
  matchwait

end:
  if %is_ranged = YES then gosub gather_ammo
  if %tm_mode = YES then put #script abort tmhelper

  gosub sheath_weapon

  if $righthand != Empty then send stow right
  if $lefthand != Empty then send stow left

  put #beep
  put #parse HUNT DONE
