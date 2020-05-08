
debuglevel 5

var item %0

get:
  pause 0.2
  matchre sell You get|You are already holding that
  matchre done What were you referring to
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
