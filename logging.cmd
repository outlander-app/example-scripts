debug 5

var danger NO
var keep bloodwood|copperwood|darkspine|silverwood|pozumshi|smokewood|mistwood|goldwood|glitvire|adderwood|rockwood|azurelle|gloomwood|diamondwood|alerce
var logs nothing
if_1 var keep %keep|%1
var foundRare 0

action var danger YES when A monotonous buzzing sound fills the air|You notice an unusual smell drifting through the area|A loud cracking sound resonates from somewhere closeby
action var foundRare 1 when While studying the area you notice some wood trapped undernearth some branches and prepare to free it.

chop:
  if $standing = 0 then put stand
  pause 0.5
  if "%danger" = "YES" then goto danger
  matchre careful unable to find a tree large enough to produce usable wood|rotted core after just a few chops|you fail to find any trees to chop
  matchre done Perhaps you should try again with an actual lumberjacking tool
  put chop tree
  matchwait 3

  gosub check_logs
  gosub check_keep

  goto chop

check_logs:
  if matchre("$roomobjs","(%logs) log") then { gosub deed }
  return

check_keep:
  return

  if matchre("$roomobjs","(%keep) (\w+)") then
  {
    var stow $0

    if $2 = log then gosub deed %stow
    else put stow %stow

    if %foundRare = 1 then
    {
      put #echo >log #8DEEEE Found: %stow
      var foundRare 0
    }

  }

  return

deed:
  put get packet
  pause .5
  put push log with packet
  pause .5
  put stow packet
  pause .5
  put stow deed
  pause .5
  return

danger:
  pause 0.5
  matchre danger_fixed Your analysis has shown a way to significantly reduce the danger|find nothing of concern lurking within the nearby forest
  put watch forest danger
  matchwait 5
  goto danger

danger_fixed:
  var danger NO
  goto chop

careful:
  match done Your analysis has revealed no additional resources to be found here.
  put watch forest careful
  matchwait 4
  goto chop

done:
  put #parse LOGGING CONTINUE
  exit
