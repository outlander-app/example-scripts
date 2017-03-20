#
# automapper.cmd - version 0.3
# Requires Outlander 0.9.0 or higher
#

# debug 5

if $standing = 0 then put stand

top:
  if_1 then {
    gosub go %1

    if $powerwalk == 1 {
      gosub powerwalk
    }

    shift
    goto top
  }
  goto end

go:
  var dir $0
  var type default
  if matchre("%dir", "^(search|swim|climb|web|muck|rt|wait|slow|drag|script|room|ice) ") then
  {
    var type $1
    eval dir replacere("%dir", "^(search|swim|web|muck|rt|wait|slow|script|room|ice) ", "")
  }

  if %type = search {
    gosub %type
  }

  go.retry:
    matchre return ^Obvious (paths|exits)|^It's pitch dark
    matchre go.retry ^\.\.\.wait|^Sorry, you may only|^Sorry, system is slow|^You can't ride your \w+ broom in that direction
    matchre retreat ^You are engaged
    matchre stand while sitting|while kneeling|while lying down
    put %dir
    matchwait 3
    goto go.retry

search:
  put search
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

  if $Attunement.LearningRate >= 34 {
    # put #var powerwalk 0
    return
  }

	pause 0.2
  matchre stop.play too busy performing
	matchre return ^Roundtime|^Something in the area is interfering
	send power
  matchwait 3
  return

stop.play:
  put stop play
  goto powerwalk

end:
  # put #var powerwalk 0
  put #parse YOU HAVE ARRIVED
