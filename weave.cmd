debug 5

var spinning.tool %1

if_2 goto %2

goto weave

matches:
	matchre clean dust and debris obstructing
	matchre turn bunch together|bunching up from excessive tension
	matchre push pushing together
	matchre done The loom needs to have 2 sections of thread
	matchre weave Roundtime
	matchwait 3
	goto doit

weave:
	var type weave
	goto doit

clean:
	var type clean
	goto doit

turn:
	var type turn
	goto doit

push:
	var type push
	goto doit

something:
	echo
	echo What to do!?
	echo
	pause 12
	goto done

doit:
	pause 0.5
	put %type %spinning.tool
	goto matches

done:

#A slight whoosh accompanies your raising the loom's heddles to form a shed.  The loom's shuttle zips across the shed of warp threads and the weft battens together evenly along the edge.

#The thread upon the shuttle is bunching up from excessive tension.
