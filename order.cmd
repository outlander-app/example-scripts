debuglevel 5

var count %1
var item %2
var stow.container $primary.container

var current_count 0

order:
	pause 0.5
	put order %item
	put order %item
	waitforre takes some coins
	math current_count add 1

	if ("$righthand" != "Empty" && "$lefthand" != "Empty") then
	{
		send combine
		waitforre You combine
	}

	if (%current_count < %count) then goto order
	goto done

done:
	put put my $lefthand in my %stow.container
	put #parse ORDER DONE
