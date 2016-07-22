
var action %1
var item $righthandnoun
var itemDesc

gosub %action

laminate:
  var itemDesc bow lamination
  gosub book 6
  goto enhance

lighten:
  var itemDesc bow lightening
  gosub book 6
  goto enhance

cable:
  var itemDesc bow cable-backing
  gosub book 6
  goto enhance

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

enhance:
  put .laminate %item
  waitforre ^FLETCHING DONE
  pause 0.5
  goto done

error:
  echo
  echo  *** Could not match item description: %itemDesc ***
  echo
  exit

done:
  put #parse ENHANCEBOW DONE