#
#  hunt.cmd - version 2.0
#  Requires Outlander 2.0.30 or higher
#

#debug 5

#
#  User defined variables
#
var health_threshold 50
var fatigue_threshold 70
var should_loot_coins NO
var should_loot_gems NO
var should_loot_boxes NO
var loot_option loot
var arrange 5
var berserk_on_fatigue YES
var fatigue_berserk avalanche
var bard_scream havoc
var sling_ammo shard
var crossbow_ammo pulzone
var slingbow_ammo shard
var repating_crossbow_ammo_count 4
var bow_ammo arrow
var brawling_moves circle|elbow|claw|kick|punch
var diety Eluned
var pray_messaging You offer
var spellPrep With tense movements you|You begin chanting|With rigid movements|You raise your palms skyward|motes of sanguine light swirl briefly about your fingertips


#
#  Script Variables
#


var kill_count 0
var use_offhand NO
var check_exp NO
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
var invoke_weapon NO
var should_pray NO
var last_prayer_timestamp 0
var should_hunt NO
var hunt_timer 75
var loot_timer 7
var drop_skins NO
var preserve NO
var dissect NO
var appraise NO
var debil NO
var debil_spell
var debil_mana
var spell_style prepare

var brawl NO
var brawling_move_count 0
eval brawling_moves_max countsplit("%brawling_moves", "|")

#
#  Critter variables
#
var skinnablecritters rat|hog|goblin|spider|boar|eel|bobcat|cougar|reaver|wolf|rock troll|snowbeast|gargoyle|steed|togball|leucro|adder|skeleton|ape|tusky|wyvern|drake

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
action (spell) var fully_prepared YES when You feel fully prepared|Your formation of a targeting pattern

if_1 then goto start
else {
  echo
  echo  *** You need to provide a weapon to use ***
  echo  *** .hunt spear
  echo  *** .hunt offhand nightstick
  echo  *** .hunt tm stra 2 sword
  echo
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

app:
appraise:
  var appraise YES
  return

brawl:
  var brawl YES
  return

throw:
  var attack_style throw
  var is_thrown YES
  return

invoke:
  var invoke_weapon YES
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

pray:
  var should_pray YES
  var last_prayer_timestamp 0
  return

hunt:
  var should_hunt YES
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

deb:
debil:
spell:
  var debil YES
  shift
  var debil_spell %1
  shift
  var debil_mana %1

  echo
  echo *** Casting spell %debil_spell with %debil_mana mana ***
  echo
  return

box:
boxes:
  var should_loot_boxes YES

  echo
  echo *** Looting Boxes ***
  echo

  return

coin:
coins:
  var should_loot_coins YES

  echo
  echo *** Looting Coins ***
  echo

  return

gem:
gems:
  var should_loot_gems YES

  echo
  echo *** Looting Gems ***
  echo

  return

preserve:
  var preserve YES

  echo
  echo *** Preserving Corpses ***
  echo

  return

dissect:
  var dissect YES

  echo
  echo *** Dissecting Corpses ***
  echo

  return

wield:

  if "%weapon" == "log" || "%weapon" == "rock" then goto appraise_weapon

  matchre appraise_weapon You draw|You slip|already holding|You deftly|With fluid and stealthy movements you draw
  matchre remove_weapon remove it first
  matchre no_weapon Wield what?
  matchre get_weapon as it is lying at your feet
  send wield my %weapon
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
  if %use_offhand == YES {
    var skill Offhand_Weapon
    goto display_weapon
  }

  if %weapon == log {
    var skill Heavy_Thrown
    goto display_weapon
  }

  if %weapon == rock {
    var skill Light_Thrown
    goto display_weapon
  }

  if %is_thrown == YES {
    action (skill) var skill Light_Thrown when light thrown|small edged|small blunt
    action (skill) var skill Heavy_Thrown when heavy thrown|heavy blunt|large edged|two-handed|stave
  }

  if %brawl == YES {
    var skill Brawling
    goto display_weapon
  }

  send appraise my %weapon quick
  waitfor Roundtime
  pause 0.5

  display_weapon:
    action (skill) off

    if matchre("$righthand", "slingbow") then var ranged_ammo %slingbow_ammo

    if %use_offhand == YES && "$righthand" != "Empty" then send swap

    echo
    echo *** %skill ***
    echo

  return

remove_weapon:
  send remove my %weapon
  var sheath_style wear
  goto appraise_weapon

checkinfo:
  put info;enc
  waitfor Encumbrance
  action (info) off
  return

#
#  Start of Combat
#
begin:

  if %is_ranged == YES then {
    action (ranged) var FULL_AIM YES when You think you have your best shot possible
    action (ranged) var FULL_AIM NO when stop concentrating on aiming
    if %should_stealth != YES then { put .tmhelper }
    goto ranged_combat
  }

  if %tm_mode == YES then {
    put .tmhelper
    goto tm_combat
  }

  if %brawl == YES then {
    goto brawling_combat
  }

  goto attack

attack:
  gosub clear
  var last_combat attack

  if %guild == Bard && %use_screams == YES then gosub bard
  if %guild == Cleric && %should_pray == YES then gosub cleric

  if "%debil" != "NO" {
    if "%fully_prepared" == "YES" || $spelltime >= 25 then gosub spell_cast
    if "$preparedspell" == "None" then gosub spell_prep %debil_spell %debil_mana
  }

  if %should_hunt == YES then gosub do_hunt
  if $hidden == 0 && %should_stealth == YES then gosub stealth

  matchre check_loot Roundtime
  matchre wait_for_mobs There is nothing|close enough to attack|What are you trying to attack|It would help if you were closer|You must be closer
  matchre do_get_thrown What are you trying to throw|What are you trying to lob|What are you trying to hurl|You must hold
  if %use_offhand == YES then put %attack_style left
  else put %attack_style
  matchwait 2
  goto attack

do_get_thrown:
  gosub get_thrown
  goto %last_combat

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

  if %guild == Bard && %use_screams == YES then gosub bard
  if %guild == Cleric && %should_pray == YES then gosub cleric
  if %guild == Ranger && %skill == Bow then var ranged_action arrows

  if "%debil" != "NO" {
    if "%fully_prepared" == "YES" || $spelltime >= 25 then gosub spell_cast
    if "$preparedspell" == "None" then gosub spell_prep %debil_spell %debil_mana
  }

  gosub load
  gosub aim
  if %should_stealth == YES then gosub stealth
  gosub aiming
  gosub fire

  gosub check_loot

  goto ranged_combat

aiming:
  if %FULL_AIM == YES then {
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
  put aim
  matchwait 2
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
  if $hidden == 1 then send %ranged_hidden_attack
  else send fire
  matchwait 2
  goto fire

load:
  if matchre("$righthand", "riot|repeating") then goto Repeater.Load

  matchre gather_ammo ^You don't have the proper ammunition
  matchre gather_ammo ^You must|your hand jams|^You can not load
  matchre Repeater.Load ammunition chamber|already loaded with as much ammunition as it can hold
  matchre buff_stw Such a feat would be impossible without the winds to guide you
  matchre change_ranged_action You don't have enough
  matchre return Roundtime|is already
  var FULL_AIM NO
  put load %ranged_action
  matchwait 2
  goto load

change_ranged_action:
  var ranged_action
  goto load

buff_stw:
  put .charge stw 20 40
  waitforre ^BUFF DONE
  goto load

Repeater.Load:
  if "$lefthand" != "Empty" then put stow $lefthandnoun
  matchre RETURN A rapid series of clicks emanate|already loaded with as much ammunition as it can hold|readying more than one bolt could
  matchre Repeater.Load.Full exhausted the crossbow's ammunition store
  var FULL_AIM NO
  put push my $righthandnoun
  matchwait 10
  goto Repeater.Load

Repeater.Load.Full:
  var load_count 0
  gosub gather_ammo

  Repeater.Load.Full.2:
    if "%guild" != "Ranger" && "$lefthand" == "Empty" then put get my %ranged_ammo
    math load_count add 1
    if %load_count > %repating_crossbow_ammo_count then goto Repeater.Load

    matchre gather_ammo ^You don't have the proper ammunition
    matchre gather_ammo ^You must|your hand jams|^You can not load
    matchre Repeater.Load already loaded with as much ammunition as it can hold
    matchre Repeater.Load.Full.2 ammunition chamber
    put load
    matchwait 10
    goto Repeater.Load.Full.2

gather_ammo:

  ammo.loop:
    matchre return ^Stow what|^You must unload|^You get some|^But that is already
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
  if %hide_if_locked == NO && $Stealth.LearningRate >= 34 then return

  if %guild == Thief || %guild == Ranger then {
    if %circle >= 50 then {
      goto stalk
    }
  }

hide:

  # if (%guild == Thief || %guild == Ranger) && %circle >= 50 then goto stalk

  match hide ...
  matchre hide Your attempt to hide fails|notices your|ruining your hiding place
  matchre stalk You blend in with your surroundings|You melt into the background|already hidden
  pause 0.5
  put hide
  matchwait

stalk:
  match stalk ...
  matchre hide You must be hidden first|try being out of sight|ruining your hiding place
  matchre return You move into position to stalk|already|There is nothing else to face|Stalk what|Face what
  pause 0.5
  put stalk
  matchwait

check_loot:
  gosub clear
  gosub get_thrown
  gosub health

  if $next_loot_timestamp > $gametime then goto after_loot

  if matchre("$roomobjs", "((which|that) appears dead|\(dead\))") then
  {
    if "%preserve" != "NO" then
    {
        put .preserve preserve
        waitforre ^PRESERVE DONE
    }
    else if $First_Aid.LearningRate < 34 && "%dissect" != "NO" then
    {
        put .preserve dissect
        waitforre ^PRESERVE DONE
    }
    else {
      if $Skinning.LearningRate >= 30 {
        put .preserve dissect
        waitforre ^PRESERVE DONE
      }
      else {
        if matchre("$roomobjs", "(%skinnablecritters) ((which|that) appears dead|\(dead\))") then {
          gosub skin
        }
      }
    }

    gosub do_loot

    var temp $unixtime
    math temp add %loot_timer
    put #var next_loot_timestamp %temp

    if %is_ranged == YES {
      gosub gather_ammo
      gosub check_exp
    }
  }

  after_loot:

  if %is_ranged != YES || "%ranged_ammo" == "shard" {
    gosub check_exp
  }

  gosub fatigue

  goto %last_combat

get_thrown:
  pause 0.5
  if %invoke_weapon == YES then {
    goto get_invoke
  }

  if %is_thrown == YES then put get my %weapon;get %weapon

  goto RETURN

get_invoke:
  matchre RETURN suddenly leaps|any bonds to invoke
  put invoke
  matchwait 5
  goto get_invoke

#
#  TM Combat
#

tm_combat:
  var skill Targeted_Magic
  gosub clear

  var last_combat tm_combat

  pause 0.5

  if %guild == Bard && %use_screams == YES then gosub bard
  if %guild == Cleric && %should_pray == YES then gosub cleric
  if %should_hunt == YES then gosub do_hunt

  gosub tm_prep
  gosub tm_aiming
  gosub tm_cast

  gosub check_loot

  goto tm_combat

tm_wait:
  put release spell
  pause 5
  goto tm_combat

tm_prep:
  match RETURN You begin to weave
  match tm_wait nothing else to face
  matchre tm_quick_cast But you're already preparing a spell|You are already preparing|You have already
  put target %tm_spell %tm_mana
  matchwait 2
  goto tm_prep

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

#
# Brawling
#

brawling_combat:

  gosub clear
  var last_combat brawling_combat

  pause 0.5

  if %guild == Bard && %use_screams == YES then gosub bard
  if %guild == Cleric && %should_pray == YES then gosub cleric

  if "%debil" != "NO" {
    if "%fully_prepared" == "YES" || $spelltime >= 25 then gosub spell_cast
    if "$preparedspell" == "None" then gosub spell_prep %debil_spell %debil_mana
  }

  if %should_hunt == YES then gosub do_hunt
  if $hidden == 0 && %should_stealth == YES then gosub stealth

  gosub brawling_attack
  gosub check_loot

  goto brawling_combat

brawling_attack:
  var attack_style %brawling_moves[%brawling_move_count]

  matchre brawling_next_move Roundtime
  matchre wait_for_mobs There is nothing|What are you trying to attack|It would help if you were closer|You must be closer
  if "%use_offhand" == "YES" then put %attack_style left
  else put %attack_style
  matchwait 5
  goto brawling_attack

brawling_next_move:
  math brawling_move_count add 1

  if %brawling_move_count >= %brawling_moves_max then var brawling_move_count 0

  return

#
# spells
#
spell_prep:
  var spell &1
  var spell_mana &2
  spell_repeat:
    matchre RETURN %spellPrep
    matchre spell_quick_cast But you're already preparing a spell|You are already preparing|You have already fully
    put prepare %spell %spell_mana
    matchwait 2
    goto spell_repeat

spell_cast:
  put cast
  pause 0.5
  var fully_prepared NO
  return

spell_quick_cast:
  put cast
  pause 0.5
  var fully_prepared NO
  goto spell_repeat

#
# misc
#

check_exp:
  if "%check_exp" == "YES" {
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
  gosub do_skin
  pause 1.5

  # if $righthand != %weapon then send empty right
  # if $lefthand != %weapon then send empty left

  if "$righthand" != "Empty" && "$lefthand" != "Empty" then
  {
    debug 5
    gosub bundle
  }
  return

do_skin:
  pause 0.5
  match wait_skin ...
  matchre RETURN Roundtime|Skin what
  put skin
  matchwait 5
  goto do_skin

wait_skin:
  pause 1
  goto do_skin

do_arrange:
  var count 0
  arrange.loop:
    if %count < %arrange {
      matchre RETURN You complete arranging|That has already been arranged as much as you can manage|Arrange what|You don't know how to do that
      matchre arrange_add Roundtime
      put %arrange_action
      matchwait 2
      goto arrange.loop
    }
  return

arrange_add:
  math count add 1
  goto arrange.loop

do_loot:
  match wait_loot ...
  match RETURN could not find what you were referring
  matchre handle_loot You search
  put %loot_option
  matchwait 5
  goto do_loot

wait_loot:
  pause 1
  goto do_loot


handle_loot:
  gosub stats

  if %should_loot_coins == YES then
  {
    gosub loot_coins
  }

  if %should_loot_gems == YES then
  {
    gosub loot_gems
  }

  if %should_loot_boxes == YES then
  {
    gosub loot_boxes
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

loot_boxes:
  matchre loot_boxes You put
  matchre RETURN I could not find|What were you referring|Stow what
  send stow box
  matchwait 3
  goto loot_boxes

toggle_loot_boxes_off:
  var should_loot_boxes NO
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

cleric:
  if $Theurgy.LearningRate >= 34 then return
  put pray %diety
  waitfor %pray_messaging
  return

do_hunt:
  if ($Perception.LearningRate < 34 || "$guild" == "Ranger" && $Scouting.LearningRate < 34) && $last_hunt_timestamp < $gametime
  {
    put hunt
    pause 2

    var temp $gametime
    math temp add %hunt_timer
    put #var last_hunt_timestamp %temp
  }
  return

health:
  if $health <= %health_threshold {
    gosub clear
    goto abort
  }
  return

bundle:

  if "%drop_skins" == "YES" then
  {
    goto dropSkin
  }

  gosub sheath_weapon

  put get my bundling rope
  match bundle2 You get
  match noRope What were you referring
  matchwait 2

bundle2:
  put bundle

  put tie my bundle
  put tie my bundle
  waitfor you tie

  put adjust my bundle
  put wear my bundle
  waitfor You sling

  gosub wield
  return

noRope:
  var drop_skins YES
  return

dropSkin:
  if contains($righthand, %weapon) then put empty left
  if contains($lefthand, %weapon) then put empty right
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

    if %abort_count >= 10 {
      goto aborted
    }

    math abort_count add 1
    put #beep
    echo
    echo  *** Seek medical attention!  $health/100  ***
    echo
    if $standing == 0 then send stand
    send retreat
    send retreat
    pause 3
    goto abort.loop

aborted:
  if %is_ranged == YES then gosub gather_ammo
  gosub sheath_weapon
  put #parse HUNT ABORTED
  put look
  exit

sheath_weapon:
  if %is_ranged == YES then gosub ranged_unload
  if %is_thrown == YES then gosub get_thrown

  pause 0.5

  matchre wear_weapon where\?
  matchre return ^You sheath|^You sling|^You attach|^You strap|^With a flick of your wrist|^You hang|you sheath|^Sheathe what\?|^You easily strap|^With fluid and stealthy movements|^You slip|^You secure|^Sheathing
  send %sheath_style my %weapon
  matchwait 4
  goto sheath_weapon

wear_weapon:
  pause 0.5
  matchre stow_weapon You can't wear that!|can't wear any more items like that
  matchre return You sling|Wear what?|You attach
  put wear my %weapon
  matchwait 4
  goto wear_weapon

stow_weapon:
  pause 0.5
  matchre return You put|easily strap|already in your inventory
  put stow my %weapon
  matchwait 4
  goto stow_weapon

end:
  if %is_ranged == YES then gosub gather_ammo

  put #script abort tmhelper

  gosub sheath_weapon

  if "$righthand" != "Empty" then send stow right
  if "$lefthand" != "Empty" then send stow left
  if "$preparedspell" != "None" then send release spell

  put look

  put #beep
  put #parse HUNT DONE
