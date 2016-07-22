#Tailoring - Sealing

var container1 backpack
var container2 backpack
var item %1

ECHO *******************************
ECHO **
ECHO ** This script assumes that you have many items in Container1 that need to be Sealed
ECHO ** after completing, items will be placed in Container2
ECHO **
ECHO **
ECHO ** When starting the script, type .seal <item>
ECHO **
ECHO ** For Genie, change Var container1 to where your un-sealed items start
ECHO **     and change Var container 2 to where you put sealed items
ECHO ** To use with Wizard, Find/Replace %container1 and %container2 to actual container names
ECHO **
ECHO ********************************

if_2 goto %2


Get:
  pause 1
  match top You are already
  match Get2 What were you
  put get my %item
  matchwait

Get2:
  pause 1
  match top You get
  match done What were you
  put get my %item in my %container1
  matchwait

top:
  put get tailor book
  put turn my book to chap 1
  waitforre You turn|already turned to chapter 1
  matchre Page10 Page (\d+): tailored armor sealing
  put read my book
  matchwait

Page10:
  pause 1
  put turn my book to page $1
  goto Study
Page5:
  pause 1
  put turn my book to page 5
  goto Study
Page8:
  pause 1
  put turn my book to page 8
  goto Study

Study:
  waitfor tailored armor sealing
  put study my book
  waitfor Roundtime
  pause 2
  put stow my book
  waitfor You put
  put get my wax
  waitfor You get

Wax:
  match Wax ...wait
  match Done You cannot figure out
  match GetSlick Roundtime
  put apply my wax to my %item
  matchwait

GetSlick:
  pause 1
  match Slick You get
  match GetSlick ...wait
  put stow wax
  put get my slickstone
  matchwait

Slick:
  match Slick ...wait
  match GetWax Roundtime
  put rub my %item with my slick
  matchwait

GetWax:
  pause 1
  match Wax You get
  match GetWax ...wait
  put stow slick
  put get my wax
  matchwait

Done:
  put stow wax
  put put my %item in my %container2
  waitfor You put
  goto Get
  exit
