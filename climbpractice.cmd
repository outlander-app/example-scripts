debuglevel 5

var maxexp $Athletics.LearningRate
math maxexp add 12
if %maxexp >= 34 then
	var maxexp 34
var play YES
var target %1

goto START

maxexp:
	var maxexp 34
	return

noplay:
	var play NO
	return


START:
	if_2 then
	{
		gosub %2
		shift
		goto START
	}

Top:
	if "%play" = "YES" then put play $play.song $play.style
	put climb practice %target
	waitfor You finish practicing
	goto EXPCheck

EXPCheck:
	if $Athletics.LearningRate >= %maxexp then goto DONE
	goto Top

DONE:
	pause 1
	send stop play
	send hide
	send #parse CLIMB DONE
