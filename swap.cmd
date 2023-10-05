debug 5

var container $primary.container
var hammer $forging.hammer

var belt forger's belt
var has_craft_belt $has_forging_craft_belt

start:
  gosub stow.tools
  gosub get.tool %hammer
  gosub get.tool tongs
  gosub swap.tool bellows
  gosub swap.tool tongs
  gosub stow.tools
  goto end

stow.tools:
  gosub stow.tool
  gosub stow.tool.right
  return

get.tool:
  var tool $0
  pause 0.5
  matchre %last \.\.\.wait|Sorry
  matchre RETURN You get|You remove
  put untie my %tool
  put get my %tool
  matchwait 5
  goto done

swap.tool:
  var tool $0
  if !contains("$lefthand", "%tool") then
  {
    if ("$lefthand" != "Empty") then { gosub stow.tool }
    gosub get.tool %tool
  }
  pause 0.5
  return

stow.tool:
  if "$lefthand" = "Empty" then return

  pause 0.5
  matchre RETURN You attach|You put|Tie what
  matchre stow.tool.2 doesn't seem to fit
  if "%has_craft_belt" = "YES" then {
    put tie my $lefthand to my %belt
  }
  else {
    put put my $lefthand in my %container
  }
  matchwait

stow.tool.2:
  put put my $lefthand in my %container
  return

stow.tool.right:
  if "$righthand" = "Empty" then return

  pause 0.5
  matchre RETURN You attach|You put|Tie what
  matchre stow.tool.right.2 doesn't seem to fit
  if "%has_craft_belt" = "YES" then { put tie my $righthand to my %belt }
  else { put put my $righthand in my %container }
  matchwait

stow.tool.right.2:
  put put my $righthandnoun in my %container
  return

end:
