set trace-commands on
# Test of debugger 'list' command
#
### List default location
list
### Should list next set of lines
l
#
# Should not see anything since we ran off the top
#
list 999
#########################################################
### 'list file:line' and canonicalization of filenames...
load ../example//dbg-test1.sh
list ../example//dbg-test1.sh:1
list ../example/dbg-test1.sh:20
list ../example/dbg-test1.sh:30
list ../example//dbg-test1.sh:999
load ./badfile
#########################################################
set trace-commands on
### list of functions...
list fn1
list bogus
#########################################################
###  Testing '.'
l .
#
# Should see lines up to current execution line.
###  Trying '-'...
l -
###  Testing set/show listsize
show listsize
###  Setting listsize to 3...
set listsize 3
l 10
###  Setting listsize to 4...
set listsize 4
show listsize
l 10
quit
