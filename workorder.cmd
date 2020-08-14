#debug 5

var person %1
var toughness %2
var type %3
var item %4
var material %5

Ask:
  pause 0.2
    matchre Done %material (.*)?%item
    matchre Untie You realize you have items bundled with the logbook
    matchre Ask You seem to recall
    put ask %person for %toughness %type work
    matchwait 4
    goto Ask

Untie:
    put #parse UNTIE WORKORDER

Done:
    put #parse HAVE WORKORDER
