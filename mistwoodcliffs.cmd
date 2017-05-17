#
# mistwoodcliff.cmd - version 0.5
# unabashedly stolen from the GenieMaps scripts
# https://svn.code.sf.net/p/geniemapsfordr/Genie3Maps/trunk
# Requires Outlander 0.11.4 or higher
# fixed up for Outlander ~ SAUVA(Hanryu) - 5/17/17
#debug 5
action var Dir $1 when ^Peering closely at a faint path, you realize you would need to head (\w+)\.$
put peer path
waitforre Peering closely at
move down
move %Dir
put nw
#waitforre ^Birds chitter in the branches
put #parse MOVE SUCCESSFUL