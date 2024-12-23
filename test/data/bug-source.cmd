set trace-commands on
# Test to see that we read in files that mentioned in breakpoints
# but we don't step into.
continue 34
# It is important to "next" rather than "step"
next
load ../example/dbg-test1.sub
break sourced_fn
info files
quit
