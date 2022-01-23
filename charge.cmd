var cambItem $camb_item

put prep %1 %2

Charge:
  var LAST Charge
  put charge my %cambItem %3
  match HoldArmband Try though you may
  match Charge2 Roundtime
  match Wait ...
  match WaitMana You strain, but lack the mental stamina
  matchwait

HoldArmband:
  put remove my %cambItem
  goto Charge

Charge2:
  pause 0.5
  var LAST Charge2
  put charge my %cambItem %3
  match Prep Roundtime
  match Wait2 ...
  match WaitMana You strain, but lack the mental stamina
  matchwait

WaitMana:
  put release spell
  waiteval $mana >= 25
  put prep %1 %2
  goto %LAST

Wait:
  pause 1
  goto Charge

Wait2:
  pause 1
  goto Charge2

Prep:
  pause 2
  goto Focus

Focus:
  matchre Concentrate Roundtime|You reach for
  put invoke my %cambItem spell
  matchwait 3
  goto Focus

Concentrate:
  send power
  goto Cast

Cast:
  waitfor fully prepared
  pause 1
  put wear my %cambItem
  put cast %4
  waitforre You|Your spell
  goto End

End:
  pause 1
  send #parse BUFF DONE
  exit
