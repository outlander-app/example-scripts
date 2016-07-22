#[Misc] Idle

START:
put exp
#match STOP No skills have field experience or none meet your criteria!
match STOP You are a ghost!
match STOP You are dead
match WAIT EXP HELP
matchwait 30
goto START

WAIT:
pause 200
goto START

STOP:
put exit
