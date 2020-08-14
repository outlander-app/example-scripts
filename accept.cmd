debuglevel 5

var person %1
var container $primary.container

wait_for_give:
  waitforre %person offers you
  put accept
  waitfor You accept
  put put my $righthandnoun in my %container
  goto wait_for_give