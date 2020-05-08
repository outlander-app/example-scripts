debug 5

var bag kit
var box $training_box

if_1 then goto %1

Get:
  put get my %box
  put get my lockpick
  waitforre You get|You are already
  put study my %box
  goto checkExp

GetLockpick:
  put get my lockpick
  waitfor You get
  goto pick

pick:
  pause 0.5
  matchre checkExp CLICK
  matchre GetLockpick You need some type of tool
  matchre done The lock feels warm|you are not making any progress|The lock looks weak
  put lock my %box
  put pick my %box with my lockpick
  matchwait 5

checkExp:
  if ($Locksmithing.LearningRate >= 33) then goto done
  goto pick

done:
  pause 1
  put stow my lockpick
  put put my %box in my %bag
