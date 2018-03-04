# debuglevel 5

var wait_mana OFF

action var wait_mana OFF;goto start; when ^WAITING MANA-DONE$
action var wait_mana ON;goto start; when ^WAITING MANA$
action goto advance when ^You must be closer to use tactical abilities on your opponent

start:

	if ($stamina <=70) then
	{
		waiteval $stamina >= 90
	}

	if ("%wait_mana" = "OFF") then
	{
		waitforre You begin to weave mana lines into a target pattern|You begin chanting|With tense movements you prepare|You begin to target
	}

Weave:
	pause
	put weave
	matchre Circle You weave
	matchwait 3

Circle:
	matchre start You fake|You hesitate|You step|You side
	put circle
	matchwait 3

	goto start

advance:
	matchre start You close to melee range|closes to melee range on you
	send advance
	matchwait 5
	goto start
