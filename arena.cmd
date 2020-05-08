#debug 5

var kills 0
var mod

watchKills:
  matchre addKill .* has vanquished the .* Get it out of there
  matchwait

addKill:
  math kills add 1

  var mod %kills
  math mod modulus 5

  var ending

  if %mod == 0 then {
    var ending (Veteran)
  }

  put #echo >log Kills: %kills %ending


  goto watchKills
