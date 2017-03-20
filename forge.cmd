
debuglevel 5

var item %1
var itemDesc
var book weaponsmithing
var count 1
var current_count 0
var primary.container $forging.container
var smithspeed smith

if_2 then
{
  var count %2
}

goto %item

dagger:
  var itemDesc a metal dagger
  gosub book 1
  goto %smithspeed

pugio:
  var itemDesc a metal pugio
  gosub book 1
  goto %smithspeed

# 50-125
kris:
  var itemDesc a metal kris
  gosub book 1
  goto %smithspeed

# 100 - 175?
dao:
  var itemDesc a metal dao
  gosub book 1
  goto %smithspeed

rapier:
  var itemDesc a metal rapier
  gosub book 1
  goto %smithspeed

# 100- 175?
gloves:
  var itemDesc some metal mail gloves
  var book armorsmithing
  gosub book 1
  goto %smithspeed

# 175 - 275
sabre:
  var itemDesc a metal sabre
  gosub book 1
  goto %smithspeed

scimitar:
  var itemDesc a metal scimitar
  gosub book 1
  goto %smithspeed

tasset:
  var itemDesc a metal mail tasset
  var book armorsmithing
  gosub book 1
  goto %smithspeed

# 175 - 275
broadsword:
  var itemDesc a metal broadsword
  gosub book 2
  goto %smithspeed

# 250 - ?
cinq:
  var itemDesc a metal cinquedea
  var item cinquedea
  gosub book 2
  goto %smithspeed

# 250 -?
vest:
  var itemDesc a metal mail vest
  var book armorsmithing
  gosub book 1
  goto %smithspeed

book:
  var chapter $1
  put get my %book book
  pause
  put turn my book to chapter %chapter
  put read my book
  matchre stowbook Page (\d+): %itemDesc
  matchwait 10
  goto error

stowbook:
  var page $1
  put turn my book to page %page
  pause
  put stow my book
  pause
  return

get.item:
  pause 0.5
  put put my %item in my %primary.container
  put get my ingot in my %primary.container
  waitfor You get
  goto %smithspeed

smith:
  send .smith %item %book
  waitforre ^SMITH DONE
  pause 0.5
  goto checkCount

smithfast:
  send .smith %item %book
  waitforre ^SMITH DONE
  pause 0.5
  goto checkCount

checkCount:
  math current_count add 1
  if (%current_count < %count) then goto get.item
  goto done

error:
  echo
  echo  *** Could not match item description: %itemDesc ***
  echo
  exit

done:
  put #parse SMITHING DONE
