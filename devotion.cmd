
Chapel:

  if "$roomid" != "351" then
  {
    gosub automapper chapel
  }

  put kneel
  put kiss altar
  waitfor You

  put devote
  waitfor You lift your voice

  put remove my badge
  put push altar with my badge
  waitfor You press

Ushnish:
  gosub automapper Ushnish
  put push altar with my badge
  waitfor You press

Tamsine:
  gosub automapper Tamsine
  put push image with my badge
  waitfor You press


pray:
  put pray my badge
  waitfor Roundtime
  send wear my badge
  goto done


automapper:
  put #goto $0
  waitforre YOU HAVE ARRIVED
  echo
  echo *** You have arrived at $roomtitle ***
  echo
  pause 0.5
  return

done:
  gosub automapper 11
  put #parse DEVOTION DONE
