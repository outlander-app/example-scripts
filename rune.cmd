# debug 5

var maxexp $Sorcery.LearningRate
math maxexp add 12
if %maxexp >= 34 then {
  var maxexp 34
}

goto START

maxexp:
  var maxexp 34
  return

START:
  if_1 then
  {
    gosub %1
    shift
    goto START
  }


focus:
    match check_exp Roundtime
    put focus my runestone
    matchwait 3
    goto focus

check_exp:
    if $Sorcery.LearningRate >= 34 then goto end
    goto focus

end:
  send stow rune
  send hide
  put #parse SORCERY DONE