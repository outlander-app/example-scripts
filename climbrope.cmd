# climb with a magic rope

# debug 5

var container kit

var maxexp $Athletics.LearningRate
math maxexp add 12
if %maxexp >= 34 then {
	var maxexp 34
}
var play YES
var target %1

goto START

maxexp:
	var maxexp 34
	return

START:
	if_1 then
	{
		gosub %1
		shift
		goto START
	}


top:
  put stow right
  put stow left
  pause 1
  put get my climbing rope
  waitfor You get

climb:
  put play concerto
  put climb practice my rope
  waitfor You finish practicing your climbing skill
  goto checkEXP

checkEXP:
  pause 0.2
  if $Athletics.LearningRate >= %maxexp then goto end
  goto climb

end:
  put put my rope in my %container
