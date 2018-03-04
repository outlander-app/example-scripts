#[Magic]: Casting spells
debug 5

## customizable variables

var cambItem $camb_item
var spellPrep With tense movements you|You begin chanting|With rigid movements


##########################################
## main script
##########################################

ECHO *******************************
ECHO **
ECHO **
ECHO ** When starting the script, type .magic <spell> <spell prep amount> <charge cambrinth amount> <skill>
ECHO **
ECHO ** ex: .magic ease 2 3 Augmentation
ECHO **
ECHO ** Optional arguments: .magic ease 2 3 Agumentation maxexp
ECHO ** "maxexp" will run until the skill is locked
ECHO **
ECHO ** Change var cambItem for your cambrinth
ECHO ** Change var spellPrep for your spell preparation
ECHO **
ECHO *******************************

var magicToTrain %4
var snapCast OFF

if_5 then
{
  goto begin
}

if_4 then
{
  goto begin
}

goto syntax

begin:
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
	IF_5 then
	{
		gosub %5
	}
	goto Prep


Charge:
	put charge my %cambItem %3
	match Charge2 Roundtime
	match HoldArmband Try though you may
	match Wait ...
	matchwait


HoldArmband:
	put remove %cambItem
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
  matchre Cast.Do You have already fully prepared
  matchre Charge %spellPrep
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

syntax:
	echo
	echo
	echo *************************************
	echo *** Not enough arguments provided ***
	echo *************************************
	echo
	echo
	goto end

End:
	pause
	put #parse MAGIC DONE
