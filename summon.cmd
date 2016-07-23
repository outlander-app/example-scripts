# Simple script to train Warrior Mage's Summoning skill.
# Summon admittance / impedance until mind locked.
# debuglevel 5

start:
  var summon_action impedance
  goto summon

summon:
  gosub summon_exp_check
  matchre set_action_to_admittance briefly increasing|further increasing|cannot discharge|you have exhausted your planar charge
  matchre set_action_to_impedance briefly decreasing|further decreasing|so heavily embody
  pause 0.5
  put summon %summon_action
  matchwait 30
  goto summon

set_action_to_admittance:
  var summon_action admittance
  goto summon

set_action_to_impedance:
  var summon_action impedance
  goto summon

summon_exp_check:
  if $Summoning.LearningRate >= 34 then goto move_out
  return

move_out:
  pause 2
  put #parse SUMMONING DONE
