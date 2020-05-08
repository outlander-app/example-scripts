debuglevel 5

var item %1
var itemDesc
var count 1
var current_count 0
var primary.container $lw.container
var item.container $lw.container
var shapeaction shape
var material lumber

if_2 then
{
  var count %2
}

goto %item

nisha:
  var itemDesc a Nisha shortbow
  var item shortbow
  gosub book 2
  goto %shapeaction

longbow:
  var itemDesc a competition longbow
  gosub book 3
  goto %shapeaction

battlelongbow:
  var itemDesc a battle longbow
  gosub book 3
  goto %shapeaction

battlebow:
  var itemDesc a battle bow
  var item bow
  gosub book 4
  goto %shapeaction

comb:
  var itemDesc a wood comb
  gosub book 7
  goto %shapeaction

haircomb:
  var itemDesc a wood haircomb
  gosub book 7
  goto %shapeaction

basilisk:
  var itemDesc basilisk arrows
  var material shafts
  var item.container quiver
  var shapeaction arrows
  gosub book 5
  goto get.lumber

iceadder:
  var itemDesc ice-adder arrows
  var item ice-adder
  var material shafts
  var item.container quiver
  var shapeaction arrows
  gosub book 5
  goto get.lumber

jaggedhorn:
  var itemDesc jagged-horn arrows
  var item jagged-horn
  var material shafts
  var item.container fletching kit
  var primary.container fletching kit
  var shapeaction arrows
  gosub book 5
  goto get.lumber

book:
  var chapter $1
  put get my shaping book
  pause
  put turn my book to chapter %chapter
  put read my book
  matchre stowbook Page (\d+): %itemDesc
  matchwait 3
  goto error

stowbook:
  var page $1
  put turn my book to page %page
  pause
  return

get.lumber:
  pause 0.5
  put put my $righthandnoun in my %item.container
  put get my %material in my %primary.container
  waitfor You get
  goto %shapeaction

shape:
  send .ww %item
  waitforre ^WOODWORK DONE
  pause 0.5
  goto checkCount

arrows:
  send .arrows %item
  waitforre ^WOODWORK DONE
  pause 0.5
  goto checkCount

checkCount:
  math current_count add 1
  if (%current_count < %count) then goto get.lumber
  goto done

error:
  echo
  echo  *** Could not match item description: %itemDesc ***
  echo
  exit

done:
  put #parse FLETCHING DONE