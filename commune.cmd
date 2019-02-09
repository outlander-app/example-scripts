var player $charactername
var lighter viper
var lighterStorage cassock

goto %1

Incense:
	put get my incense
	put get my %lighter
	pause 0.5
	put point my viper at my incense
	waitfor You quickly flick the switch on the back
	pause 0.5

Sheath:
	pause 0.5
	put put my %lighter in my %lighterStorage
	matchre WaveIncense you put
	matchre Sheath ...wait
	matchwait 3

WaveIncense:
	put wave my incense at %player

DouseIncense:
	pause 0.5
	put snuff my incense
	pause 0.5
	put stow incense
	waitforre You put|Stow what
	return

meraud:
	gosub incense
	pause 0.5
	put get my holy water
	put spri water on %player
	pause
	put stow my holy water
	put commune meraud
	pause 2
	send stand
	goto END

eluned:
	pause 0.5
	put get my chalice
	put forage dirt
	pause 3
	put commune eluned
	put get holy water
	pause
	put stow my holy water
	put stow my chalice
	waitfor You put
	goto END

END:
	put #parse COMMUNE DONE
