debug 5

var crossingZone 1

goto %1

Shard:
  if $zoneid == 66 then {
    echo
    echo You're already here!
    echo
  }
  if $zoneid == 1 then {
    gosub crossingToLeth
    gosub lethToShard
  }
  if $zoneid == 4 then gosub crossingWestGateToShard
  if $zoneid == 61 then gosub lethToShard
  goto end

Leth:
  if $zoneid == 61 then {
    echo
    echo You're already here!
    echo
  }
  if $zoneid == 1 then gosub crossingToLeth
  if $zoneid == 66 then gosub shardSTRToLeth
  goto end

Crossing:
  if $zoneid == 1 then {
    echo
    echo You're already here!
    echo
  }
  if $zoneid == 61 then gosub lethToCrossing
  if $zoneid == 65 then gosub underGondolaToCrossing
  if $zoneid == 66 then gosub shardSTRToCrossing
  if $zoneid == 67 then gosub shardToCrossing
  if $zoneid == 68 then gosub wallToCrossing
  goto end

underGondolaToCrossing:
  gosub automapper Leth
  gosub automapper Leth
  gosub lethToCrossing
  return

crossingWestGateToShard:
  gosub automapper Crossing
  gosub crossingToLeth
  gosub lethToShard
  return

crossingToLeth:
  gosub automapper Segoltha River
  gosub automapper South
  gosub automapper Leth
  return

lethToShard:
  gosub automapper Shard
  gosub automapper Undergondola
  gosub automapper Shard
  gosub automapper 65
  return

lethToCrossing:
  gosub automapper Crossing
  gosub automapper Segoltha River
  gosub automapper Crossing
  gosub automapper 336
  return

wallToCrossing:
  gosub automapper e tower
  gosub shardToShardSTR
  gosub shardSTRToCrossing
  return

shardSTRToLeth:
  gosub automapper Waterfall
  gosub automapper Leth
  gosub automapper Leth
  return

shardSTRToCrossing:
  gosub shardSTRToLeth
  gosub lethToCrossing
  return

shardToShardSTR:
  gosub automapper 134
  move climb emb
  move n
  move n
  return

shardToCrossing:
  gosub ShardToShardSTR
  gosub shardSTRToCrossing
  return


automapper:
  put #goto $0
  waitforre ^YOU HAVE ARRIVED
  echo
  echo *** You have arrived at $roomtitle ***
  echo
  pause 0.5
  return

end:
  put #parse TRAVEL DONE
