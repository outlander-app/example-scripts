#debuglevel 5

Start:
  gosub Swim %1
  gosub Swim %2
  goto Start

Swim:
  var swimDirection $0

Swim.w:
  matchre SwimmingEXPCheck You swim|You splash|You wade
  matchre Swim.w You work|You struggle|You flounder|You slap
  match Swim.w seconds
  pause 0.5
  put %swimDirection
  matchwait 30
  goto MoveOut

RETURN:
  return

SwimmingEXPCheck:
  if $Athletics.LearningRate >= 34 then goto MoveOut
  return

MoveOut:
  pause 2
  send hide
  put #parse ATHLETICS DONE
