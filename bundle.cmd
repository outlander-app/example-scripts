var item claw

var money 0
action math money add $1;var denomination $2 when hands you (\d+) (Kronars|Dokoras|Lirums)

travel:
  # Shard
  if $zoneid == 67 then {
      gosub go e battle
      move north
      move climb embrasure
      pause 0.5
  }

  # Shard West Gate
  if $zoneid == 69 then {
      gosub go north gate
  }

  goto sell

sell:
    gosub go bundle

    put remove my bundle
    put get my %item in my bundle
    pause 0.5
    put sell my bundle
    pause 1
    put bundle
    put wear my bundle
    pause 1
    goto done


go:
  var target $0
go.retry:
  matchre go.retry You can't go there|What were you referring to
  matchre return ^YOU HAVE ARRIVED|^AUTOMAPPER ALREADY HERE
  put #goto %target
  matchwait


done:
  put #echo >log Sold bundle: %money %denomination

  if $zoneid == 66 then {
    gosub go e bridge
    move climb wall
  }

  put #parse BUNDLE DONE