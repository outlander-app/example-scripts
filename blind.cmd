
put get my lockpick
put get my %0
waitforre You get|You are already

top:
  matchre checkExp Roundtime
  matchre get.pick Find a more appropriate tool and try again
  matchre end not even locked
  put pick blind
  matchwait 3

get.pick:
  put get my lockpick
  waitforre You get|You are already
  goto top

checkExp:
  if $Locksmithing.LearningRate >= 34 then goto end
  goto top

end:
  put stow left
  put stow right
  put #parse LOCKSMITHING DONE
