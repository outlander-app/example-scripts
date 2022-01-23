
var item %1

start:
  put get my %item
  waitforre You carefully|You are already|You get
  put shape part into arrowhead
  pause 2
  put stow my arrowheads
  goto start
