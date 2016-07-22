
debuglevel 5
gosub GENERAL_TRIGGERS

var GAG_ECHO NO


Start:
	put avoid !all
	pause 1
	put avoid whisp
	put avoid teach
	pause 1
	put avoid touch
	pause 1

CheckEXP:
	match DONE No skills have field experience
	matchre DONE You are a ghost!
	matchre DONE You are dead
	match CHECK.INFECTION EXP HELP
	put exp
	matchwait 30
	goto DONE

WAIT60:
pause 290
goto CheckEXP

GENERAL_TRIGGERS:
	action (hunt) goto STUNNED when eval $stunned = 1
	action (hunt) goto BLEEDING when eval $bleeding = 1
	#action (hunt) goto DEAD when eval $health < 70
	action (hunt) goto DEAD when eval $dead = 1
	return


BLEEDING:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** BLEEDING: ***
		echo You are bleeding.
		echo Checking health.
		echo
	}
	#action remove eval $bleeding = 1
CHECK.INFECTION:
	action var INFECTED YES when ^You.+(infect|disease|oozing sores)
	var GOING_TO %c
	var INFECTED NO
	put health
	goto HEALTH_CHECK

STUNNED:
	if ("%GAG_ECHO" != "YES") then
	{
		echo
		echo *** STUNNED: ***
		echo You have been stunned.
		echo Checking health.
		echo
	}
	#action remove eval $stunned = 1
	var GOING_TO %c
HEALTH_CHECK:
	gosub clear

CHECKING_HEALTH:
	if ("%INFECTED" = "YES") then goto INFECTED
	if ($stamina >= 50) then
	{
		echo
		echo Not too beat up
		echo
		#action goto BLEEDING when eval $bleeding = 1
		#action goto STUNNED when eval $stunned = 1
		#action remove ^You.+(infect|disease)

		goto WAIT60
	} else
	{
		echo
		echo Too beat up, aborting
		echo
		goto DEAD
	}

INFECTED:
	echo
	echo Your wounds are infected, seek medical attention!!!
	echo
	put #beep
	goto DEAD


DEAD:
DONE:
	put invoke bond
	pause 5
	#put exit
