#debug 5

var container $deed.container
var container2 $primary.container
var second_container NO

put stow left

var item %1

get:
	match bundle You get
	match get.deed What were you referring to?
	put get my %item in my %container
	matchwait 10
	goto notenough

get.deed:
	match bundle You get
	match notenough What were you referring to?
	put get my %item.deed in my %container
	matchwait 10
	goto notenough

bundle:
	match get You notate
	matchre stow You have already|not tracking any work orders
	matchre drop The work order requires items of a higher quality
	matchre nomatch isn't the correct type of item for this work order
	put bundle my $lefthand with my logbook
	matchwait

nomatch:
	echo
	echo ####  Item does not match order ####
	echo
	goto done

drop:
	put drop my $lefthand
	goto get

stow:
	put put my $lefthand in my %container
	goto done

notenough:
	echo
	echo ####  Not Enough ####
	echo
	goto done

done:
	put #parse BUNDLE DONE
