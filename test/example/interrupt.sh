#!/bin/bash
# $Id: interrupt.sh,v 1.14 2008/09/06 14:17:43 rockyb Exp $

if test -z "$srcdir"  ; then
  srcdir=`pwd`
fi

if [[ linux-gnu == cygwin ]] ; then
   cat ${srcdir}/interrupt.right
   exit 77
fi

# Make sure ../.. has a trailing slash
if [ '../..' = '' ] ; then
  echo "Something is wrong top_builddir is not set."
 exit 1
fi
top_builddir=../..
top_builddir=${top_builddir%%/}/
source ${top_builddir}bashdb-trace -q -B -L ../..

## FIXME
## _Dbg_handler INT
## echo "print: " ${_Dbg_sig_print[2]}
## echo "stop: " ${_Dbg_sig_stop[2]}

BASHDB_QUIT_ON_QUIT=1
for i in `seq 100` ; do
   touch $1
   sleep 5
done
