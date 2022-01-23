#debug 5
#trigger {^(\w+) slowly rises above the horizon\.$} {#var $1_offset $gametime|zero|above|eastern;#send .moons}
#trigger {^(\w+) sets, slowly dropping below the horizon\.$} {#var $1_offset $gametime|one|below|western;#send .moons}
# Stolen from Seldaren

# This is used in degree_parse
var numbers "zero-0 one-1 two-2 three-3 four-4 five-5 six-6 seven-7 eight-8 nine-9 ten-10 eleven-11 twelve-12 thirteen-13 fourteen-14 fifteen-15 sixteen-16 seventeen-17 eighteen-18 nineteen-19 twenty-20 thirty-30 forty-40 fifty-50 sixty-60 seventy-70 eighty-80 ninety-90"

# This is the frequency of skipped degrees, expressed as (minutes)/(skipped degrees).
var Xibar_skip_frequency 27.7
var Yavash_skip_frequency 44.8
var Katamba_skip_frequency 41.3

var moon Xibar
gosub moon_check

var moon Yavash
gosub moon_check

var moon Katamba
gosub moon_check
put #parse ** MOONS DONE **
exit

#####

moon_check:
	if !matchre("$%moon_offset","(?:eastern|western)") then {
		echo I have no data on %moon.  Perceive it or wait for a rise/set.
		return
	}

	gosub degree_parse

	if $%moon_offset(2) = above && $%moon_offset(3) = eastern then {
		# The moon was in the first quadrant, so no adjustment needed for the degrees.
	}

	if $%moon_offset(2) = above && $%moon_offset(3) = western then {
		# The moon was in the second quadrant, so replace degrees with 180 - degrees.
		math degrees subtract 180
		math degrees multiply -1
	}

	if $%moon_offset(2) = below && $%moon_offset(3) = western then {
		# The moon was in the third quadrant, so replace degrees with degrees + 180.
		math degrees add 180
	}

	if $%moon_offset(2) = below && $%moon_offset(3) = eastern then {
		# The moon was in the fourth quadrant, so replace degrees with 360 - degrees.
		math degrees subtract 360
		math degrees multiply -1
	}

	# Calculate how long it's been since the data point, in minutes, rounding down
	var offset_time $%moon_offset(0)
	var seconds $gametime
	math seconds subtract %offset_time

	var minutes %seconds
	math minutes divide 60
	if matchre("%minutes","(\d+)\.") then {
		var minutes $1
	}

	# Advance the moon by one degree per minute
	math degrees add %minutes

	# The moon skips one degree every %%moon_skip_frequency minutes, so account for that.
	var skipped_count %minutes
	var skip_frequency %%moon_skip_frequency
	math skipped_count divide %skip_frequency
	if matchre("%skipped_count","(\d+)\.") then {
		var skipped_count $1
	}
	math degrees add %skipped_count

	# Mod by 360
	math degrees modulus 360

	# The next rise/set will be at the next multiple of 180
	# So calculate 180 - (degrees mod 180)
	var next_change %degrees
	math next_change modulus 180
	math next_change subtract 180
	math next_change multiply -1

	# Account for the skipped degrees:
	var change_correction %next_change
	math change_correction divide %skip_frequency
	if matchre("%change_correction","(\d+)\.") then {
		var change_correction $1
	}
	math next_change subtract %change_correction

	# Degrees from 0 to 179 mean the moon is up.  Otherwise, it's down.
	if %degrees < 180 then {
		put #var %moon %next_change
		put #echo >log %moon UP, set in %next_changem
	} else {
		put #var %moon -%next_change
		put #echo >log %moon DOWN, rise in %next_changem
	}

	return


#####

# converts the degrees from a written number to a numerical number
degree_parse:
	var first_number $%moon_offset(1)
	var second_number zero
	if matchre("%first_number","(\w+)-(\w+)") then {
		var first_number $1
		var second_number $2
	}

	if matchre("%numbers","%first_number-(\d+)") then {
		var degrees $1
	} else {
		echo Error parsing %first_number degrees for %moon
	}

	if matchre("%numbers","%second_number-(\d+)") then {
		math degrees add $1
	} else {
		echo Error parsing %second_number degrees for %moon
	}

	return