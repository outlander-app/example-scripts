#
# automapper.cmd - version 0.4
# Requires Outlander 0.11.4 or higher
# added SCRIPT handling ~ SAUVA(Hanryu) - 5/17/17
# added SearchObj handling ~ SAUVA(Hanryu) - 5/17/17
# fixed missing THEN ~ SAUVA(Hanryu) - 5/17/17

#debug 5

if $standing = 0 then put stand

top:
  if_1 then
  {
    gosub go %1

    if $powerwalk == 1 then {
      gosub powerwalk
    }

    shift
    goto top
  }
  goto end

go:
  var dir $0
  var type default

  if matchre("%dir", "^(script|search|swim|climb|web|muck|rt|wait|slow|drag|script|room|ice) ") then
  {
    var type $1
    eval dir replacere("%dir", "^(script |search|swim|web|muck|rt|wait|slow|script|room|ice) ", "")
  }

  if matchre("%dir", "(objsearch) (\S+) (.+)") then
  {
    var type objsearch
    var searchObj $2
    var dir $3
  }

  if matchre("%type", "search") then gosub %type

  if matchre("%type", "script") then
  {
    put .%dir
    waitfor MOVE SUCCESSFUL
    return
  }

go.retry:
  matchre return Obvious (paths|exits)|It's pitch dark
  matchre go.retry \.\.\.wait|Sorry, you may only|Sorry, system is slow|You can't ride your \w+ broom in that direction
  matchre on_steps You begin climbing|You really should concentrate
  matchre retreat You are engaged
  matchre stand while sitting|while kneeling|while lying down|must be standing
  put %dir
  matchwait 3
  goto go.retry

search:
  put %type
  wait
  pause 0.2
  return

objsearch:
  put search %searchObj
  wait
  pause 0.2
  return

move.knock:
  matchre return All right, welcome back|opens the door just enough to let you slip through
  matchre turn.cloak I can't see your face
  matchre stop.invis The gate guard can't see you
  put knock gate
  matchwait

stop.invis:
  put hum scale
  pause 0.5
  goto move.knock

turn.cloak:
  put turn my cloak
  pause 0.5
  goto move.knock

on_steps:
  matchre finished_steps You reach the end
  matchwait 30
  return

finished_steps:
  pause
  return

retreat:
  put retreat
  put retreat
  pause 0.5
  goto go.retry

stand:
  put stand
  pause 0.5
  goto go.retry

powerwalk:
  if $Attunement.LearningRate > 33
  {
    # put #var powerwalk 0
    return
  }
  matchre stop.play too busy performing
  matchre return Roundtime|Something in the area is interfering
  put power
  matchwait 1
  return

stop.play:
  put stop play
  goto powerwalk

end:
  # put #var powerwalk 0
  put #parse YOU HAVE ARRIVED
