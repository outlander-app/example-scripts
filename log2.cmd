debug 5

if $charactername = Saracus then { var axe greataxe }
if $charactername = Dumas then { var axe greataxe }
if $charactername = Tanon then { var axe throwing.axe }

# character list for premie areas
var premielist Saracus|Tanon|Dumas

# character list for swimming areas
var swimlist Saracus|Tanon|Dumas

var night early evening|mid-evening|late evening|evening|midnight|night|almost dawn|sunset|approaching sunrise|sunrise|you can't tell
action var time $1 when ^It is currently \w+ and it is (.*)\.

var room

# STR / Snowbeasts
if "$zoneid" = "62" then
{
  var room 16|17|18|19|20|33|31|32|35
  var return 3
}

# Red leucs
if ("$zoneid" = "65") then
{
  var room 3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22

  if matchre("%swimlist","$charactername") then
  {
      var room %room|83|82|81|80|79
  }
  var return 2
}

if "$zoneid" = "66" then
{
  # North of Shard
  var room 14|15|16|17|18|115|116|117|118|119|120|121|122|123|124|131|151
  if matchre("%premielist","$charactername") then { var room %room|645|650|651|652|653|654 }
  var return 71
}

if "$zoneid" = "68" then
{
  # South of Shard
  var room 3|4|5|6|7|28|29|30|31|32|33|34|138|139|140|141|142|143|144|210|209|145|146|147|148|149|150|151|152|153|154|155|156|157|158|159|160|161|162|163|164|165|166|167|168|169|170|171|172|173|174|175|176
  var room %room|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|69|70|71|72|73|75
  var return 77
}

afterZone:
eval room_max countsplit("%room","|")
var room_count 0
var keep bloodwood|copperwood|darkspine|silverwood|pozumshi|smokewood|mistwood|goldwood|glitvire|adderwood|rockwood|azurelle|gloomwood|diamondwood|alerce

if_1 var keep %keep|%1

var harvest
var logs osage|yew|ebony|kapok|bocote|sandalwood|cherry|yew|tamarak|lelori|rosewood|osage|redwood|ironwood
var type start

action (watch) var type $1 when contains (no trees to lumberjack)
action (watch) var type $1 when This area contains a (\w+) forest
action (watch) var type $1;put #echo >log #CDAF95 [map$zoneid|$roomid]: %type when ^You are certain that (\w+) trees can be harvested here
action (watch) off

action var redo 1 when a thick mist seems to rise up around you
action goto watchLoop when ^MOVE FAILED

watchLoop:
    var target_room %room(%room_count)

    if ("$roomid" != "%target_room") then
    {
        put #goto %target_room
        waitforre ^YOU HAVE ARRIVED
        if %redo = 1 then
        {
            var redo 0
            goto watchLoop
        }
    }

    action (watch) on
    send watch forest
    pause 4
    action (watch) off

    if matchre("%type","%keep") then gosub log.loop

    math room_count add 1
    var type start

    if (%room_count >= %room_max) then goto done

    goto watchLoop

log.loop:
  if ("$roomplayers" != "") then return
  put wield my %axe
  put untie my %axe
  pause .5
  put .logging
  waitforre ^LOGGING CONTINUE
  put sheath
  return

done:
  put #goto %return
  waitforre ^YOU HAVE ARRIVED
  put #parse LOG CONTINUE
  exit
