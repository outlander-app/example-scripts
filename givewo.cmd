
var type %1
var person %2
var item %3
var alias %4
var container $deed.container
var primary.container $primary.container

if ("%type" = "weapon" || "%type" = "armor") then var type forging

put get my %type logbook

ask:
  put %alias %person
  waitforre ^HAVE WORKORDER
  put .bundlewo %item
  waitforre ^BUNDLE DONE

give:
  match incomplete The work order isn't yet complete
  match ask logbook and bundled items, and are given
  put give my logbook to %person
  matchwait 3
  goto done

untie:
  matchre stow You untie
  matchre done You have nothing bundled with the logbook
  put untie my log
  matchwait 3
  goto untie

stow:
  pause 0.5
  put put my $lefthand in my %container
  goto untie

incomplete:
  echo
  echo *** Incomplete
  echo
  goto untie

done:
  put put my logbook in my %primary.container
  put #parse WORKORDER DONE
