debuglevel 5

var primary.container $primary.container
var last
var checkEXP OFF
var maxExp 34

var belt forger's belt
var has_craft_belt $has_forging_craft_belt

IF_1 gosub %1

goto start

exp:
  var checkEXP ON
  return

start:
  var last start
  goto stir

matches:
  matchre shovel needs more fuel
  matchre bellow consume its fuel
  matchre turn clumps of molten metal accumulating
  matchre doneCheck You can only mix a crucible if it has something inside of it.
  matchre wait wait...
  matchre stir Roundtime
  matchwait

wait:
  goto %last

stir:
  var last stir
  pause 0.5
  gosub swap.tool stirring rod
  put stir crucible with my rod
  goto matches

turn:
  var last turn
  pause 0.5
  put turn crucible
  goto matches

bellow:
  var last bellow
  gosub swap.tool bellows
  put push my bellows
  goto matches

shovel:
  var last shovel
  gosub swap.tool shovel
  put push fuel with my shovel
  goto matches

continue:
  put get my ingot
  put put my ingot in crucible
  pause
  goto stir

swap.tool:
  var tool $0
  if !contains("$righthand", "%tool") then
  {
    if ("$righthand" != "Empty") then { gosub stow.tool }
    pause 0.5
    matchre %last \.\.\.wait|Sorry
    matchre RETURN You get|You remove|You are already holding|You untie
    put untie my %tool from my %belt
    put get my %tool in my %primary.container
    matchwait 5
    goto done
  }
  pause 0.5
  return

stow.tool:
  if "$righthand" = "Empty" then return

  pause 0.5
  matchre RETURN You attach|You put
  matchre stow.tool.2 doesn't seem to fit
  if "%has_craft_belt" = "YES" then { put tie my $righthand to my %belt }
  else { put put my $righthand in my %primary.container }
  matchwait

stow.tool.2:
  put put my $righthand in my %container
  return

RETURN:
  pause 0.5
  return

doneCheck:
  if ("%checkEXP" = "ON" && $Forging.LearningRate < %maxExp) then goto continue
  goto done

done:
  gosub stow.tool stirring rod
  put #parse SMELT DONE
