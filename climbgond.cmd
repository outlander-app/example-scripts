
WhereAmI:
	match Waterfall Behind the Waterfall
	match Log Tamarisk bushes display
	match Embankment Utter stillness
	match Branch [Obsidian Pass, Mountain Trail]
	put look
	matchwait

Waterfall:
	move go woodland
	move northeast
	move northeast
	move north
	move northeast
	move north
	move north

Log:
	move climb log
	move climb embankment

Embankment:
	move southwest
	move south
	move down
	move climb wall
	move climb ledge
	move climb nich
	move climb branch

Branch:
	move climb branch
	move climb nich
	move climb ledge
	move climb wall
	move up
	move north
	move northeast
	move climb emb
	move climb log
	move south
	move south
	move southwest
	move south
	move southwest
	move southwest
	move go cleft
Goto END

END:
put #parse CLIMB DONE
