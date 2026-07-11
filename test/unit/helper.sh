PS4='-(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]} - [${SHLVL},${BASH_SUBSHELL}, $?]
'
shopt -s extdebug
_Dbg_libdir=$abs_top_srcdir
shunit_file=${abs_top_srcdir}test/unit/shunit2

# Don't need to show banner
set -- '-q'
