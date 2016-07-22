
var repairman %1
var container $primary.container

var craft.items stamp|needles|scissors|yardstick|slickstone|awl|hide scraper|saw|rifflers|rasp|chisels|shovel|ball-peen hammer|tongs|stirring rod
var items.to.stow %craft.items
var items.to.wear helm|balaclava|gloves|robe|targe|vambraces|mask|hood

if_2 then goto %2

saracus.craft.items:

  gosub give.repair stamp

  gosub give.repair needles
  gosub give.repair scissors
  gosub give.repair yardstick
  gosub give.repair slickstone
  gosub give.repair awl
  gosub give.repair hide scraper

  gosub give.repair bone.saw
  gosub give.repair rifflers
  gosub give.repair rasp
  gosub give.repair chisels

  gosub give.repair forging.hammer
  gosub give.repair tongs
  gosub give.repair stir.rod
  gosub give.repair shovel

  goto done

saracus.combat.items:
  gosub give.repair robe
  gosub give.repair ring.gloves
  gosub give.repair brig.gloves
  gosub give.repair vambraces
  gosub give.repair balaclava
  gosub give.repair helm
  gosub give.repair parry.stick

  gosub give.repair haralun.axe
  gosub give.repair throwing.axe
  gosub give.repair mirror.blade

  gosub give.repair mace
  gosub give.repair throwing.hammer
  gosub give.repair spear
  gosub give.repair nightstick
  gosub give.repair maul
  gosub give.repair greataxe

  goto done

tanon.combat.items:
  gosub give.repair gloves
  gosub give.repair hood
  gosub give.repair mask
  gosub give.repair shield
  gosub give.repair parry.stick

  gosub give.repair mace
  gosub give.repair scimitar

  goto done

tanon.craft.items:
  gosub give.repair ball-peen.hammer
  gosub give.repair tongs
  gosub give.repair stir.rod
  gosub give.repair shovel
  goto done

dumas.craft.items:
  gosub give.repair serr.saw
  gosub give.repair rifflers
  gosub give.repair rasp

  gosub give.repair forging.hammer
  gosub give.repair tongs
  gosub give.repair stir.rod
  gosub give.repair shovel


  gosub give.repair needles
  gosub give.repair scissors
  gosub give.repair yardstick
  gosub give.repair slickstone
  gosub give.repair awl

  goto done

dumas.combat.items:
  gosub give.repair brig.gloves
  gosub give.repair mail.balaclava
  gosub give.repair ring.vambraces
  gosub give.repair robe
  gosub give.repair targe
  gosub give.repair parry.stick

  gosub give.repair gladius
  gosub give.repair falchion
  gosub give.repair mace
  gosub give.repair flail
  gosub give.repair telek
  gosub give.repair throwing.axe
  gosub give.repair throwing.hammer
  gosub give.repair nightstick
  gosub give.repair mattock
  gosub give.repair greataxe
  gosub give.repair spear
  gosub give.repair club

  goto done
  
give.repair:
  var item $0

  wield.item:
    matchre give.item You get|You slip|You are already holding
    matchre hold.item already in your inventory
    matchre untie.item the ties prevent you|have to untie
    matchre get.item You can only wield a weapon or a shield|What were you|Wield what?
    put wield my %item
    matchwait

  get.item:
    matchre give.item You get|You slip|You are already holding
    matchre hold.item already in your inventory
    matchre untie.item the ties prevent you
    matchre return What were you
    put get my %item
    matchwait

  untie.item:
    put untie my %item
    goto give.item

  hold.item:
    put hold %item
    goto give.item

  stow.item:
    pause 1
    if matchre("$righthand", "%items.to.stow") then put put my %item in my %container
    if matchre("$lefthand", "%items.to.stow") then put put my %item in my %container
    pause 0.5
    if matchre("$righthand", "%items.to.wear") then put wear my %item
    if matchre("$lefthand", "%items.to.wear") then put wear my %item
    pause 0.5
    if "$righthand" != "Empty" then put sheath right
    if "$lefthand" != "Empty" then put sheath left
    pause 0.5
    if "$righthand" != "Empty" then put stow right
    if "$lefthand" != "Empty" then put stow left
    return

  give.item:
    pause 0.5
    matchre stow.item There isn't a scratch on that|I don't work on those here|I will not repair something
    matchre give.item That will cost
    matchre stow.ticket You hand
    put give my %item to %repairman
    matchwait 5
    goto stow.item

  stow.ticket:
    put stow ticket
    return

return:
  return

done:
  put #parse GIVE-REPAIR DONE