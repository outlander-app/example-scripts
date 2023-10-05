debug 5

if_1 gosub %1
else gosub combat
goto end

simple:
  gosub BUFF wotp 20 40
  gosub BUFF oath 20 40
  gosub BUFF instinct 20 45
  gosub BUFF stw 20 40
  return


combat:
  gosub BUFF wotp 20 40
  gosub BUFF sott 20 40
  gosub BUFF hol 20 40
  gosub BUFF sks 20 40
  gosub BUFF em 20 40
  gosub BUFF oath 20 40
  gosub BUFF instinct 20 45
  gosub BUFF stw 20 40
  return


arena:
  gosub BUFF sott 20 40
  gosub BUFF hol 20 40
  gosub BUFF sks 20 40
  gosub BUFF em 20 40
  gosub BUFF instinct 20 45
  gosub BUFF stw 20 40
  return


BUFF:
    if ($mana <= 30) then waiteval $mana >= 60
    send .charge $0
    waitforre ^BUFF DONE
    pause 0.5
    return

end:
  put #parse BUFFING DONE