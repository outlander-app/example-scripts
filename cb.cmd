#
# Requires Outlander 0.10.11 or higher
#

debug 5

put #class -app +combat

var weapons Targeted_Magic|Bow|Large_Edged|Small_Edged
var options tm ec 17 blade|snipe longbow|"hara.axe"|ambush blade
var stance ps|ss|ss|ps

#var weapons Bow|Large_Edged|Small_Edged
#var options snipe longbow|"hara.axe"|ambush blade
#var stance ss|ss|ps

var exp_threshold 5
var max_exp 32

eval weapons_count countsplit(%weapons, "|")
var current_weapon 0


Combat:

  if %exp_threshold > %max_exp then goto End

  pause 0.5
  gosub WhatWeapon

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
  pause

  gosub Hunt

  pause

  goto Combat

WhatWeapon:
  var temp_start 0
  var temp_weapon %weapons[0]
  var min 0

  WhatWeapon.Loop:
    math temp_start add 1
    if %temp_start >= %weapons_count then {
      var current_weapon %min
      var weapon %weapons[%current_weapon]
      var opts %options[%current_weapon]
      return
    }

    var next_weapon %weapons[%temp_start]
    if $%next_weapon.LearningRate < $%temp_weapon.LearningRate then {
      var min %temp_start
      var temp_weapon %weapons[%min]
    }

    goto WhatWeapon.Loop


Hunt:
  var opts %options[%current_weapon]
  send %stance[%current_weapon]
  echo
  echo atk exp %exp_threshold %opts
  echo
  put atk exp %exp_threshold %opts
  waitforre ^HUNT DONE
  return


End:

  send ss

  put #class app on
  put #class combat off
  put #beep
  put #parse COMBAT DONE

  if $zoneid = 69 {
    put #goto 5
  }
