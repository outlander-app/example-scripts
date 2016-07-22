
var item %0
var container $primary.container
var deed.container $deed.container

start:
	put get my packet

get.item:
	pause 0.5
	put get my %item in my %container
	matchre end What were you
	matchre deed.item You get
	matchwait 2
	goto end

deed.item:
	pause 0.5
	put push my %item with my packet
	goto stow.item

stow.item:
	matchre get.item You put your deed
	matchre switch.to.primary no matter how you arrange it
	put put my deed in my %deed.container
	matchwait

switch.to.primary:
	var deed.container %container
	goto stow.item

end:
	put stow my packet
	put #parse DEED DONE
