var item %1
var mode drop

forage:
  match done The room is too cluttered to find anything here
  match modeCheck You really need to have at least one hand
  match forage Roundtime
  pause 0.5
  put forage %item
  matchwait

modeCheck:
  gosub %mode
  goto forage

drop:
  put drop my %item
  put drop my %item
  waitforre You drop|What were you
  return

done:
  gosub %mode
  put #parse FORAGE DONE
