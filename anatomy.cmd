debuglevel 5

var primary.container $primary.container
var compendium tome

put get my %compendium
put turn my %compendium to Elothean

STUDY:
  pause 1
  put play $play.song $play.style
  put study my %compendium
  matchre TURN In a sudden moment of clarity|With a sudden moment of clarity|difficult time comprehending the advanced text
  match CheckEXP You begin to study
  match CheckEXP You begin studying
  match CheckEXP You continue
  match END Why do you need to study
  matchwait 3
  goto STUDY

TURN:
  pause 1
  matchre TURN Something
  # matchre CheckEXP Dwarven|Elothean|Elven|Gnome|Gor'Tog|Halfling|Human|Kaldar|Prydaen|Rakash|S'Kra Mur|Rock Troll|Snow Goblin|Peccary|River Caiman|Gidii|Lach|Warklin
  matchre CheckEXP You turn
  put turn my %compendium
  matchwait 5
  goto TURN

CheckEXP:
  pause 1
  if ($First_Aid.LearningRate >= 34) then goto END
  goto STUDY

END:
  pause 1
  put put my %compendium in my %primary.container
  put #echo >Log #ffff00 Anatomy study completed.
  pause 0.5
  put stop play
  put #parse ANATOMY DONE
