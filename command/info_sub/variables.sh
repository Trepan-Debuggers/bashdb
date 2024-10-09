# -*- shell-script -*-
# "info variables" debugger command
#
#   Copyright (C) 2010, 2014, 2016, 2019 Rocky Bernstein rocky@gnu.org
#
#   bashdb is free software; you can redistribute it and/or modify it under
#   the terms of the GNU General Public License as published by the Free
#   Software Foundation; either version 2, or (at your option) any later
#   version.
#
#   bashdb is distributed in the hope that it will be useful, but WITHOUT ANY
#   WARRANTY; without even the implied warranty of MERCHANTABILITY or
#   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#   for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with bashdb; see the file COPYING.  If not, write to the Free Software
#   Foundation, 59 Temple Place, Suite 330, Boston, MA 02111 USA.

# V [![pat]] List variables and values for whose variables names which
# match pat $1. If ! is used, list variables that *don't* match.
# If pat ($1) is omitted, use * (everything) for the pattern.

_Dbg_help_add_sub info variables '
**info variables**

*info* *variables* [*-i*|*--integer*][*-r*|*--readonly*]*[-x*|*--exports*][*-a*|*--indexed*][*-A*|*--associative*][*-t*|*--trace*][*-p*|*--properties*]

Show global and static variable names.

Options:

    -i | --exports restricted to integer variables
    -r | --readonly restricted to read-only variables
    -x | --exports restricted to exported variables
    -a | --indexed restricted to indexed array variables
    -A | --associative restricted to associative array variables
    -t | --trace restricted to traced variables
    -p | --properties display properties of variables as printed by declare -p

If multiple flags are given, variables matching *any* of the flags are included.
Note. Bashdb debugger variables, those that start with \`_Dbg_\` are excluded.

Examples:
---------

    info variables       # show all variables
    info variables -r    # show only read-only variables
    info variables -r -i # show either read-only variables, or integer variables

See also:
---------

*info* *functions*.

' 1

if ! typeset -F getopts_long >/dev/null 2>&1; then
    # shellcheck source=./../../getopts_long.sh
    . "${_Dbg_libdir}/getopts_long.sh"
fi

function _Dbg_do_info_variables() {
    declare _Dbg_typeset_flags=""
    # 0: print variables with flags
    # 1: filter by flags in $_Dbg_typeset_flags and don't print flags
    declare -i _Dbg_typeset_filtered=1
    _Dbg_info_variables_parse_options "$@"
    (($? != 0)) && return

    # Caveats:
    #   Bash < 5.2: 'declare -p' does not escape special characters within $'', but only 'declare' does
    #   "declare -p" outputs variables without values, but "declare" does not
    #
    # We're collecting all variables and values from 'declare'.
    # Because a plain "declare" also prints functions we're only iterating until the first function definition was found.
    #
    # Then we run declare with the filter parameters (-p, -i, etc.) to retrieve the variables to output.

    # create an associative array of all available variables with bash-escaped values
    declare _Dbg_var_line
    declare -A _Dbg_var_values=()
    while IFS=$'\n' read -r _Dbg_var_line; do
        # skip _Dbg variables
        if [[ $_Dbg_var_line =~ ^_Dbg_ ]]; then continue; fi

        # break when first function was found
        if [[ $_Dbg_var_line =~ ^[^=\ ]+\ \(\)$ || $_Dbg_var_line =~ ^\{ ]]; then
            break
        fi

        # record escaped key-value pair, allow for empty values as in "-- name="
        if [[ $_Dbg_var_line =~ ^([^=]+)=(.*)$ ]]; then
            _Dbg_var_values["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
        fi
    done < <(declare)

    declare _Dbg_var_flags _Dbg_var_name
    if [[ $_Dbg_typeset_filtered -eq 0 ]]; then
        # run "declare -p" and print flags, name and value
        while IFS=$'\n' read -r _Dbg_var_line; do
            if [[ $_Dbg_var_line =~ ^(declare|local)\ (-[^\ ]+)\ ([^=]+)= ]]; then
                _Dbg_var_name="${BASH_REMATCH[3]}"
                if [[ -n ${_Dbg_var_values["$_Dbg_var_name"]+x} ]]; then
                  _Dbg_msg_verbatim "${BASH_REMATCH[2]} $_Dbg_var_name=${_Dbg_var_values["$_Dbg_var_name"]}"
                fi
            elif [[ $_Dbg_var_line =~ ^(declare|local)\ (-[^\ ]+)\ ([^=]+) ]]; then
                # no value, only print flags and name
                _Dbg_var_name="${BASH_REMATCH[3]}"
                if [[ -n ${_Dbg_var_values["$_Dbg_var_name"]+x} ]]; then
                  _Dbg_msg_verbatim "${BASH_REMATCH[2]} $_Dbg_var_name"
                fi
            fi
        done < <(declare -p)
    elif [[ -n "$_Dbg_typeset_flags" ]]; then
        # run "declare $_Dbg_typeset_flags" and print name and value
        while IFS=$'\n' read -r _Dbg_var_line; do
            if [[ $_Dbg_var_line =~ ^(declare|local)\ (-[^\ ]+)\ ([^=]+)= ]]; then
                _Dbg_var_name="${BASH_REMATCH[3]}"
                if [[ -n ${_Dbg_var_values["$_Dbg_var_name"]+x} ]]; then
                    _Dbg_msg_verbatim "$_Dbg_var_name=${_Dbg_var_values["$_Dbg_var_name"]}"
                fi
            fi
        done < <(declare $_Dbg_typeset_flags)
    else
        # for a plain "declare" just print available name=value pairs to avoid calling "declare",
        # which would output function declarations
        for _Dbg_var_name in "${!_Dbg_var_values[@]}"; do
            if [[ -n ${_Dbg_var_values["$_Dbg_var_name"]+x} ]]; then
              _Dbg_msg_verbatim "$_Dbg_var_name=${_Dbg_var_values["$_Dbg_var_name"]}"
            fi
        done
    fi
}

# Parse flags passed to the "info variables" command.
# The caller should declare _Dbg_typeset_flags and _Dbg_typeset_filtered before calling,
# which are implicitly returned values.
function _Dbg_info_variables_parse_options {
    _Dbg_typeset_flags=""
    _Dbg_typeset_filtered=1

    typeset -i _Dbg_rc=0
    typeset OPTLIND=''
    typeset opt
    while getopts_long irxaAtp opt \
        integer no_argument \
        readonly no_argument \
        exports no_argument \
        indexed no_argument \
        associative no_argument \
        trace no_argument \
        properties no_argument \
        '' "$@"; do
        case "$opt" in
        i | integer)
            _Dbg_typeset_flags="-i $_Dbg_typeset_flags"
            ;;
        r | readonly)
            _Dbg_typeset_flags="-r $_Dbg_typeset_flags"
            ;;
        x | exports)
            _Dbg_typeset_flags="-x $_Dbg_typeset_flags"
            ;;
        a | indexed)
            _Dbg_typeset_flags="-a $_Dbg_typeset_flags"
            ;;
        A | associative)
            _Dbg_typeset_flags="-A $_Dbg_typeset_flags"
            ;;
        t | trace)
            _Dbg_typeset_flags="-t $_Dbg_typeset_flags"
            ;;
        p | properties)
            _Dbg_typeset_filtered=0
            ;;
        *)
            _Dbg_errmsg "Invalid argument in $*; use only -x, -i, -r, -a, -A, -t, or -p"
            _Dbg_rc=1
            ;;
        esac
    done
    return $_Dbg_rc
}
