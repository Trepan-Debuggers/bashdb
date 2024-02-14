#!/usr/bin/env bash
# Bug is that file cache highlight isn't updated when
# it is already cached so it continues to refer to a line in the source'd file
# rather than file it was source'd from (here it is this file).
dirname=${BASH_SOURCE%/*}   # equivalent to dirname($0)
source ${dirname}/library.sh
echo 'script line 7'
library-function
# Should show the line below in highlight mode and not a from
# library-function
echo 'script line 11'
#
