# debug 5

var container kit

action put #echo >Log Almanac: $1 when You believe you've learned something significant about (.*)!

get:
  put get my almanac

study:
  matchre stow You set about studying|gleaned all the insight you can|Study what
  match get But you aren't holding
  put study my almanac
  matchwait 3
  goto get

stow:
  pause 0.5
  match wait ...wait
  matchre done You put|What were you referring to
  put put my almanac in my %container
  matchwait 2
  goto stow

wait:
  pause 2

done:
