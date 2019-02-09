# climb with a magic rope

# debug 5

var container kit

var maxexp $Athletics.LearningRate
math maxexp add 12
if %maxexp >= 34 then {
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
		shift
		goto START
	}


top:
  put stow right
  put stow left
  pause 1
  matchre climb You get
  matchre nope What were you referring to
  put get my climbing rope
  matchwait

climb:
  put play $play.song $play.style
  put climb practice my rope
  waitfor You finish practicing your climbing skill
  goto checkEXP

checkEXP:
  pause 0.2
  if $Athletics.LearningRate >= %maxexp then goto end
  goto climb

nope:
  echo
  echo *** cannot find rope "(╯°□°)╯︵ ┻━┻" ***
  echo
  goto end

end:
  put put my rope in my %container
	put #parse CLIMB DONE
