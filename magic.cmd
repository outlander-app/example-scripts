#[Magic]: Casting spells
debuglevel 5

var snapCast OFF
var cambItem $camb_item
var magicToTrain $Magic.Training

var maxexp $%magicToTrain.LearningRate
math maxexp add 15
if %maxexp >= 34 then
{
	var maxexp 34
}

goto Start

snap:
	var snapCast ON
	return

maxexp:
	var maxexp 34
	return

Start:
	IF_4 then
	{
		gosub %4
	}
	goto Prep


Charge:
	put charge my %cambItem %3
	match Charge2 Roundtime
	match HoldArmband Try though you may
	match Wait ...
	matchwait


HoldArmband:
	put hold %cambItem
	goto Charge

Charge2:
	put charge my %cambItem %3
	match Focus Roundtime
	match Wait2 ...
	matchwait

Wait:
	pause 1
	goto Charge

Wait2:
	pause 1
	goto Charge2

Prep:
	pause 0.5
  matchre Cast.Do You have already fully prepared the Blend spell!
  matchre Charge With tense movements you|You begin chanting a prayer
	put prep %1 %2
	matchwait 3
	goto Prep

Focus:
	put invoke my %cambItem spell
	match Concentrate Roundtime
	match Wait3 ...
	matchwait

Wait3:
	pause 1
	goto Focus

Concentrate:
	put power
	goto Cast

Cast:
	if ("%snapCast" = "OFF") then
	{
		waitfor fully prepared
	}
	else
	{
		pause 7
	}
	Cast.Do:
		matchre ManaCheck You strain
		matchre ExpCheck snap
		put cast
		matchwait 4
		goto Cast.Do

ExpCheck:
	pause 1
	if ($%magicToTrain.LearningRate >= %maxexp) then goto END
	goto ManaCheck

ManaCheck:
	if ($mana < 20) then {
		echo
		echo Waiting on mana - $mana/40 %
		echo
		waiteval $mana >= 40
	}
	goto Prep

End:
	pause
	put #parse MAGIC DONE