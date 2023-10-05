debug 5

#put #script pause all except $scriptname
var target %1

if_2 goto healself

var keep
var wounds chest|abdomen|back|neck|head|right arm|right leg|left arm|left leg|right eye|left eye|left hand|right hand
var target_wound

heal:
    pause 0.5
    put touch %target
    put take %target all
    pause 0.5
    put .charge bs 5 35
    waitforre ^BUFF DONE
    goto healself

healself:
  gosub check_wounds
  if len("%target_wound") > 0 then {
    put .heal "%target_wound"
    waitforre ^HEALing DONE
    goto healself
  }

  # put .charge hw 5 20 "left arm int"
  # waitforre ^BUFF DONE

  # put .charge hs 5 20 "left arm"
  # waitforre ^BUFF DONE

  goto done


check_wounds:
    var target_wound
    matchre set_nerve minor twitching|severe twitching|difficulty controlling actions|partial paralysis of the entire body|severe paralysis of the entire body|complete paralysis of the entire body
    matchre set_skin skin|skin rash|body rash|bleeding sores all over the skin
    matchre set_wound %wounds
    put health
    matchwait 3
    return

set_nerve:
  var target_wound nerv
  return

set_skin:
  var target_wound skin
  return

set_wound:
  var target_wound $0
  return

done:
  put #parse HEALBOT DONE
