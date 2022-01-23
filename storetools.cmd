
gosub store bone saw
gosub store rasp
gosub store chisels
gosub store rifflers
gosub store pliers
goto done


store:
  var item $0
  put get my %item
  waitforre You get|You are already|What were you
  put put my %item on counter
  pause 0.5
  return

done:
  exit