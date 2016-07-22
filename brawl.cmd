#[Combat]:  Brawl moves

Parry:
  matchre Circle Roundtime|You are already
  matchre Parry wait
  put parry
  matchwait

Circle:
  match Weave Roundtime
  match Circle wait
  pause 1
  put circle
  matchwait

Weave:
  match Bob Roundtime
  match Weave wait
  pause 1
  put weave
  matchwait

Bob:
  match Parry Roundtime
  match Bob wait
  pause 1
  put bob
  matchwait

END:
put .idle
