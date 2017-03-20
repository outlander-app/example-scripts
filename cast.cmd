#[Magic]: Cast spell at full preparedness

matchre CAST You feel fully prepared|formation of a targeting pattern
matchwait 60
goto END

CAST:
put cast %1 %2

END:
