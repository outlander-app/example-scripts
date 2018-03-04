# braid %item/vines for mech

#debuglevel 5

var armor gloves


var totaltime $time
var item vine
if_1 var item %1

var container1 backpack

var maxexp $Mechanical_Lore.LearningRate
math maxexp add 34
if %maxexp >= 34 then {
  var maxexp 34
}

put remove my %armor
put stow my %armor
waitforre You put|Stow what

getbraided:
  match braid You get
  match braid already holding
  match getmaterial referring
  put get my brai %item
  matchwait 5
  goto errorhandler

getmaterial:
 match braid You get
 match forage referring
 put get my %item from my %container1
 matchWAIT 5
 goto errorhandler

braidP:
 pause
braid:
 match braidP ...wait
 match braidP Sorry,
 matchre pull nothing more than wasted effort|begin to wonder why you even bother|already as long as you can make it
 match exp lead rope
 match exp bundling rope
 matchre exp You begin|You are certain
 match exp for anything yet
 match forage need to have more
 put braid my %item
 matchwait 5
 goto braid

exp:
 if $Mechanical_Lore.LearningRate < %maxexp then {
  goto braid
 }
 goto drop.done

pullP:
 pause
pull:
 match pullP ...wait
 match pullP Sorry,
 match braid Roundtime
 match forage ruined pieces
 matchre braid what you have left|satisfaction for your work so far
 match drop examine your new
 put pull my %item
 matchWAIT 30
 goto errorhandler

drop:
  pause 1
  put empty right hand
  goto getbraided

forage:
 match braid you find
 match braid manage to find
 match novine wondering what you might find
 match novine are sure you knew what you were looking
 match novine unable to find
 match novine what it was you were looking for
 match novine futile
 match novine dragon's egg
 put forage %item
 matchwait 5
 goto forage

novine:
 SETVARIABLE item grass
 goto forage

errorhandler:
 echo "Error"

drop.done:
  pause 0.5
  matchre done You drop
  put drop my $righthand
  matchwait 3
  goto drop

done:
  put get my %armor
  put wear my %armor
  send #parse BRAID DONE
