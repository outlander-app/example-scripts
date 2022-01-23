
var money 0
action math money add $1;var denomination $2 when hands you (\d+) (Kronars|Dokoras|Lirums)

gosub go gem
gosub sell
goto done

go:
  var target $0
  matchre go You can't go there|What were you referring to
  matchre return ^YOU HAVE ARRIVED|^AUTOMAPPER ALREADY HERE
  put #goto %target
  matchwait

sell:
  put .sell nugget "pew bar" "bronze bar" "brass bar" "steel bar"
  waitforre ^SELL DONE
  return

done:
  pause 0.5
  put #echo >log Sold loot: %money %denomination
  put #parse SELLLOOT DONE