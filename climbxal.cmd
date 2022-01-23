
start:
  gosub automapper 506
  gosub automapper 411
  goto done


automapper:
  put #goto $0
  waitforre ^YOU HAVE ARRIVED
  echo
  echo *** You have arrived at $roomtitle ***
  echo
  return

done:
  put #parse CLIMB DONE
