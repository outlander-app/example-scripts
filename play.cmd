
play:
	put play $play.song $play.style
	matchre end ^You decide that now isn't the best time to be playing
  matchre finished You begin|already playing a song|You fumble
  matchwait 3
  goto play

finished:
	waitfor You finish playing
	goto play

end:
