
var item %1
var booklet worn book
var get.container sack
var store.container loots

get:
  put get my %item in my %get.container
  waitforre You get|You need a free hand
  put look my $righthandnoun

store:
  match dump you realize there's no more room
  matchre get you find room in a matching section|you copy in the spell
  match read is not labelled
  put push my %booklet with $righthandnoun
  matchwait

read:
  put read my $righthandnoun
  waitfor Roundtime
  goto store


dump:
  put put my $righthandnoun in my %store.container
  waitfor You put
  goto get