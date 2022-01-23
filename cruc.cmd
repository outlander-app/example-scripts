
var item %0
var stow.container $primary.container

start:
  put get my %item in my %stow.container
  matchre start You put
  matchre done What were you|You decide that smelting such a volume of metal at once would be dangerous
  put put my %item in crucible
  matchwait 2
  goto start

done: