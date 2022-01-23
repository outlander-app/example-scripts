# debug 5

var action %1

set_creature:

    var disectmobs $roomobjs
    action var mobname $1 when ^@.*\s(\S+) (?:which|that) appears dead

    var mobstotal

    var ordinal first|second|third|fourth|fifth|sixth|seventh
    eval disectmobs replace("%disectmobs", "You also see ", "")
    eval disectmobs replace("%disectmobs", " and some junk", "")
    eval disectmobs replace("%disectmobs", " and ", ", ")
    eval disectmobs replace("%disectmobs", "\.", "")
    eval disectmobs replace("%disectmobs", ", ", "|")
    eval mobstotal countsplit("%disectmobs", "|")
    var mobcurrent 0

    count:
        if (%mobcurrent >= %mobstotal) then { goto done }

        var check %disectmobs[%mobcurrent]

        if (matchre("%check", "dead")) then { goto preserve }
        math mobcurrent add 1
        goto count


preserve:
    match wait_p ...
    matchre done This ritual may only be performed on|rendered this corpse unusable|skinned creature is worthless for your purposes|Rituals do not work upon constructs|while it is still alive|You'll learn nothing further of value
    matchre done You bend|You carefully|already been preserved|Roundtime

    put #parse @%disectmobs[%mobcurrent]
    pause 0.5

    if ("%action" = "preserve") then
    {
      put perform preserve on %mobname
    }
    else
    {
      if "$guild" == "Necromancer" then put perform dissection on %mobname
      else put dissect %mobname
    }

    matchwait 3
    goto preserve

wait_p:
    pause 0.5
    goto preserve

done:
  put #parse PRESERVE DONE
  exit