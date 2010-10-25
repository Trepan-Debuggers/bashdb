# -*- shell-script -*-
# set.sh - debugger settings
#
#   Copyright (C) 2002,2003,2006,2007,2008,2010 Rocky Bernstein 
#   rocky@gnu.org
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
#   You should have received a copy of the GNU General Public License along
#   with this program; see the file COPYING.  If not, write to the Free Software
#   Foundation, 59 Temple Place, Suite 330, Boston, MA 02111 USA.

# Sets whether or not to display command to be executed in debugger prompt.
# If yes, always show. If auto, show only if the same line is to be run
# but the command is different.

typeset -i _Dbg_linewidth; _Dbg_linewidth=${COLUMNS:-80} 
typeset -i _Dbg_linetrace_expand=0 # expand variables in linetrace output
typeset -i _Dbg_linetrace_delay=0  # sleep after linetrace

typeset -i _Dbg_set_autoeval=0     # Evaluate unrecognized commands?
typeset -i _Dbg_listsize=10        # How many lines in a listing? 

# Sets whether or not to display command before executing it.
typeset _Dbg_set_trace_commands='off'

_Dbg_help_add set ''  # Help routine is elsewhere

# Load in "show" subcommands
for _Dbg_file in ${_Dbg_libdir}/command/set_sub/*.sh ; do 
    source $_Dbg_file
done

_Dbg_do_set() {
  typeset set_cmd=$1
  typeset rc
  if [[ $set_cmd == '' ]] ; then
    _Dbg_msg "Argument required (expression to compute)."
    return;
  fi
  shift
  case $set_cmd in 
      ar | arg | args )
	  # We use the loop below rather than _Dbg_set_args="(@)" because
	  # we want to preserve embedded blanks in the arguments.
	  _Dbg_script_args=()
	  typeset -i i
	  typeset -i n=$#
	  typeset -i m=${#_Dbg_orig_script_args[@]}
	  for (( i=0; i<n ; i++ )) ; do
	      _Dbg_write_journal_eval "_Dbg_orig_script_args[$i]=$1"
	      shift
	  done
	  for ((  ; i<m ; i++ )) ; do
	      _Dbg_write_journal_eval "unset _Dbg_orig_script_args[$i]"
	      shift
	  done
	  ;;
      an | ann | anno | annot | annota | annotat | annotate )
	  _Dbg_do_set_annotate $@
	  return $?
	  ;;
      autoe | autoev | autoeva | autoeval )
	  _Dbg_set_onoff "$1" 'autoeval'
	  return $?
	  ;;
      autol | autoli | autolis | autolist )
	  typeset onoff=${1:-'off'}
	  case $onoff in 
	      on | 1 ) 
		  _Dbg_write_journal_eval "_Dbg_cmdloop_hooks['list']=_Dbg_do_list"
		  ;;
	      off | 0 )
		  _Dbg_write_journal_eval "unset _Dbg_cmdloop_hooks['list']"
		  ;;
	      * )
		  _Dbg_msg "\"on\" or \"off\" expected."
		  return 1
	  esac
	  _Dbg_do_show 'autolist'
	  return 0
	  ;;
      b | ba | bas | base | basen | basena | basenam | basename )
	  _Dbg_set_onoff "$1" 'basename'
	  return $?
	  ;;
      de|deb|debu|debug|debugg|debugger|debuggi|debuggin|debugging )
	  _Dbg_set_onoff "$1" 'debugging'
	  return $?
	  ;;
      e | ed | edi | edit | editi | editin | editing )
	  _Dbg_do_set_editing "$1"
	  return $?
	  ;;
      force | dif | diff | differ | different )
	  _Dbg_set_onoff "$1" 'different'
	  return $?
	  ;;
      hi|his|hist|histo|histor|history)
	  _Dbg_do_set_history "$@"
	  return $?
	  ;;
      lin | line | linet | linetr | linetra | linetrac | linetrace )
	  typeset onoff=${1:-'off'}
	  case $onoff in 
	      on | 1 ) 
		  _Dbg_write_journal_eval "_Dbg_linetrace=1"
		  ;;
	      off | 0 )
		  _Dbg_write_journal_eval "_Dbg_linetrace=0"
		  ;;
	      d | de | del | dela | delay )
		  eval "$_seteglob"
		  if [[ $2 != $int_pat ]] ; then 
		      _Dbg_msg "Bad int parameter: $2"
		      eval "$_resteglob"
		      return 1
		  fi
		  eval "$_resteglob"
		  _Dbg_write_journal_eval "_Dbg_linetrace_delay=$2"
		  ;;
	      e | ex | exp | expa | expan | expand )
		  typeset onoff=${2:-'on'}
		  case $onoff in 
		      on | 1 ) 
			  _Dbg_write_journal_eval "_Dbg_linetrace_expand=1"
			  ;;
		      off | 0 )
			  _Dbg_write_journal_eval "_Dbg_linetrace_expand=0"
			  ;;
		      * )
			  _Dbg_msg "\"expand\", \"on\" or \"off\" expected."
			  ;;
		  esac
		  ;;
	      
	      * )
		  _Dbg_msg "\"expand\", \"on\" or \"off\" expected."
		  return 1
	  esac
	  return 0
	  ;;
      li | lis | list | lists | listsi | listsiz | listsize )
	  eval "$_seteglob"
	  if [[ $1 == $int_pat ]] ; then 
	      _Dbg_write_journal_eval "_Dbg_listsize=$1"
	  else
	      eval "$_resteglob"
	      _Dbg_msg "Integer argument expected; got: $1"
	      return 1
	  fi
	  eval "$_resteglob"
	  return 0
	  ;;
      lo | log | logg | loggi | loggin | logging )
	  _Dbg_cmd_set_logging $*
	  ;;
      p | pr | pro | prom | promp | prompt )
	  _Dbg_prompt_str="$1"
	  ;;
      sho|show|showc|showco|showcom|showcomm|showcomma|showcomman|showcommand )
	  case $1 in 
	      1 )
		  _Dbg_write_journal_eval "_Dbg_show_command=on"
		  ;;
	      0 )
		  _Dbg_write_journal_eval "_Dbg_show_command=off"
		  ;;
	      on | off | auto )
		  _Dbg_write_journal_eval "_Dbg_show_command=$1"
		  ;;
	      * )
		  _Dbg_msg "\"on\", \"off\" or \"auto\" expected."
	  esac
	  return 0
	  ;;
      t|tr|tra|trac|trace|trace-|trace-c|trace-co|trace-com|trace-comm|trace-comma|trace-comman|trace-command|trace-commands )
	  case $1 in 
	      1 )
		  _Dbg_write_journal_eval "_Dbg_set_trace_commands=on"
		  ;;
	      0 )
		  _Dbg_write_journal_eval "_Dbg_set_trace_commands=off"
		  ;;
	      on | off )
		  _Dbg_write_journal_eval "_Dbg_set_trace_commands=$1"
		  ;;
	      * )
		  _Dbg_msg "\"on\", \"off\" expected."
	  esac
	  return 0
	  ;;
      w | wi | wid | width )
	  if [[ $1 == $int_pat ]] ; then 
	      _Dbg_write_journal_eval "_Dbg_linewidth=$1"
	  else
	      _Dbg_msg "Integer argument expected; got: $1"
	      return 1
	  fi
	  return 0
	  ;;
      *)
	  _Dbg_undefined_cmd "set" "$set_cmd"
	  return 1
  esac
}
