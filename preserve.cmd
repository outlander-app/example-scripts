# debug 5

var action %1

if $Thanatology.LearningRate >= 30 then goto done

check_preserve:
  if $Obfuscation != 1 then goto print_need_obfuscation
  goto set_creature

set_creature:

    var disectmobs $roomobjs
    action var mobname $1 when ^@.*\s(\S+) (?:which|that) appears dead

    var mobstotal

    var ordinal first|second|third|fourth|fifth|sixth
    eval disectmobs replacere("%disectmobs", "You also see ", "")
    eval disectmobs replacere("%disectmobs", " and some junk", "")
    eval disectmobs replacere("%disectmobs", " and ", ", ")
    eval disectmobs replacere("%disectmobs", "\.", "")
    eval disectmobs replacere("%disectmobs", ", ", "|")
    eval mobstotal countsplit("%disectmobs", "|")
    var mobcurrent 0

    count:
        pause 0.5
        if (%mobcurrent >= %mobstotal) then { goto done }

        var check %disectmobs[%mobcurrent]

        if (matchre("%check", "dead")) then { goto preserve }
        math mobcurrent add 1
        goto count


print_need_obfuscation:
  echo ******************
  echo   No Obfuscation
  echo ******************
  goto done

preserve:
    match wait_p ...
    matchre done This ritual may only be performed on|rendered this corpse unusable
    matchre done You bend|You carefully|already been preserved|Roundtime

    put #parse @%disectmobs[%mobcurrent]
    pause 0.5

    if ("%action" = "preserve") then
    {
      put perform preserve on %mobname
    }
    else
    {
      put perform dissection on %mobname
    }


    matchwait

wait_p:
    pause 0.5
    goto preserve

done:
  put #parse PRESERVE DONE
  exit