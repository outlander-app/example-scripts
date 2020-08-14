var container kit

put get my almanac

action put #echo >Log Almanac: $1 when You believe you've learned something significant about (.*)!

study:
  matchre stow You set about studying|gleaned all the insight you can
  put study my almanac
  matchwait 3
  goto study

stow:
  pause 0.5
  match done You put
  put put my almanac in my %container
  matchwait 2
  goto stow

done:
