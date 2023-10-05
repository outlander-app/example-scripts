#debuglevel 5

var count %1
var item %2
var stow.container $primary.container

var current_count 0

order:
  pause 0.5
  put order %2
  math current_count add 1
  match combine takes some coins
  match done have enough coins to purchase
  put order %2
  matchwait 5
  goto done

combine:
  if ("$righthand" != "Empty" && "$lefthand" != "Empty") then
  {
    send combine
    matchre cont You combine
    matchre stowleft You must be holding
    matchwait 3
    goto stowleft
  }

cont:
  if (%current_count < %count) then goto order
  goto done

stowleft:
 put stow left
 goto cont

done:
  if "$lefthand" != "Empty" then put put my $lefthandnoun in my %stow.container
  if "$righthand" != "Empty" then put put my $righthandnoun in my %stow.container
  put #parse ORDER DONE
