debug 5

var premium $premium
var withdrawl 0
var withdraw_amount 5 gold

var teller teller
var exchange exchange
var coinage kronar

if "$zoneid" == "1" then goto crossing
if "$zoneid" == "67" then goto shard
if "$zoneid" == "30" then goto riverhaven

echo *** No bank configured for zone $zoneid ***
goto end

toggle_premium:
  if %premium == 1 {
    var teller premium teller
    var exchange premium exchange
  }
  return

check_withdraw:
  if %withdraw == 1 {
    put withdraw %withdraw_amount %coinage
    waitfor The clerk counts out
  }
  return

crossing:
  var coinage kronar
  gosub toggle_premium
  gosub crossing_exchange
  gosub teller %coinage
  gosub check_withdraw
  goto end

crossing_exchange:
  gosub automapper %exchange
  put exchange all lirum to kronar
  put exchange all dokora to kronar
  wait
  return

shard:
  var coinage dokora
  gosub automapper %exchange
  gosub do_exchange dokora kronar lirum
  gosub teller %coinage
  gosub check_withdraw
  waitfor The clerk counts out
  move south
  goto end

riverhaven:
  var coinage lirum
  gosub toggle_premium
  gosub automapper %exchange
  gosub do_exchange lirum kronar dokora
  gosub teller %coinage
  waitfor The clerk counts out
  goto end

teller:
  var coins $0
  gosub automapper %teller
  put wealth
  put deposit all %coins
  put balance
  waitforre The clerk pages through
  return

do_exchange:
  var to $1
  var from1 $2
  var from2 $3
  put exchange all %from1 to %to
  put exchange all %from2 to %to
  wait
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
