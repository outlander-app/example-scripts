#debug 5

var container $primary.container
var gempouch $gem.pouch

if (%argcount == 0 || %1 < 1) then 
{
    echo enter a number larger than 0
    exit
}

var pouches %1
var loop_count 0

var numbers first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth

loop:
  gosub app

  math loop_count add 1

  if (%loop_count >= %pouches) then goto end

  goto loop

app:
  var number %numbers[%loop_count]

  var temp %loop_count
  math temp add 1

  echo %temp / %pouches

  put get my %number %gempouch in my %container
  put app my %gempouch quick
  waitfor Roundtime
  pause 0.5
  goto fill

fill:
  matchre tie too valuable to leave untied
  matchre stow too full to fit any more gems
  matchre app Encumbrance
  put fill my %pouch with my %gem.container
  put enc
  matchwait 3
  goto fill

tie:
  pause
  put tie my %pouch
  goto fill

stow:
  match RETURN You put
  pause 0.1
  put put my %gempouch in my %container
  matchwait 2
  goto stow

RETURN:
  return

checkExp:
  goto loop

end:
  put #parse FIX DONE
