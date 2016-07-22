
var spinning.tool %1

goto spin

matches:
	matchre clean a dull shade from grime
	matchre turn twisting apart unevenly|threatens to unravel if not corrected
	matchre push slide down|bunch together
	matchre done You need a free hand|needs to have fibers placed on it
	matchre wait wait...
	matchre spin Roundtime
	matchwait

wait:
	pause
	goto %last

spin:
	var last spin
	pause 0.5
	put spin %spinning.tool
	goto matches

clean:
	var last clean
	pause 0.5
	put clean %spinning.tool
	goto matches

turn:
	var last turn
	pause 0.5
	put turn %spinning.tool
	goto matches

push:
	var last push
	pause 0.5
	put push %spinning.tool
	goto matches

done:
