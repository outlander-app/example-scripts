debug 5

var total 0
var session 0
var searches 0

action var session 0;var searches 0 when A surly Dwarf stomps in and glowers at you in the dim gloom
action math searches add 1 when You search around

if_1 goto waitSearch

waitMonkey:
  var last waitMonkey
  put #echo >log searches: %searches, session: %session, total: %total
  echo searches: %searches, session: %session, total: %total
  matchre search small monkey scurrying around the area|small monkey scurries
  matchwait

waitSearch:
  var last waitSearch
  put #echo >log searches: %searches, session: %session, total: %total
  matchre bloodscrip search around and find (\d+) bloodscrip
  matchwait

didSearch:
  goto waitSearch

bloodscrip:
  var found $1
  math session add %found
  math total add %found
  put redeem my bloodscrip
  goto %last

lost:
  put stand
  goto waitMonkey

search:
  matchre bloodscrip search around and find (\d+) bloodscrip
  matchre lost As you begin to search the area
  put search
  matchwait 5
  goto waitMonkey
