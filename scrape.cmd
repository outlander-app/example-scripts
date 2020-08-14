#[Skills]:  Scraping Skins and Hides

var item %1
var speed normal
var store_container $secondary.container

put get my scraper

GETSKIN:
  pause 1
  matchre SCRAPE You get|You carefully
  matchre SCRAPE You need|You are already|You pick
  matchre END I could not find|What were you referring to
  put get my %item in bundle
  matchwait


SCRAPE:
  match WAIT ...
  matchre store_item has been completely cleaned|clean as you can make
  match store_item beyond repair
  matchre SCRAPE You scrape your|You carefully scrape your|You quickly scrape your
  put scrape $lefthandnoun with scraper %speed
  matchwait


WAIT:
  pause 1
  goto SCRAPE

store_item:
  put put my %item in my %store_container
  goto GETSKIN

HELP:

END:
  put stow my scraper
  pause 1
  echo ////////////////////////////////////////////////
  echo / Scraping Finished!  You have no more %item 's. /
  echo ////////////////////////////////////////////////
  exit

ENDLocked:
  pause 1
  put stow scraper
  pause 1
  put hide
  echo
  echo **********************
  echo ** Skinning locked! **
  echo **********************
  echo
  exit