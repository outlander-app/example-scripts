var lighter viper
var lighterStorage cassock

IF_1 goto %1

Incense:
  put get my incense
  put get my viper
  pause 0.5
  put point my %lighter at my incense
  waitfor You quickly flick the switch on the back
  pause 0.5

Sheath:
  pause 0.5
  put put my %lighter in my %lighterStorage
  matchre WaveIncense you put
  matchre Sheath ...wait
  matchwait 3

WaveIncense:
  put wave my incense at altar

DouseIncense:
  pause 0.5
  put snuff my incense
  pause 0.5
  put stow incense
  goto Kiss


Kiss:
  pause 1
  put kneel
  put kiss altar
  pause 0.5
  put stand
  goto Wine


Wine:
  pause 0.5
  put get my wine
  put pour my wine on altar
  pause 0.5
  put stow wine
  goto Recite


Recite:
  put recite Phelim, give me strength for my righteous vengeance.\;Chadatru, guide my sword to swing in justice.\;Everild, give me the power to conquer my enemies.\;Truffenyi, let me not lose sight of compassion and mercy\;Else, I will become like those I despise.\;Urrem'tier, receive into your fetid grasp these wicked souls\;May Tamsine's realm never know their evil ways again
  pause 1
  goto Dance


Dance:
  pause 0.5
  put dance
  pause 12
  put dance
  pause 12
  put dance
  match Dance conclusion, but
  match Badge conclusion at last,
  matchwait 3

Badge:
  pause 1
  put hold my badge
  put push alt with my badge
  pause 1
  put pray my badge
  pause 3
  send wear my badge
  goto Done


Done:
  pause 1
  send #parse DEVOTION DONE
