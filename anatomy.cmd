debuglevel 5

var primary.container $primary.container
var compendium $compendium
var anatomy.start $anatomy.start
var anatomy.stop $anatomy.stop
var skill Empathy

put get my %compendium
put turn my %compendium to %anatomy.start
gosub Crystal

STUDY:
  pause 1
  put play $play.song $play.style
  put study my %compendium
  matchre TURN In a sudden moment of clarity|With a sudden moment of clarity|difficult time comprehending the advanced text
  matchre CheckEXP You begin to study|You continue studying
  match CheckEXP You begin studying
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
  gosub Crystal
  if ($%skill.LearningRate >= 34) then goto END
  goto STUDY

Crystal:
  if $concentration >= 100 then send gaze crystal
  return

END:
  pause 1
  gosub Crystal
  put put my %compendium in my %primary.container
  put #echo >Log #ffff00 Anatomy study completed.
  pause 0.5
  put stop play
  put #parse ANATOMY DONE
