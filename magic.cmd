#[Magic]: Casting spells
# debug 5

## customizable variables

var cambItem $camb_item
var spellPrep With tense movements you|You begin chanting|With rigid movements|You raise your palms skyward|motes of sanguine light swirl briefly about your fingertips
var spellCast gesture|place your hands|You whisper|backfires


##########################################
## main script
##########################################

ECHO *******************************
ECHO **
ECHO ** Train magic with cambrinth.  Set the global variable "camb_item"
ECHO **
ECHO ** #var camb_item ring
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
var manaCheck 20
var manaWaitLevel 60
var fully_prepared NO

action var fully_prepared YES when You feel fully prepared

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
    match Charge2 Roundtime
    match HoldArmband Try though you may
    matchre Wait \.\.\.|may only type ahead
    match WaitCharge1 You strain, but lack the mental stamina
    put charge my %cambItem %3
    matchwait

WaitCharge1:
    waiteval $mana > 20
    goto Charge

HoldArmband:
    put remove %cambItem
    goto Charge

Charge2:
    pause 0.5
    match WaitCharge2 You strain, but lack the mental stamina
    match Focus Roundtime
    matchre Wait2 \.\.\.|may only type ahead
    put charge my %cambItem %3
    matchwait

WaitCharge2:
    waiteval $mana >= 20
    goto Charge2

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
    match StopPlay stop playing
    put prep %1 %2
    matchwait 3
    goto Prep

StopPlay:
    put stop play
    goto Prep

Focus:
    match Concentrate Roundtime
    match Wait3 ...
    put invoke my %cambItem spell
    matchwait

Wait3:
    pause 1
    goto Focus

Concentrate:
    match Cast Roundtime
    match Cast ...
    send power
    matchwait 2
    goto Cast

Cast:
    if "%fully_prepared" = "YES" then goto Cast.Do

    if ("%snapCast" = "OFF") then
    {
        waitfor fully prepared
    }
    else
    {
        pause 3
    }
    Cast.Do:
        matchre ManaCheck You strain
        matchre ExpCheck %spellCast
        match ExpCheck have a spell prepared
        put cast
        matchwait 2
        goto Cast.Do

ExpCheck:
    var fully_prepared NO
    pause 1
    if ($%magicToTrain.LearningRate >= %maxexp) then goto END
    goto ManaCheck

ManaCheck:
    var fully_prepared NO
    if ($mana < %manaCheck) then {
        echo
        echo Waiting on mana - $mana/%manaWaitLevel %
        echo
        waiteval $mana >= %manaWaitLevel
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
    put wear my %cambItem
    put #parse MAGIC DONE
    # send hide
