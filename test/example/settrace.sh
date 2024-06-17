#!/bin/bash
# Towers of Hanoi
set -u

init() {
  _Dbg_debugger; :
}

hanoi() { 
  typeset -i n=$1
  typeset -r a=$2
  typeset -r b=$3
  typeset -r c=$4

  _Dbg_set_trace
  if (( n > 0 )) ; then
    (( n-- ))
    hanoi $n $a $c $b
    ((disc_num=max-n))
    echo "Move disk $n on $a to $b"
    if (( n > 0 )) ; then
       hanoi $n $c $b $a
    fi
  fi
}

if (( $# > 0 )) ; then
  top_builddir=$1
elif [[ -z ${top_builddir:-''} ]] ; then
  top_builddir=$PWD/../..
fi

if (( $# > 1 )); then
  cmdfile=$2
else
  srcdir=${top_srcdir:-'.'}
  cmdfile=${top_srcdir}/test/data/settrace.cmd
fi

source ${top_builddir}/bashdb-trace -q --no-init --no-highlight -L $top_srcdir -B  -x $cmdfile
typeset -i max=1
init
hanoi $max 'a' 'b' 'c'
_Dbg_debugger 1 _Dbg_do_quit
