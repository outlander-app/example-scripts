var chap 1
var page 1

var book $scholar.book
var play_song YES

var maxexp $Scholarship.LearningRate
math maxexp add 12
if %maxexp >= 34 then {
  var maxexp 34
}

action var play_song YES when You finish playing

goto START

maxexp:
  var maxexp 34
  return

START:
  if_1 then
  {
    gosub %1
    shift
    goto START
  }

echo ****************************************
echo ** For this script to work, you will need a weaponsmithing book and Bones (music instrument)
echo **
echo ** To use another crafting book, find/replace "weapon" to "other book name"
echo **   If you use a book for which Chapter 1 pages cannot be studied, change "var chap 1" above to 2
echo ** To use another 1-handed instrument, find/replace "bones" to "other instrument name"
echo **
echo ** For Genie users, change "save tango" above to appropriate playstyle for your skill range
echo ** Script does not currently work for Wizard without major modifications
echo **
echo ****************************************

put stow right;stow left
pause 1

GetBook:
  match Chap You get
  match Chap You are already
  put get my %book
  matchwait

Chap:
  match Chap ...wait
  match Page You turn your book
  match Page The book is already
  match Done does not have a chapter
  put turn my book to chapter %chap
  matchwait

Page:
  match Page ...wait
  match Study You turn your book
  match Study You are already on
  match AddChap This chapter does not have
  put turn my book to page %page
  matchwait

AddChap:
  var page 1
  math chap add 1
  goto Chap

AddPage:
  math page add 1
  goto Page

Study:
  pause 0.5
  if %play_song = YES then
  {
    put play $play.song $play.style
    var play_song NO
  }
  matchre Study \.\.\.wait|you may only type ahead
  matchre CheckExp You now feel ready|how metal weapon tempering works
  put study my book
  matchwait 10
  goto CheckExp

CheckExp:
  if $Scholarship.LearningRate >= %maxexp then goto Done
  goto AddPage

Done:
  pause 1
  put turn my book to index
  waitforre You turn|is already at the index
  put stow book
  waitforre You put
  put #echo >log #ffff00 Crafting study completed.
  pause 0.5
  put stop play
  pause 0.5
  put #parse SCHOLARSHIP DONE
