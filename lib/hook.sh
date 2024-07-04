# -*- shell-script -*-
# hook.sh - Debugger trap hook
#
#   Copyright (C) 2002-2011, 2014, 2017-2019
#   Rocky Bernstein <rocky@gnu.org>
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

typeset _Dbg_RESTART_COMMAND=''

# This is set to 1 if you want to debug debugger routines, i.e. routines
# which start _Dbg_. But you better should know what you are doing
# if you do this or else you may get into a recursive loop.
typeset -i _Dbg_set_debug=0       # 1 if we are debugging the debugger
typeset    _Dbg_stop_reason=''    # The reason we are in the debugger.

# Set to 0 to clear "trap DEBUG" after entry
typeset -i _Dbg_restore_debug_trap=1

# Are we inside the middle of a "skip" command? If so this gets copied
# to _Dbg_continue_rc which controls the return code from the trap.
typeset -i _Dbg_inside_skip=0

# If _Dbg_continue_rc is not less than 0, continue execution of the
# program. As specified by the shopt extdebug option. See extdebug of
# "The Shopt Builtin" in the bash info guide. The information
# summarized is:
#
# - A return code 2 is special and means return from a function or
#   "source" command immediately
#
# - A nonzero return indicate the next statement should not be run.
#   Typically we use 1 for that value.
# - A set return code 0 continues execution.
typeset -i _Dbg_continue_rc=-1

# Variable used to check whether BASH_REMATCH was previously set.
typeset -a _Dbg_bash_rematch=()

# If BASH_REMATCH is set then we'll use _Dbg_last_rematch_command to try
# to set to on exit of the hook. Note that this presumes that when
# the value of BASH_REMATCH was noticed to have changed it was because
# of the current bash command, which might not always be true.
typeset _Dbg_last_rematch_command=''

# ===================== FUNCTIONS =======================================

# We come here after before statement is run. This is the function named
# in trap SIGDEBUG.

# Note: We have to be careful here in naming "local" variables. In contrast
# to other places in the debugger, because of the read/eval loop, they are
# in fact seen by those using the debugger. So in contrast to other "local"s
# in the debugger, we prefer to preface these with _Dbg_.

_Dbg_debug_trap_handler() {

    ### The below is also copied below in _Dbg_sig_handler...
    ### Should put common stuff into a function.

    # Consider putting the following line(s) in a routine.
    # Ditto for the restore environment
    typeset -i _Dbg_debugged_exit_code=$?
    _Dbg_old_set_opts=$-
    set +e
    shopt nullglob > /dev/null
    typeset -i _Dbg_old_set_nullglob=$?
    shopt -u nullglob
    shopt -s extdebug

    # Turn off line and variable trace listing if were not in our own debug
    # mode, and set our own PS4 for debugging inside the debugger
    (( !_Dbg_set_debug )) && set +x +v +u

    # If we are in our own routines -- these start with _bashdb -- then
    # return.
    if [[ ${FUNCNAME[1]} == _Dbg_* ]] && ((  !_Dbg_set_debug )); then
	_Dbg_set_to_return_from_debugger 0
	return 0
    fi

    # Sets _Dbg_frame_last_lineno and _Dbg_frame_last_filename among
    # other things.
    _Dbg_set_debugger_entry

    ((_Dbg_continue_rc=_Dbg_inside_skip))

    # Shift off "RETURN";  we do not need that any more.
    shift

    # Check whether BASH_REMATCH is set and changed.
    if (( ${#BASH_REMATCH[@]} > 0 )) && [[ "${_Dbg_bash_rematch[@]}" != "${BASH_REMATCH[@]}" ]]; then
        # Save a copy of the command string to be able to run to restore read-only
	# variable BASH_REMATCH
	_Dbg_bash_rematch=${BASH_REMATCH[@]}
        _Dbg_last_rematch_args=( "$@" )
        _Dbg_last_rematch_command=$_Dbg_bash_command
        unset _Dbg_last_rematch_args[0]
    elif ((!${#BASH_REMATCH[@]} && ${#_Dbg_bash_rematch[@]})); then
        _Dbg_bash_rematch=()
        _Dbg_last_rematch_command=''
    fi

    _Dbg_bash_command=$1
    shift

    _Dbg_save_args "$@"

    # if in step mode, decrement counter
    if ((_Dbg_step_ignore > 0)) ; then
	((_Dbg_step_ignore--))
	_Dbg_write_journal "_Dbg_step_ignore=$_Dbg_step_ignore"
	# Can't return here because we may want to stop for another
	# reason.
    fi

    # look for watchpoints.
    typeset -i _Dbg_i
    for (( _Dbg_i=0; _Dbg_i < _Dbg_watch_max ; _Dbg_i++ )) ; do
	if [ -n "${_Dbg_watch_exp[$_Dbg_i]}" ] \
	    && [[ ${_Dbg_watch_enable[_Dbg_i]} != 0 ]] ; then
	    typeset _Dbg_new_val=$(_Dbg_get_watch_exp_eval $_Dbg_i)
	    typeset _Dbg_old_val=${_Dbg_watch_val[$_Dbg_i]}
	    if [[ $_Dbg_old_val != $_Dbg_new_val ]] ; then
		((_Dbg_watch_count[_Dbg_i]++))
		_Dbg_msg "Watchpoint $_Dbg_i: ${_Dbg_watch_exp[$_Dbg_i]} changed:"
		_Dbg_msg "  old value: '$_Dbg_old_val'"
		_Dbg_msg "  new value: '$_Dbg_new_val'"
		_Dbg_watch_val[$_Dbg_i]=$_Dbg_new_val
		_Dbg_hook_enter_debugger 'on a watch trigger'
		return $_Dbg_continue_rc
	    fi
	fi
    done

    typeset _Dbg_full_filename
    _Dbg_full_filename=$(_Dbg_is_file "$_Dbg_frame_last_filename")
    if [[ -r "$_Dbg_full_filename" ]] ; then
	_Dbg_file2canonic["$_Dbg_frame_last_filename"]="$_Dbg_full_filename"
    fi

    # Run applicable action statement
    if ((_Dbg_action_count > 0)) ; then
	_Dbg_hook_action_hit "$_Dbg_full_filename"
    fi

    # Determine if we stop or not.

    # Check breakpoints.
    if ((_Dbg_brkpt_count > 0)) ; then
	if _Dbg_hook_breakpoint_hit "$_Dbg_full_filename"; then
	    if ((_Dbg_step_force)) ; then
		typeset _Dbg_frame_previous_file="$_Dbg_frame_last_filename"
		typeset -i _Dbg_frame_previous_lineno="$_Dbg_frame_last_lineno"
	    fi
	    ## FIXME: should probably add this (from zshdb):
	    ## _Dbg_frame_save_frames 1
	    ((_Dbg_brkpt_counts[_Dbg_brkpt_num]++))
	    _Dbg_write_journal \
		"_Dbg_brkpt_counts[$_Dbg_brkpt_num]=${_Dbg_brkpt_counts[_Dbg_brkpt_num]}"
	    if (( _Dbg_brkpt_onetime[_Dbg_brkpt_num] == 1 )) ; then
		_Dbg_stop_reason='at a breakpoint that has since been deleted'
		_Dbg_delete_brkpt_entry $_Dbg_brkpt_num
	    else
	    _Dbg_msg \
              "Breakpoint $_Dbg_brkpt_num hit (${_Dbg_brkpt_counts[_Dbg_brkpt_num]} times)."
		_Dbg_stop_reason="at breakpoint $_Dbg_brkpt_num"
	    fi
	    # We're sneaky and check commands_end because start could
	    # legitimately be 0.
	    if (( _Dbg_brkpt_commands_end[$_Dbg_brkpt_num] )) ; then
		# Run any commands associated with this breakpoint
		_Dbg_bp_commands $_Dbg_brkpt_num
	    fi
	    _Dbg_hook_enter_debugger "$_Dbg_stop_reason"
	    _Dbg_set_to_return_from_debugger 1
	    return $_Dbg_continue_rc
	fi
    fi


    # Check if step mode and number steps to ignore.
    if ((_Dbg_step_ignore == 0)); then
	if ((_Dbg_step_force)) ; then
	    if (( _Dbg_last_lineno == _Dbg_frame_last_lineno )) \
		&& [[ $_Dbg_last_source_file == $_Dbg_frame_last_filename ]] ; then
		_Dbg_set_to_return_from_debugger 1
		return $_Dbg_continue_rc
	    fi
	fi

	_Dbg_hook_enter_debugger 'after being stepped'
	return $_Dbg_continue_rc
    elif (( ${#FUNCNAME[@]} == _Dbg_return_level )) ; then
	# here because a trap RETURN
	_Dbg_return_level=0
	_Dbg_hook_enter_debugger 'on a return'
	return $_Dbg_continue_rc
    elif (( -1 == _Dbg_return_level )) ; then
	# here because we are fielding a signal.
	_Dbg_hook_enter_debugger 'on fielding signal'
	return $_Dbg_continue_rc
    elif ((_Dbg_set_linetrace==1)) ; then
	if ((_Dbg_set_linetrace_delay)) ; then
	    sleep $_Dbg_linetrace_delay
	fi
	_Dbg_print_linetrace
	# FIXME: DRY code.
	_Dbg_set_to_return_from_debugger 1
	_Dbg_last_lineno=${BASH_LINENO[0]}
	return $_Dbg_continue_rc
    fi
    _Dbg_set_to_return_from_debugger 1
    return $_Dbg_continue_rc
}

_Dbg_hook_action_hit() {
    typeset _Dbg_full_filename="$1"
    typeset _Dbg_lineno=$_Dbg_frame_last_lineno

    # FIXME: combine with _Dbg_unset_action
    typeset -a _Dbg_linenos
    [[ -z "$_Dbg_full_filename" ]] && return 1
    eval "_Dbg_linenos=(${_Dbg_action_file2linenos["$_Dbg_full_filename"]})"
    typeset -a _Dbg_action_nos
    eval "_Dbg_action_nos=(${_Dbg_action_file2action["$_Dbg_full_filename"]})"

    typeset -i _Dbg_i
    # Check action within full_filename
    for ((_Dbg_i=0; _Dbg_i < ${#_Dbg_linenos[@]}; _Dbg_i++)); do
	if (( _Dbg_linenos[_Dbg_i] == _Dbg_lineno )) ; then
	    (( _Dbg_action_num = _Dbg_action_nos[_Dbg_i] ))
	    stmt="${_Dbg_action_stmt[$_Dbg_action_num]}"
  	    . "${_Dbg_libdir}/set-d-vars.sh"
  	    eval "$stmt"
	    # We've reset some variables like IFS and PS4 to make eval look
	    # like they were before debugger entry - so reset them now.
	    _Dbg_set_debugger_internal
	    return 0
	fi
    done
    return 1
}

# Return 0 if we are at a breakpoint position or 1 if not.
# Sets _Dbg_brkpt_num to the breakpoint number found.
_Dbg_hook_breakpoint_hit() {
    typeset _Dbg_full_filename="$1"
    typeset _Dbg_lineno=$_Dbg_frame_last_lineno

    # FIXME: combine with _Dbg_unset_brkpt
    typeset -a _Dbg_linenos
    [[ -z "$_Dbg_full_filename" ]] && return 1
    [[ -z "${_Dbg_brkpt_file2linenos["$_Dbg_full_filename"]}" ]] && return 1
    eval "_Dbg_linenos=(${_Dbg_brkpt_file2linenos["$_Dbg_full_filename"]})"
    typeset -a _Dbg_brkpt_nos
    eval "_Dbg_brkpt_nos=(${_Dbg_brkpt_file2brkpt["$_Dbg_full_filename"]})"
    typeset -i _Dbg_i
    # Check breakpoints within full_filename
    for ((_Dbg_i=0; _Dbg_i < ${#_Dbg_linenos[@]}; _Dbg_i++)); do
	if (( _Dbg_linenos[_Dbg_i] == _Dbg_lineno )) ; then
	    # Got a match, but is the breakpoint enabled and condition met?
	    (( _Dbg_brkpt_num = _Dbg_brkpt_nos[_Dbg_i] ))
        if ((_Dbg_brkpt_enable[_Dbg_brkpt_num] )); then

            if ( eval "((${_Dbg_brkpt_cond[_Dbg_brkpt_num]}))" || eval "${_Dbg_brkpt_cond[_Dbg_brkpt_num]}" ) 2>/dev/null; then
                return 0
            else
                _Dbg_msg "Breakpoint: evaluation of '${_Dbg_brkpt_cond[_Dbg_brkpt_num]}' returned false."
            fi

	    fi
	fi
    done
    return 1
}

# Go into the command loop
_Dbg_hook_enter_debugger() {
    _Dbg_stop_reason="$1"
    [[ 'noprint' != $2 ]] && _Dbg_print_location_and_command
    _Dbg_process_commands
    _Dbg_set_to_return_from_debugger 1
    # Try to Persist the user-space value of BASH_REMATCH in debugged
    # program using _Dbg_last_rematch_command.  Executing the debug
    # hook annihilated it.  Note this might fail is we didn't capture
    # _Dbg_last_rematch_command properly.
    if (( ${#_Dbg_bash_rematch[@]} > 0 )); then
	# FIXME generalize this and put in a library for eval.
	set -- "${_Dbg_last_rematch_args[@]}"
	eval $_Dbg_last_rematch_command
    elif (( ${#BASH_REMATCH[@]} > 0 )) ; then
	# Set BASH_REMATCH to ()
	[[ 'this' =~ 'that' ]]
    fi
    return $_Dbg_continue_rc
}

# Cleanup routine: erase temp files before exiting.
_Dbg_cleanup() {
    [[ -f "$_Dbg_evalfile" ]] && rm -f "$_Dbg_evalfile" 2>/dev/null
    set +u
    if [[ -n "$_Dbg_EXECUTION_STRING" ]] && [[ -r "$_Dbg_script_file" ]] ; then
	rm "$_Dbg_script_file"
    fi
    _Dbg_erase_journals
    _Dbg_restore_user_vars
}

# Somehow we can't put this in _Dbg_cleanup and have it work.
# I am not sure why.
_Dbg_cleanup2() {
    [[ -f "$_Dbg_evalfile" ]] && rm -f "$_Dbg_evalfile" 2>/dev/null
    _Dbg_erase_journals
    trap - EXIT
}
