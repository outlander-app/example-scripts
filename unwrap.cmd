send unwrap my %0
waitforre Roundtime|That area is not tended

tend:
  pause 0.5
  matchre done You work carefully at tending your wound|That area has already been tended to
  matchre done That area is not bleeding
  send tend my %0
  matchwait 1.5
  goto tend

done: