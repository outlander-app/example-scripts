unwrap:
  pause 0.5
  matchre unwrap Roundtime
  matchre tend That area is not tended
  send unwrap my %0
  matchwait 1.5
  goto unwrap

tend:
  pause 0.5
  matchre tend You work
  matchre done That area is not bleeding|That area has already been tended to
  send tend my %0
  matchwait 1.5
  goto tend

done: