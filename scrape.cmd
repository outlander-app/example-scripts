#[Skills]:  Scraping Skins and Hides

var item %1
var speed %2

put get my scraper in my backpack

GETSKIN:
  pause 1
  matchre SCRAPE You get|You carefully
  matchre SCRAPE You need|You are already|You pick
  matchre END I could not find|What were you referring to
  put get my %item in bundle
  matchwait


SCRAPE:
  match WAIT ...
  matchre %3 has been completely cleaned | clean as you can make
  match %3 beyond repair
  matchre SCRAPE You scrape your|You carefully scrape your|You quickly scrape your
  put scrape $lefthandnoun with scraper %speed
  matchwait


WAIT:
  pause 1
  goto SCRAPE

lootsack:
  put put my %item in my lootsack
  goto GETSKIN

backpack:
  put put my %item in my backpack
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