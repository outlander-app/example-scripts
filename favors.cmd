# If you like this script please send a tip to Gavinne@play.net via Paypal
# Or contact XLNOTHINGLX on AIM and ask about the awesome scripts we sell!

if_1 goto %1


rerun:
put #window remove XFavors
pause 0.5
put #window add XFavors
pause 1
put #window clear XFavors
put #echo >XFavors ** Welcome to XFavors. **
put #echo >XFavors
put #echo >XFavors ** Please Click Your Selection. **
put #echo >XFavors
put #link >XFavors {Kertigen} {#parse set Kertigen God}
put #link >XFavors {Hodierna} {#parse set Hodierna God}
put #link >XFavors {Meraud} {#parse set Meraud God}
put #link >XFavors {Damaris} {#parse set Damaris God}
put #link >XFavors {Everild} {#parse set Everild God}
put #link >XFavors {Truffenyi} {#parse set Truffenyi God}
put #link >XFavors {Hav'roth} {#parse set Hav'roth God}
put #link >XFavors {Eluned} {#parse set Eluned God}
put #link >XFavors {Glythtide} {#parse set Glythtide God}
put #link >XFavors {Tamsine} {#parse set Tamsine God}
put #link >XFavors {Faenella} {#parse set Faenella God}
put #link >XFavors {Chadatru} {#parse set Chadatru God}
put #link >XFavors {Urrem'tier} {#parse set Urrem'tier God}
     waitforre set (Kertigen|Hodierna|Meraud|Damaris|Everild|Truffenyi|Hav'roth|Eluned|Glythtide|Tamsine|Faenella|Chadatru|Urrem'tier) God
     setvariable god $1
     put #window clear XFavors
put #echo >XFavors ** Please Click Your Selection. **
put #echo >XFavors
put #link >XFavors {Get One Favor From %god} {#parse set 1 favors}
put #link >XFavors {Get Two Favors From %god} {#parse set 2 favors}
put #link >XFavors {Get Three Favors From %god} {#parse set 3 favors}
put #link >XFavors {Get Four Favors From %god} {#parse set 4 favors}
put #link >XFavors {Get Five Favors From %god} {#parse set 5 favors}
put #link >XFavors {Get Six Favors From %god} {#parse set 6 favors}
put #link >XFavors {Get Seven Favors From %god} {#parse set 7 favors}
put #link >XFavors {Get Eight Favors From %god} {#parse set 8 favors}
put #link >XFavors {Get Nine Favors From %god} {#parse set 9 favors}
put #link >XFavors {Get Ten Favors From %god} {#parse set 10 favors}
     waitforre set (\d+) favors
     setvariable quantity $1
     put #window clear XFavors
put #echo >XFavors ** You have chosen to get %quantity favors from %god. **
put #echo >XFavors ** Is this correct? **
put #echo >XFavors
put #link >XFavors {Yes} {#parse set correctly}
put #link >XFavors {No} {#parse set incorrectly)
     match rerun set incorrectly
     match gogetem set correctly
     matchwait
gogetem:
     put #window clear XFavors
     pause 0.5
put #echo >XFavors ** Getting %quantity favors from %god. **
     pause 1
put #window clear XFavors
put #window remove XFavors
     setvariable favorsgot 0
     setvariable display 1
if "$lefthand" != "Empty" then put stow left
if "$righthand" != "Empty" then put stow right
 
favorloop:
     pause 1
     gosub display Traveling...
     gosub move w gate
   pause 1
     gosub move favors
 
pray.p:
        pause 1
pray:
     gosub display Praying...
put pray
        match pray.p type ahead
        match pray.p ...wait
        matchre pray (You feel a sense of peace settle over you|You close your eyes and pray|As you continue to pray, another sound presents itself)
        match pray.d prepare to prove thy worthiness
        matchwait
pray.d:
put say %god
        waitfor rise and seek your favor
put stand
        match puzzle-start you are enveloped in a bright flash of light
        match pray You stand back up
        matchwait
puzzle-start:
     gosub display Getting Orb...
put get %god orb on altar
        waitforre You get .* atop an altar made of gleaming alabaster trimmed with onyx
        setvariable next-action go arch
        goto puzzles
 
puzzles.p:
     pause 1
puzzles:
     gosub display Solving Puzzles...
put %next-action
     match puzzles.p type ahead
     match puzzles.p ...wait
        matchre figure-puzzle (some tinders|water jug|small sponge|ancient window|tiny bubbling pool under some mintberry bushes|hedges of oleander and nutflower)
        matchre check-puzzle (difficult to go through the door from the bottom|You cannot go through a closed window)
        matchwait 5
        goto check-puzzle

check-puzzle:
        setvariable next-action look
        goto puzzles
figure-puzzle:
        setvariable temp $0
        if "%temp" = "hedges of oleander and nutflower" then gosub verb get oleander
        if "%temp" = "some tinders" then gosub verb light candle
        if "%temp" = "water jug" then gosub verb pour jug
        if "%temp" = "small sponge" then gosub verb clean altar
        if "%temp" = "ancient window" then gosub verb open window
        if "%temp" = "some tinders" then setvariable next-action go stair;go door
        if "%temp" = "water jug" then setvariable next-action go stair;go door
        if "%temp" = "small sponge" then setvariable next-action go stair;go door
        if "%temp" = "ancient window" then setvariable next-action go window
        if "%temp" = "hedges of oleander and nutflower" then setvariable next-action go tree
        if "%temp" = "tiny bubbling pool under some mintberry bushes" then goto got-orb
        goto puzzles
 
verb:
        setvariable verb $0
        goto verb-enact
verb.p:
        pause 1
verb-enact:
        match verb.p type ahead
        match verb.p ...wait
        matchre verb.d (You gingerly take the earthen jug|You have already filled the font|You pick up the sponge and proceed|You have already cleaned the altar|You reach into the bucket and remove a tinder|swift breeze moves into the room|That is already open|You carefully pick some of the|You stand)
        matchre verb.p (Judging the thickness of the pain|Shaking the frame of the glass once more)
put %verb
        matchwait 5
        goto verb-enact
verb.d:
        return
got-orb:
     gosub display Traveling...
     gosub move w gate
   pause 1
     gosub move temple
   pause 1
     gosub display Selecting Room...
random 1 5
     if %r = 1 then gosub move 9
     if %r = 2 then gosub move 8
     if %r = 3 then gosub move 20
     if %r = 4 then gosub move 19
     if %r = 5 then gosub move 22
   pause 1
collect.reset:
     gosub display Randomizing Repitions...
     random 6 10
     setvariable limit %r
     setvariable tracker 1
collect.p:
     pause 1
collect:
     gosub display Collecting %tracker of %limit ...
     if $standing = 0 then gosub verb stand
     match collect.p type ahead
     match collect.p ...wait
     match collect.d Roundtime
put collect rock
     matchwait
collect.d:
     goto kick
kick.p:
     pause 1
kick:
     match kick.p type ahead
     match kick.p ...wait
     match kick.d I could not find what
     match kick.d You take a step back and run
put kick pile
     matchwait
kick.d:
     math tracker add 1
     if %tracker < %limit then goto collect
     gosub display Filling Orb...
put hug %god orb
     matchre collect.reset (your sacrifice is not yet fully prepared|you are lacking in the type of sacrifice)
     match orb-altar sacrifice is properly prepared
     matchwait
orb-altar:
     gosub display Traveling...
     gosub move 2
   pause 1
     gosub display Placing Orb on Altar
     pause 1
put go door;put my %god orb on altar
     waitfor  you feel somehow changed
move go door
move south
move go gate
     gosub display Thinking...
     math favorsgot add 1
     if %favorsgot < %quantity then goto favorloop
     gosub display All Done!
     move ne
     move go bank
     move go window
     echo . [ All Done! ]
     #put #statusbar .
     exit

display:
     setvariable text $0
     if %display = 1 then put #echo >log %favorsgot of %quantity %god favors. -- [ %text ]
     if %display = 2 then put #echo >log %favorsgot of %quantity %god favors. -- [ %text ]
     math display add 1
     if %display > 2 then setvariable display 1
     return
 
 
 
 
goto move.end
move.retry:
        math move.retry add 1
        if %move.retry > 3 then goto move.fail
        echo ***
        echo *** Retrying move to $1 $2 in %move.retry second(s).
        echo ***
        pause %move.retry
        goto move.goto
move:
        var move.skip 0
        var move.retry 0
        var move.fail 0
        var move.room $0
move.goto:
        matchre move.return ^YOU HAVE ARRIVED
        matchre move.skip ^SHOP CLOSED
        matchre move.retry ^MOVE FAILED
        matchre move.fail ^DESTINATION NOT FOUND
        put #goto %move.room
        matchwait
move.fail:
        var move.fail 1
        goto move.return
move.skip:
        var move.skip 1
move.return:
    send enc
    waitfor Encumbrance
        return
move.end: