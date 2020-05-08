debug 5

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

  put get my %number %gempouch in my %container
  put app my %gempouch quick
  waitfor Roundtime
  goto stow

stow:
  match RETURN You put
  pause 0.1
  put put my %gempouch in my %container
  matchwait 2
  goto stow

RETURN:
  return

checkExp:
  if ($Appraisal.LearningRate >= 34) then goto end
  goto loop

end:
  put sort my %gempouch
  put #parse APPRAISE DONE
