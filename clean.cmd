
var instrument %1
var cloth $instrument.cloth
var clothContainer $instrument.cloth.container

put stop play

get:
  pause 0.5
  put remove my %instrument
  waitforre You slide|You aren't wearing that
  goto get.cloth

get.cloth:
  put get my %cloth in my %clothContainer
  pause 0.5
  goto shake

shake:
  pause 0.5
  matchre shake Roundtime
  matchre clean You shake
  put shake my %instrument
  matchwait 3
  goto shake

clean:
  pause 0.5
  matchre clean Roundtime
  matchre done not in need of cleaning|with what
  matchre get.cloth You need to be holding the cloth
  put clean my %instrument with my %cloth
  matchwait 3
  goto clean

done:
  pause 0.5
  put put my %cloth in my %clothContainer
  put wear my %instrument
  waitforre You slide
  put #parse CLEAN DONE
