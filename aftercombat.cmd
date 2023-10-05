var pausetime 30

put #class +app +analyze -combat

if_1 then goto travel

printbox Pausing for %pausetime seconds before traveling
pause %pausetime

travel:
  # Crossing West Gate
  if $zoneid = 4 {
    var target 421
  }

  # Shard West Gate
  if $zoneid = 69 {
    var target 5
  }

  # Shard South Gate
  if $zoneid = 68 {
    var target 77
  }

  # Boar Clan
  if $zoneid = 127 {
    var target 29
  }

go:
  matchre go You can't go there|What were you referring to
  matchre end ^YOU HAVE ARRIVED|^You are already here!
  put #goto %target
  matchwait

end:
put .fillpouch
