# debug 5

var maxexp 34
var item %1
var skill Outdoorsmanship

if_3 then var skill Perception

Collect:
  match Kick You manage to collect
  matchre Collect unable to find anything|wondering what you might find|what it was you were looking for|is this what you were looking for|better luck trying to find
  match Wait1 ...wait
  match stopPlay bit too busy performing to do that
  put collect %item
  matchwait 3
  goto Collect

stopPlay:
  put stop play
  goto Collect

Wait1:
  pause 1
  goto Collect

Wait2:
  pause 1
  goto Kick

Kick:
  pause 0.5
  matchre CheckEXP You take a step back|Now what did the|I could not find
  match Wait2 ...wait
  put kick %1
  matchwait 3

CheckEXP:
  pause 0.2
  if $%skill.LearningRate >= %maxexp then goto END
  goto Collect

END:
  pause 1
  put #parse FORAGING DONE
