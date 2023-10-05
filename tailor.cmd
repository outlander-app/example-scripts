debuglevel 5

var item %1
var type cloth
var itemDesc
var count 1
var current_count 0
var primary.container $lw.container
var sewspeed sew

if_2 then
{
  var count %2
}

goto %item

small.padding:
  var item padding
  var itemDesc some small cloth padding
  gosub book 1
  goto %sewspeed

large.padding:
  var item padding
  var itemDesc some large cloth padding
  gosub book 1
  goto %sewspeed

socks:
  var itemDesc some cloth socks
  gosub book 2
  goto %sewspeed

armband:
  var itemDesc a cloth armband
  gosub book 2
  goto %sewspeed

knap:
  var itemDesc a cloth knapsack
  gosub book 3
  var sewspeed sewfast
  goto %sewspeed

haver:
  var itemDesc a cloth haversack
  gosub book 3
  goto %sewspeed

#0-50
ankleband:
  var itemDesc a leather ankleband
  var type leather
  gosub book 7
  goto %sewspeed

# 0-75
eyepatch:
  var itemDesc a leather eyepatch
  var type leather
  gosub book 7
  goto %sewspeed

# 75-80
shoes:
  var itemDesc some leather shoes
  var type leather
  gosub book 7
  goto %sewspeed

# 80-?
hat:
  var itemDesc a leather hat
  var type leather
  gosub book 7
  goto %sewspeed

# 100-?
sash:
  var itemDesc a cloth sash
  gosub book 2
  goto %sewspeed

# 125-?
bag:
  var itemDesc a cloth bag
  gosub book 3
  goto %sewspeed

towel:
  var itemDesc a cloth towel
  gosub book 3
  var sewspeed sewfast
  goto %sewspeed

blanket:
  var itemDesc a cloth blanket
  gosub book 3
  goto %sewspeed

# 500-700?
rucksack:
  var itemDesc a cloth rucksack
  gosub book 3
  goto %sewspeed

# 700-?
belt:
  var itemDesc a cloth mining belt
  gosub book 3
  goto %sewspeed

sbelt:
  var itemDesc a cloth survival belt
  gosub book 3
  var item belt
  goto %sewspeed

fbelt:
  var itemDesc a cloth survival belt
  gosub book 3
  var sewspeed sewfast
  var item belt
  goto %sewspeed

fpad:
  var itemDesc a cloth saddle pad
  gosub book 3
  var sewspeed sewfast
  var item pad
  goto %sewspeed

netting:
  var itemDesc reinforced netting
  var sewspeed instructions
  var item netting
  goto %sewspeed

outfit:
  var itemDesc outfit
  var sewspeed instructions
  var item netting
  goto %sewspeed

book:
  var chapter $1
  put get my tailoring book
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
  #put stow t book
  return

get.cloth:
  pause 0.5
  put put my %item in my %primary.container
  put get my %type in my %primary.container
  waitfor You get
  goto %sewspeed

sew:
  send .lw %item
  waitforre ^LW DONE
  pause 0.5
  goto checkCount

sewfast:
  send .lwfast %item
  waitforre ^LW DONE
  pause 0.5
  goto checkCount

instructions:
  send .lwfast %item instructions
  waitforre ^LW DONE
  pause 0.5
  goto checkCount

checkCount:
  math current_count add 1
  if (%current_count < %count) then goto get.cloth
  goto done

error:
  echo
  echo  *** Could not match item description: %itemDesc ***
  echo
  exit

done:
  put #parse TAILOR DONE
