#!/usr/bin/env bash
# -*- shell-script -*-
# gdb-like "info args" debugger command
#
#   Copyright (C) 2010-2011, 2016 Rocky Bernstein <rocky@gnu.org>
#
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation; either version 2, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#   General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; see the file COPYING.  If not, write to
#   the Free Software Foundation, 59 Temple Place, Suite 330, Boston,
#   MA 02111 USA.

# Print info args. Like GDB's "info args"
# $1 is an additional offset correction - this routine is called from two
# different places and one routine has one more additional call on top.
# This code assumes the's debugger version of
# bash where FUNCNAME is an array, not a variable.

if [[ $0 == ${BASH_SOURCE[0]} ]]; then
  dirname=${BASH_SOURCE[0]%/*}
  [[ $dirname == $0 ]] && top_dir='../..' || top_dir=${dirname}/../..
  source "${top_dir}/lib/help.sh"
fi

_Dbg_help_add_sub info args_bsp \
  "**info args_bsp** [*frame-num*]

Show argument variables of the current stack frame,
falling back to script arguments if it's the first frame of the debugged script.

The default value is 0, the most recent frame.
If the selected frame is at top-level, then the script arguments are printed.

See also:
---------

**backtrace**." 1

_Dbg_do_info_args_bsp() {
  typeset -r frame_start="${1:-0}"

  eval "$_Dbg_seteglob"
  if [[ $frame_start != $_Dbg_int_pat ]]; then
    _Dbg_errmsg "Bad integer parameter: $frame_start"
    eval "$_Dbg_resteglob"
    return 1
  fi

  typeset -i i="$frame_start"
  ((i >= _Dbg_stack_size - 1)) && return 1

  # Figure out which index in BASH_ARGV is position "i" (the place where
  # we start our stack trace from). variable "r" will be that place.

  typeset -i adjusted_pos
  adjusted_pos=$(_Dbg_frame_adjusted_pos "$frame_start")
  typeset -i arg_count=${BASH_ARGC[$adjusted_pos]}

  # If at top-level, print script arguments, 2 because of "main" and the ". debuggee.sh" of bashdb
  if ((i == 0 && (${#BASH_ARGC[@]} - adjusted_pos) == 2)); then
    typeset -i n="${#_Dbg_script_args[@]}"
    typeset -i s
    for ((s = 1; s < n; s++)); do
      _Dbg_printf "$%d = %s" "$s" "${_Dbg_script_args[s]}"
    done
    return 0
  fi

  # Print out parameter list.
  if ((0 != ${#BASH_ARGC[@]})); then
    typeset -i q
    typeset -i r=0
    for ((q = 0; q <= adjusted_pos; q++)); do
      ((r = r + ${BASH_ARGC[$q]}))
    done
    ((r--))

    if ((arg_count == 0)); then
      _Dbg_msg "Argument count is 0 for this call."
    else
      typeset -i s
      for ((s = 1; s <= arg_count; s++)); do
        _Dbg_printf "$%d = %s" $s "${BASH_ARGV[$r]}"
        ((r--))
      done
    fi
  fi
  return 0
}
