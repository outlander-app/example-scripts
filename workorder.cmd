#debug 5

var person %1
var toughness %2
var type %3
var item %4
var material %5

Ask:
  pause 0.2
	matchre Done %material (.*)?%item
	matchre Ask You seem to recall
	put ask %person for %toughness %type work
	matchwait 4
	goto Ask

Done:
	put #parse HAVE WORKORDER
