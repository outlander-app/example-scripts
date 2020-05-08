debug 5
# prospect variables
if ($charactername = Saracus) then { var axe greataxe }

if $charactername = Dumas then { var axe greataxe }

if $charactername = Tanon then { var axe throwing.axe }


goto done

#Character list for premie areas
var premielist Saracus|Tanon|Dumas

#character list for swimming areas
var swimlist Saracus|Tanon|Dumas

var night early evening|mid-evening|late evening|evening|midnight|night|almost dawn|sunset|approaching sunrise|sunrise|you can't tell
action var time $1 when ^It is currently \w+ and it is (.*)\.

if "$zoneid" = "4" then {
  # Crossing West Gate
  var room 97|98|99|100|106|105|104|102|101|109|108|107|110|111|112|113
  var return 1
}
else if "$zoneid" = "11" then {
  #Black Leucro
  var room 105|108|109|110|136|107|138|137|141|142|143|144|140|139|135|134|113|129|132|133|131|130|128|124|123|126|127|122|120|119|118|121|117|116|115|114|112|106|22|21|20|19|18|17|16|15|14|13|12|11|10|9|8|7|6|5|4|3|1
  var return ntr
}
else if "$zoneid" = "33a" then {
  #Haven West Gate to Ross
  var room 14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30
  var return 30
}
else if "$zoneid" = "34" then {
  #Rossman
  if $roomid < 60 then {
    var room 3|2|1|4|5|6|7|8|10|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|122|123|124|125|126|127|128|129|130|131|132|133|134|135|136
    var return 136
    }
  if $roomid > 120 then {
    var room 136|135|134|133|132|131|130|129|128|127|126|125|124|123|122|58|57|56|55|54|53|52|51|50|49|48|47|46|45|44|43|10|8|7|6|5|4|1|2|3
    var return 5
    }
}
else if "$zoneid" = "40" then {
  #Road between lang and kelpies
  var room 139|138|124|123|122|121|120|119|118|117
  var return 139
}
else if "$zoneid" = "41" then {
  #Ker'Leor
  var room 31|32|33|34|35|36|37|38|39|40|41
  var return lang
}
else if "$zoneid" = "60" then {
  #STR / Forest of Night
  put time
  pause 2
  if matchre("%time","%night") then var room 112|113|114|115|116|117|118|119|120|121|122|123|124|58
  else var room 58
  var room %room|67|68|69|70|71|72|73|74|75|76|77|78|79|80|81|82|83|84|85|86|88|89|90|91|92|93|62|63|64|65|66|104|103|102|101|100|99|98|97|96|95|94|59|60|61
  var return 20
}
else if "$zoneid" = "61" then {
  #Leth Premie
  var room 194|196|199|198|197|195
  var return Shard
}
else if "$zoneid" = "62" then {
  #STR / Snowbeasts
  var room 16|17|18|19|20|33|31|32|35
  var return 3
}
else if "$zoneid" = "65" then {
  #Red leucs
  var room 3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22
  if matchre("%swimlist","$charactername") then var room %room|83|82|81|80|79
  var return 2
}
else if "$zoneid" = "66" then {
  #North of Shard
  var room 14|15|16|17|18|115|116|117|118|119|120|121|122|123|124|131|151
  if matchre("%premielist","$charactername") then var room %room|645|650|651|652|653|654
  var return 71
}
else if "$zoneid" = "68" then
{
  #South of Shard
  var room 3|4|5|6|7|28|29|30|31|32|33|34|138|139|140|141|142|143|144|210|209|145|146|147|148|149|150|151|152|153|154|155|156|157|158|159|160|161|162|163|164|165|166|167|168|169|170|171|172|173|174|175|176
  var room %room|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|69|70|71|72|73|75
  var return 115
}
else if "$zoneid" = "69" then {
  #wyvern wood
  var room 24|25|26|27|28|29|30|32|33|34|35|36|37
  var return 2
}

afterZone:
eval room.max countsplit("%room","|")
var room.count 0
var keep bloodwood|copperwood|darkspine|silverwood|pozumshi|smokewood|mistwood|goldwood|glitvire|adderwood|rockwood|azurelle|gloomwood|diamondwood|alerce

if_1 var keep %keep|%1

var harvest ""
var logs osage|yew|ebony|kapok|bocote|sandalwood|cherry|yew|tamarak|lelori|rosewood|osage|redwood|ironwood
var type start

action (watch) var type $1 when contains (no trees to lumberjack).
action (watch) var type $1 when This area contains a (\w+) forest.
action (watch) var type %type|$1;put #echo >log #CDAF95 [map$zoneid|$roomid]: %type when ^You are certain that (\w+) trees can be harvested here.
action (watch) off

action var redo 1 when a thick mist seems to rise up around you
action goto watch.loop when ^MOVE FAILED

watch.loop:
if !("%room(%room.count)" = "off") then
{
  if !("$roomid" = "%room(%room.count)") then
  {
    put #goto %room(%room.count)
    waitforre ^YOU HAVE ARRIVED
    if %redo = 1 then
    {
      var redo 0
      goto watch.loop
    }
  }
}

action (watch) on
send watch forest
pause 4
action (watch) off

if matchre("%type","%logs") then
{
  if !(%harvest = off) then
  {
    if %harvest = "" then var harvest $roomid
    else var harvest %harvest|$roomid
  }
}
if matchre("%type","%keep") then gosub log.loop
math room.count add 1
var type start
if %room.count > %room.max then {
  if !(%harvest = "") then {
    if !(%harvest = off) then goto rares
  }
  else goto exit
}
goto watch.loop

log.loop:
  if !("$roomplayers" = "") then return
  put wield my %axe
  put untie my %axe
  pause .5
  put .logging
  waitforre ^LOGGING CONTINUE
  put sheath
  return

rares:
  var keep %keep|%logs
  var room %harvest
  var room.count 0
  eval room.max count("%room","|")
  var harvest off
  goto watch.loop

exit:
  put #goto %return
  waitforre ^YOU HAVE ARRIVED
  put #parse LOG CONTINUE
  exit

done:
