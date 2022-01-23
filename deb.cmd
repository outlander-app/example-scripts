debuglevel 5

var snapCast OFF
var cambItem $camb_item
var magicToTrain Debilitation
var manaThreshold 12

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
    send .tmhelper
    IF_3 then
    {
        gosub %3
    }

Prep:
    pause 0.5
    matchre Wait wait|You are still stunned
    matchre Cast With tense movements|You begin chanting|You raise your palms skyward
    matchre CastA already fully prepared
    put prep %1 %2
    matchwait

Cast:
    waitforre fully prepared
    CastA:
    put cast
    pause 0.5
    goto ExpCheck

Wait:
    goto Prep

ManaCheck:
    if ($mana <= %manaThreshold) then {
        put #parse WAITING MANA
        echo
        echo Waiting on mana - $mana/30 %
        echo
        waiteval $mana >= 30
        put #parse WAITING MANA-DONE
    }
    goto Prep

ExpCheck:
    pause 0.5
    if ($%magicToTrain.LearningRate >= %maxexp) then goto END
    send face next
    goto ManaCheck

End:
    pause
    put #script abort tmhelper
    put #parse MAGIC DONE
