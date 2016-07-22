
put get my lockpick

top:
  matchre top Roundtime
  matchre get.pick Find a more appropriate tool and try again
  put pick blind
  matchwait 3

get.pick:
  put get my lockpick
  goto top

end: