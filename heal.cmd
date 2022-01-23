debug 5

start:
  if_1 then {
    var part %1

    gosub healWounds %part
    gosub healScars %part

    shift
    goto start
  }

  goto end



healWounds:
  gosub charge hw 5 20 "$0"
  return

healScars:
  gosub charge hs 5 20 "$0"
  return


charge:
    if ($mana <= 30) then waiteval $mana >= 60
    send .charge $0
    waitforre ^BUFF DONE
    pause 0.5
    return

end:
  put #parse HEALING DONE
