debuglevel 5

var maxexp $Scouting.LearningRate
math maxexp add 10
if %maxexp >= 34 then
{
	var maxexp 34
}

goto START

maxexp:
	var maxexp 34
	return

START:
	if_1 then
	{
		gosub %1
	}


Where:
	match Gondola [Dragon's Spine, Mountain Foothills]
	match Corik [Blackthorn Canyon, Entrance]
	match Gondola4l [The Edge of the Forest, Before the Dragon's Breath]
	put look
	matchwait


Gondola:
	gosub HIDE
	pause 1
	match Gondola2 Roundtime
	match Gondola ...wait
	put scout trail
	matchwait

Gondola2:
	pause 1
	match Gondola2 ...wait
	match CheckEXP You set off
	match Gondola What
	put sneak trail
	matchwait

CheckEXP:
	if ($Scouting.LearningRate >= %maxexp) then { goto Locked }
	goto Gondola3

Gondola3:
	waitfor [Blackthorn Canyon, Entrance]
	pause 1
	#put tend my right leg

	gosub AUTOMOVE 109
	if ($Athletics.LearningRate < 30) then { gosub ClimbWall }
	goto Corik

Corik:
	gosub HIDE
	pause 1
	match Corik ...wait
	match Corik2 Roundtime
	put scout trail
	matchwait

Corik2:
	pause 1
	match Corik2 ...wait
	match Corik What
	match Gondola4 You set off
	put sneak trail
	matchwait


Gondola4:
	waitfor [The Edge of the Forest, Before the Dragon's Breath]
	pause 1
	Gondola4l:
	gosub AUTOMOVE 157
	goto Gondola

Locked:
	waitfor [Blackthorn Canyon, Entrance]
	pause 1
	#put tend my right leg

	gosub AUTOMOVE 109
	if ($Athletics.LearningRate < 30) then { gosub ClimbWall }
	goto END

ClimbWall:
	pause 1
	move s
	move s
	move e
	move cl wall
	move southeast
	move cl wall
	move cl wall
	move w
	move cl wall
	move cl wall
	move w
	move cl wall
	move cl wall
	move w
	move cl wall
	move cl wall
	move w
	move cl wall
	move cl wall
	move ne
	move cl wall
	move cl wall
	move e
	move cl wall
	move cl wall
	move e
	move cl wall
	move w
	move n
	move sneak n
	return

##########################
# MOVEMENT ENGINE
##########################
##### AUTOMOVE SUBROUTINE #####
AUTOMOVE:
     var Destination $0
     if !$standing then { gosub STAND }
     if $roomid = %Destination then { return }
AUTOMOVE_GO:
     matchre AUTOMOVE_FAILED ^AUTOMAPPER MOVEMENT FAILED|^MOVE FAILED
     matchre AUTOMOVE_RETURN ^YOU HAVE ARRIVED
     matchre AUTOMOVE_RETURN ^SHOP CLOSED\!
     send #goto %Destination
     matchwait
AUTOMOVE_STAND:
     send STAND
     pause 0.5
     if $standing = 0 then return
     goto AUTOMOVE_STAND
AUTOMOVE_FAILED:
     pause 0.5
     goto AUTOMOVE_GO
AUTOMOVE_RETURN:
     return

############################################
# MISC
############################################
PAUSE:
     if $roundtime > 0 then  { pause $roundtime }
     pause 0.1
     pause 0.5
     return
STAND:
pause 0.2
     matchre STAND ^(?:\(|\[|\s*)Roundtime\s*\:
     matchre STAND ^\.\.\.wait\s+\d+\s+sec(?:onds?|s)?\.?|^Sorry\,
     matchre STAND ^You are so unbalanced you cannot manage to stand\.
     matchre STAND ^The weight of all your possessions prevents you from standing\.
     matchre STAND ^You are overburdened and cannot manage to stand\.
     matchre STAND ^You are still stunned
     matchre STAND ^You try
     matchre RETURN ^You are already standing\.
     matchre RETURN ^You stand back up\.
     matchre RETURN ^You stand up\.
     matchre RETURN ^There doesn't seem to be anything to stand on here
     matchre RETURN ^You swim back up
     matchre RETURN ^You are already standing\.
     matchre RETURN ^You're unconscious
     send STAND
     matchwait
RETURN:
     pause 0.1
     return
HIDE:
     pause 0.1
     matchre HIDE ^\.\.\.wait\s+\d+\s+sec(?:onds|s)?\.?|^Sorry\,|fail|You are too close|^You are a bit|^You are too busy
     matchre HIDE notices your attempt|reveals you|ruining your hiding place|discovers you
     matchre RETURN ^You melt|^You blend|^Eh\?|^You slip|^Roundtime|You look around
     send hide
     matchwait
SNEAK:
     var direction $0
     if ("%guild" = "Thief" && %circle < 50) then { goto SNEAK.HIDE }
SNEAKING:
     matchre SNEAK.PAUSE ^\.\.\.wait\s+\d+\s+sec(?:onds|s)?\.?|^Sorry\,
     matchre RETURN Roundtime|You sneak|You duck|You quickly slip
     send sneak %direction
     matchwait
SNEAK.PAUSE:
     pause
     goto SNEAKING
SNEAK.HIDE:
     pause 0.2
     matchre SNEAK.HIDE notices your attempt|reveals you|ruining your hiding place|discovers you
     matchre SNEAKING ^You melt|^You blend|^Eh\?|^You slip|^Roundtime|You look around
     send hide
     matchwait
UNHIDE:
     pause 0.1
     matchre UNHIDE ^\.\.\.wait\s+\d+\s+sec(?:onds|s)?\.?|^Sorry\,
     matchre RETURN ^But you are not hidden\!
     matchre RETURN ^You come out of hiding\.
     send UNHIDE
     matchwait 2
     return


END:
	send #parse SCOUTING DONE
  exit
