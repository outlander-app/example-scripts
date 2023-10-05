debug 5

var item
var money 0
var denomination
action var money $1;var denomination $2 when hands you (\d+) (Kronars|Dokoras|Lirums)

if_1 goto %1

travel:
  # Crossing
  if $zoneid == 1 {
    var room 119
  }

  # Shard
  if $zoneid == 67 {
    var room 205
  }

  # Hibarnhvidar
  if $zoneid == 116 {
    var room 54
  }

  gosub go %room
  goto burgle

go:
  var target $0
go.retry:
  matchre go.retry You can't go there|What were you referring to
  matchre return ^YOU HAVE ARRIVED|^AUTOMAPPER ALREADY HERE
  put #goto %target
  matchwait


burgle:
    matchre pawn ^BURGLE DONE
    matchre end ^BURGLE WAIT
    put .burgle
    matchwait

pawn:
  var item $lefthand

  var drop_items stick|sieve|rat|mouse

  if contains("%drop_items", "$lefthandnoun") then {
    put empty left
    pause 0.5
  }

  if "$lefthand" == "Empty" then goto end
  gosub go pawn

  if "$lefthand" == "recipe box" then {
    put open my recipe box
    put get my key in my recipe box
    pause 0.5
    put put my key in bucket
  }

  put sell my $lefthandnoun

  if $zoneid == 116 then {
    put out
  }
  goto end

end:
  pause 0.5
  put #echo >log Burgle: %item %money %denomination

  # Crossing
  if $zoneid == 1 {
    var room 119
  }

  # Shard
  if $zoneid == 67 {
    var room e tower
  }

  # Hibarnhvidar
  if $zoneid == 116 {
    var room 217
  }

  gosub go %room

  put #parse STEAL DONE