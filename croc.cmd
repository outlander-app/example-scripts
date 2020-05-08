var bag kit
var skin $skinning_skin

if_1 then goto %1

Get:
  put get my %skin
  waitforre You get|You are already
  put study my %skin
  goto checkExp

skin:
  pause 0.5
  matchre repair You skillfully peel|Maybe you should REPAIR it
  matchre done The leather looks frayed
  put skin my %skin
  matchwait 5
  goto skin

repair:
  pause 0.5
  matchre checkExp With some needle and thread
  matchre skin isn\'t in need of repair
  matchre done The leather looks frayed
  put repair my %skin
  matchwait 5
  goto repair

checkExp:
  if ($Skinning.LearningRate >= 33) then goto done
  goto skin

done:
  pause 1
  put put my %skin in my %bag