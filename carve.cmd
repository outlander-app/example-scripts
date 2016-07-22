
debuglevel 5

var item %1
var itemDesc
var count 1
var current_count 0
var primary.container $lw.container
var carvespeed carve

if_2 then
{
  var count %2
}

goto %item

javelin:
  var itemDesc a bone javelin
  gosub book 8
  goto %carvespeed

# ~175 - ?
shiv:
  var itemDesc a bone shiv
  gosub book 8
  goto %carvespeed

tasset:
  var itemDesc a ribbed bone tasset
  gosub book 10
  var carvespeed carvefast
  goto %carvespeed

# 240- 274
buckle:
  var itemDesc a bone belt buckle
  gosub book 9
  goto %carvespeed

# 275- ?
choker:
  var itemDesc a bone choker
  gosub book 9
  goto %carvespeed

# <450 - 501
necklace:
  var itemDesc an articulated bone necklace
  gosub book 9
  goto %carvespeed

crown:
  var itemDesc a bone crown
  gosub book 9
  goto %carvespeed

comb:
  var itemDesc a bone comb
  gosub book 9
  goto %carvespeed

book:
  var chapter $1
  put get my carving book
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
  #put stow carving book
  return

get.stack:
  pause 0.5
  put put my %item in my %primary.container
  put get my stack in my %primary.container
  waitfor You get
  goto %carvespeed

carve:
  send .bw %item
  waitforre ^BW DONE
  pause 0.5
  goto checkCount

carvefast:
  send .bwfast %item
  waitforre ^BW DONE
  pause 0.5
  goto checkCount

checkCount:
  math current_count add 1
  if (%current_count < %count) then goto get.stack
  goto done

error:
  echo
  echo  *** Could not match item description: %itemDesc ***
  echo
  exit

done:
  put #parse CARVING DONE