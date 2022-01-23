
# debug 5

start.loop:
  if_1 then {
    var item %1
    gosub get
    shift
    goto start.loop
  }

goto done

get:
  pause 0.2
  matchre sell You get|You are already holding that
  matchre return What were you referring to
  put get my %item
  matchwait 3
  goto get

sell:
  matchre get hands you
  put sell my %item
  matchwait 3
  goto get

done:
  put #parse SELL DONE
