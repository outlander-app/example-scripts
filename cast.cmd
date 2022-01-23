#[Magic]: Cast spell at full preparedness

matchre CAST You feel fully prepared|formation of a targeting pattern
matchwait 70
goto END

CAST:
    pause 0.1
    match CAST ...
    matchre END You gesture|have a spell
    put cast %1 %2
    matchwait 1
    goto CAST

END:
