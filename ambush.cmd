#[Combat]:  Ambushing at melee

debuglevel 5

var attack.method backstab

action var guild $1;put #var guild $1 when Guild:\s+(Barbarian|Bard|Cleric|Commoner|Empath|Moon Mage|Necromancer|Paladin|Ranger|Thief|Trader|Warrior Mage)$
action var circle $1;put #var circle $1 when Circle:\s+(\d+)$
put info
waitforre ^Debt:$
put awaken

Check:
if (("%guild" = "Thief" || "%guild" = "Ranger") && (%circle >= 50)) then goto Stalk
else goto Hide

Hide:
  match Hide ...
  match Hide Your attempt to hide fails.
  match Hide notices your
  match Stalk You blend in with your surroundings,
  match Stalk You melt into the background,
  match Stalk Eh?  But you're already hidden!
  put hide
  matchwait

Stalk:
  match Stalk ...
  match ADV It would help if you were closer
  matchre Jab You must be hidden first|already stalking
  match Ambush You move into position to stalk
  match Ambush You are already
  match Hide try being out of sight
  match Stalk Roundtime
  put stalk
  matchwait

Ambush:
  match Ambush ...
  match ADV It would help if you were closer
  match ADV close enough
  match Check It's awfully hard to ambush
  matchre DebilCheck You leap|You slip|Roundtime
  match Stalk You must be hidden
  matchre SetAmbush You can't backstab that|political backbiting|You'll need something a little lighter|Ambush what?
  put %attack.method
  matchwait

SetAmbush:
  var attack.method attack
  goto Ambush

Parry:
  match Parry ...
  match Hide You are
  match Hide You move
  put parry
  matchwait

Jab:
  match Jab ...
  match Check you
  match END There is nothing else
  put attack
  matchwait


ADV:
  match Ambush You close to melee
  match Check stops you from advancing any farther!
  put advance
  matchwait


DebilCheck:
  if ("%guild" = "Thief" && $Debilitation.LearningRate >= 34 && $Backstab.LearningRate >= 34) then goto END
  goto Check


END:
  echo
  echo *** Debilitation Locked! ***
  echo
  put #parse AMBUSH DONE
