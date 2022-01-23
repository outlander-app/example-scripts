debug 5

action var skill $1;var num $2 when ^EXPTRACKER (.+) (-?\d+)

var weapons Targeted_Magic|Bow|Brawling|Large_Edged|Small_Edged

start:
    send /tracker lowest %weapons
    echo lowest skill is %skill at position %num
    send /tracker highest %weapons
    echo highest skill is %skill at position %num
    pause 2
    goto start