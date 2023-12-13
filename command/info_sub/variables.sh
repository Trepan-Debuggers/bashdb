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

function _Dbg_do_info_variables {
    declare _Dbg_typeset_flags=""
    declare -i _Dbg_typeset_filtered=1
    _Dbg_info_variables_parse_options "$@"
    (($? != 0)) && return

    # Create an indexed array of variable names which are matching our input flags,
    # use a single pipeline command to avoid later evaluation of the output by Bash.
    declare -a _Dbg_var_names=()
    if ((_Dbg_typeset_filtered == 1)); then
        # grepping for '=' to only accept variables with a value
        mapfile -t _Dbg_var_names < <(declare -p $_Dbg_typeset_flags |
            grep '=' |
            grep -o '^declare -[^ ]\+ [^=]\+' |
            cut -d ' ' -f 3- |
            grep -v '^_Dbg_\|^_$\|^*$' |
            sort -f 2>/dev/null)
    else
        mapfile -t _Dbg_var_names < <(declare -p $_Dbg_typeset_flags |
            grep -o '^declare -[^ ]\+ [^=]\+' |
            cut -d ' ' -f 3- |
            grep -v '^_Dbg_\|^_$\|^*$' |
            sort -f 2>/dev/null)
    fi

    (($? != 0 || ${#_Dbg_var_names} == 0)) && return

    declare -i _Dbg_skipped_fields
    ((_Dbg_skipped_fields = _Dbg_typeset_filtered + 2))

    declare _Dbg_declare_output
    _Dbg_declare_output="$(declare -p "${_Dbg_var_names[@]}" | cut -d ' ' -s -f ${_Dbg_skipped_fields}- 2>/dev/null)"
    (($? != 0)) && return

    _Dbg_msg_verbatim "$_Dbg_declare_output"
}

# Parse flags passed to the "info variables" command.
# The caller should declare _Dbg_typeset_flags and _Dbg_typeset_filtered before calling,
# which are implicitly returned values.
function _Dbg_info_variables_parse_options {
    _Dbg_typeset_flags=""
    _Dbg_typeset_filtered=1

    typeset -i _Dbg_rc=0
    typeset OPTLIND=''
    while getopts_long irxaAtp opt \
        integer no_argument \
        readonly no_argument \
        exports no_argument \
        indexed no_argument \
        associative no_argument \
        trace no_argument \
        properties no_argument \
        '' "$*"; do
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
