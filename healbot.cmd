debug 5

#put #script pause all except $scriptname
var target %1

var keep left arm
var wounds chest|abdomen|back|head|right arm|right leg|left leg|right eye|left eye|left hand|right hand
var target_wound

heal:
    pause 0.5
    put touch %target
    put take %target all
    pause 0.5
    put .charge bs 5 20
    waitforre ^BUFF DONE
    goto healself

healself:
  gosub check_wounds
  if len("%target_wound") > 0 then {
    put .heal "%target_wound"
    waitforre ^HEALing DONE
    goto healself
  }

  put .charge hw 5 20 "left arm int"
  waitforre ^BUFF DONE

  put .charge hs 5 20 "left arm"
  waitforre ^BUFF DONE

  goto done

check_wounds:
    var target_wound
    matchre set_wound %wounds
    put health
    matchwait 3
    return

set_wound:
  var target_wound $0
  return

done:
  put #parse HEALBOT DONE
