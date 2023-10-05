#
# Requires Outlander 2.0.30 or higher
#
# This script uses aliases
# ps = stance set 100 79 1
# ss = stance set 100 1 79
# atk = .hunt coins boxes $0
# 

debug 5

put #class -app -analyze +combat

var exp_threshold 5
var max_exp 32

var weapons Targeted_Magic|Bow|Brawling|Large_Edged|Small_Edged|Heavy_Thrown
var options tm ec 20 blade|snipe longbow|brawl "hara.axe"|"hara.axe"|blade|debil df 20 lob throwing.hammer
var stance ps|ss|ss|ss|ps|ss

# var weapons Targeted_Magic|Brawling|Large_Edged|Small_Edged|Heavy_Thrown
# var options tm ec 20 blade|brawl "hara.axe"|"hara.axe"|blade|debil df 20 lob throwing.hammer
# var stance ps|ss|ss|ps|ss

if_1 then
{
  var weapons Bow|Large_Edged|Small_Edged
  var options snipe longbow|hara.axe|ambush blade
  var stance ss|ss|ps
}

if_2 then
{
  var weapons Crossbow|Slings|Targeted_Magic|Heavy_Thrown|Polearms|Offhand_Weapon|Twohanded_Edged|Twohanded_Blunt|Staves|Light_Thrown|Large_Blunt
  var options slingbow|slingshot|tm ec 20 blade|debil df 20 lob throwing.hammer|debil df 20 spear|debil df 20 offhand mace|debil df 20 greataxe|debil df 20 maul|debil df 20 cap.bar|debil df 20 lob throwing.axe|debil df 20 throwing.hammer
  var stance ss|ss|ps|ss|ps|ss|ss|ps|ss|ps|ss|ss|ps
}

if "$combat_run" == "2" then
{
  var weapons Targeted_Magic|Small_Edged|Offhand_Weapon|Light_Thrown|Bow|Polearms|Large_Blunt|Small_Blunt|Brawling|Heavy_Thrown
  var options tm stra 10 wakizashi|wakizashi|offhand tonfa|lob "carving knife"|poach shortbow|spear|hammer|mace|brawl wakizashi|lob spear
  var stance ps|ps|ss|ss|ss|ps|ps|ss|ps|ss

  var exp_threshold 10
}

#action var weapon $1;var current_weapon $2 when ^EXPTRACKER (.+) (-?\d+)

eval weapons_count countsplit(%weapons, "|")
var current_weapon 0


Combat:
  if %exp_threshold > %max_exp then goto End

  send 0.5 /tracker lowest %weapons
  waitforre ^EXPTRACKER (.+) (-?\d+)
  var weapon $1
  var current_weapon $2
  #echo lowest weapon is %weapon option is %options[%current_weapon]

  if $%weapon.LearningRate >= %exp_threshold then {

    math exp_threshold add 10

    if $%weapon.LearningRate < %max_exp && %exp_threshold > %max_exp then {

      var exp_threshold %max_exp

    }

    goto Combat
  }

  echo
  echo Starting %weapons[%current_weapon]
  echo

  gosub Hunt

  goto Combat

Hunt:
  var opts %options[%current_weapon]
  send %stance[%current_weapon]
  var temp %exp_threshold
  math temp add 2
  echo
  echo atk exp %temp %opts
  echo
  pause 1
  # atk is an alias for '.hunt'
  put atk exp %temp %opts
  waitforre ^HUNT DONE
  send ss
  return


End:
  send ss

  put #class +app +analyze -combat

  put #beep
  put #parse COMBAT DONE

  put .aftercombat
