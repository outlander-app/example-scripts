debug 5

var pouch $Gem_Pouch
var pouch.container $primary.container
var gem.container $loot.container

if_1 var gem.container %1

put get my %pouch in my %pouch.container

fill: 
  matchre tie too valuable to leave untied
  matchre app Encumbrance
  put fill my %pouch with my %gem.container
  put enc
  matchwait 3
  goto app

tie:
  pause
  put tie my %pouch
  goto fill

app:
  put app my %pouch quick
  pause 3

done:
  put put my %pouch in my %pouch.container