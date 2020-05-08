debuglevel 5

var aug focus
var util hasten
var play_song YES

action var play_song YES when You finish playing

if_1 then goto %1

start:
  if $standing = 1 then put sit
  gosub khri %aug
  gosub khri %util
  goto meditate

khri:
  var khri $0
  if "%khri" = "EMPTY" then return
  khri.s:
    pause 0.5
    matchre RETURN You already|You're already using|Roundtime
    put khri %khri
    matchwait 3
  goto khri.s

RETURN:
  return

meditate:
  pause 0.5

  if ("%play_song" = "YES") then
  {
    put play $play.song $play.style
    var play_song NO
  }

  matchre checkExp You focus your mind
  matchre done Your thoughts are clear and focused.
  put khri meditate
  matchwait 3
  goto meditate

checkExp:
  if ($Augmentation.LearningRate >= 34) then goto done
  goto meditate

done:
  pause
  send khri stop
  send stop play
  wait
  send stand
  put #parse KHRI DONE
