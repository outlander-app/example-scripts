debuglevel 5

var repair.container kit
var tool.container $primary.container
var item %0

GET:
  matchre GET.SHEATH You (draw|deftly remove|slip)
  matchre GET.STOW You can only wield a weapon or a shield|need to remove it first|too heavy for you
  matchre GET.TIE You'll have to untie
  put wield my %item
  matchwait 10
  goto END

GET.TIE:
  var inv.action STOW
  put untie my %item
  goto REPAIR.MAIN

GET.SHEATH:
  var inv.action SHEATH
  goto REPAIR.MAIN

GET.STOW:
  var inv.action STOW
  matchre GET.TIE the ties prevent you|You'll have to untie|You should untie
  matchre GET.WEAR But that is already in your inventory|need to remove it first
  matchre REPAIR.MAIN You get|You are already holding that
  put get my %item
  matchwait

GET.WEAR:
  var inv.action WEAR
  put remove my %item
  goto REPAIR.MAIN

SHEATH.ITEM:
  pause 1
  put sheath my %item
  return

STOW.ITEM:
  pause 1
  put put my %item in my %tool.container
  return

WEAR.ITEM:
  pause 1
  put wear my %item
  return

REPAIR.MAIN:
  gosub REPAIR
  gosub STOW.TOOLS
  gosub %inv.action.ITEM
  goto END

SCRAPE:
  pause 0.5
  put clean my %item with my %tool
  goto Matches

POUR.OIL:
  pause 0.5
  put pour my oil on my %item
  goto Matches

REPAIR:
  goto GET.Brush

RETURN:
  return

Wait:
  pause
  put $lastcommand
  goto Matches

Matches:
  match Wait ...wait
  matchre RETURN You realize that cannot be repaired|You realize that cannot be repaired|not damaged enough to warrant repair
  matchre GET.OIL ready to be oiled
  matchre GET.Brush Roundtime|You must be holding the brush to do that|You must be holding the wire brush to do that
  matchwait

GET.Brush:
  pause 0.5
  gosub swap.tool brush
  goto SCRAPE

GET.OIL:
  pause 0.5
  gosub swap.tool oil
  goto POUR.OIL

STOW.TOOLS:
  pause 1
  put put my %tool in my %repair.container
  return

swap.tool:
  var tool $0
  if !contains("$lefthand", "%tool") then
  {
    if ("$lefthand" != "Empty") then { put put my $lefthandnoun in my %repair.container }
    put get my %tool in my %repair.container
  }
  return

END:
  put #parse REPAIR DONE
