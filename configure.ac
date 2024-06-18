# Configure script for bash debugger (bashdb)
dnl Process this file with autoconf to produce a configure script.

# Copyright (C) 2002-2012,
# 2014-2019, 2023 Rocky Bernstein <rocky@gnu.org>

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING.  If not, write to the
# Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
# MA 02110-1301 USA.

define(DEBUGGER, bashdb)
define(POSIXSHELL, bash)
define(OK_BASH_VERS, 4.4)
define(relstatus, 1.0.2git)

AC_INIT([bashdb],[OK_BASH_VERS-relstatus],[https://sourceforge.net/p/bashdb/bugs/new/])

dnl make sure we are using a recent autoconf version.
dnl In particular we assume prefix will be set to "NONE" if --prefix
dnl isn't given. Earlier autoconf' used "no" instead of "NONE".
AC_PREREQ([2.71])

##################################################################
# See if --prefix was set. If not, set it to a reasonable default
# based on where bash thinks bashdb is supposed to be installed.
##################################################################
AM_INIT_AUTOMAKE([foreign])
AM_MAINTAINER_MODE


# List of output variables produced by this configure script
#
AC_SUBST(BASHVERS)
AC_SUBST(RELSTATUS)

AC_ARG_WITH(bashdb-main, AS_HELP_STRING([--with-bashdb-main],[location of bashdb-main.inc]),
		  BASHDB_MAIN=$withval,
		  ${ac_default_prefix/prefix}/bashdb/bashdb-main.inc)
AC_SUBST(BASHDB_MAIN)

# See if we build set0.c
AC_ARG_WITH(bash-src, AC_HELP_STRING([--with-bash-src],
		  [location of bash OK_BASH_VERS source code]),
		  BASH_SRC=$withval)
AC_SUBST(BASH_SRC)
AC_PROG_CC
if test x"$BASH_SRC" != x ; then
   if test ! -d $BASH_SRC ; then
     AC_MSG_ERROR([bash source directory ($BASH_SRC) does not seem to be a directory])
   else
     AM_PROG_CC_C_O
     dnl We run a C compiler to get macro EXEEXT set and possibly readarray.c.
     build_set0=$BASH_SRC
     AC_CHECK_HEADERS(unistd.h string.h,,
         [AC_MSG_WARN([Missing some C headers. Disabling set0])
         build_set0=])
   fi
fi
AM_PROG_LIBTOOL
AM_CONDITIONAL(BUILD_BUILTINS, test x"$build_set0" != x)
PIC=$lt_prog_compiler_pic
WL=$lt_prog_compiler_wl
AC_SUBST(PIC)
AC_SUBST(WL)
AC_SUBST(DIFF)
AC_SUBST(DIFF_OPTS)
AC_PATH_PROG(PERL, perl, false)
AC_PROG_GREP
AC_PROG_SED

CMDLINE_INVOKED='$0 == ${BASH_SOURCE}'
AC_SUBST(CMDLINE_INVOKED)

AC_CONFIG_HEADERS(config.h)
AC_DEFINE([PACKAGE], [bashdb], [Bash Debugger])
AC_DEFINE([VERSION], [OK_BASH_VERS-relstatus], [version string])

AC_ARG_PROGRAM

AC_BASHDB_PACKAGE([bashdb])

# Brought over from bash/configure.in to substitute OK_BASH_VERS
# and RELSTATUS in bashdb.in and version.texi
BASHVERS=OK_BASH_VERS
RELSTATUS=relstatus


AC_CONFIG_SRCDIR(DEBUGGER.in)
if test x$ac_srcdir = x ; then
  ac_srcdir=.
fi

AM_MISSING_PROG(GIT2CL, git2cl, $missing_dir)
AC_PROG_LN_S
AC_PATH_PROG(RM, rm, true)
AC_PROG_MAKE_SET

## --with-bash can be used to tell the bashdb script and the regression
## test which bash to run. It can be omitted too in which case we'll
## look for a bash binary.
AC_ARG_WITH(POSIXSHELL, AS_HELP_STRING([--with-POSIXSHELL],[location of POSIXSHELL program]), SH_PROG=$withval)

if test "$SH_PROG" = "yes" || test "$SH_PROG" = "no" || test -z "$SH_PROG"
then
  bash_shell_dir=$(dirname $SHELL)
  AC_PATH_PROG(SH_PROG, POSIXSHELL, no, PATH="$bash_shell_dir:$PATH")
fi

if test "$SH_PROG" = no; then
  AC_MSG_ERROR([I didn't find the DEBUGGER executable.\
  You might want to use the --with-POSIXSHELL option.])
fi

bash_version=`$SH_PROG --version`
[bash_major=`$SH_PROG -c 'echo ${BASH_VERSINFO[0]}'`]
[bash_minor=`$SH_PROG -c 'echo ${BASH_VERSINFO[1]}'`]
bash_4_or_greater=no
case "${bash_major}.${bash_minor}" in
  'OK_BASH_VERS' | '4.1' | '4.2' | '4.3')
    bash_4_or_greater=yes
    ;;
  *)
    AC_MSG_WARN([You have Bash $bash_version installed.])
    AC_MSG_ERROR([This package is only known to work with Bash 4.1-4.4.])
    ;;
esac

AC_ARG_WITH(dbg-main, AS_HELP_STRING([--with-dbg-main],[location of dbg-main.sh]),
		  [DBGR_MAIN=$withval]
		  [DBGR_MAIN=${ac_default_prefix/prefix}/bashdb/bashdb-main.inc])
AC_SUBST(DBGR_MAIN)

mydir=$(dirname $0)
if test "$prefix" == NONE ; then
   prefix=$($SH_PROG $mydir/compute-prefix.sh $SH_PROG)
fi

if test -z "$DBGR_MAIN" ; then
  DBGR_MAIN=`strings $SH_PROG$EXEEXT | grep bashdb-main.inc`
  if test -z "$DBGR_MAIN" ; then
     AC_MSG_ERROR([I didn't find bashdb-main.inc in your bash. If you have the
right version of bash, set it with the --with-dbg-main option])
  fi
fi

# Create a suitable transform ( without the $ -> $$ escaping added
# because of $program_transform_name being used in a Makefile
# This transform is needed because bashdb must be executed by the
# bashdb-bash regardless if a program transform has taken place
ac_transform=`echo "$program_transform_name" | sed 's/\\$\\$/\\$/g'`

# Fully expanded name of bash executable to be substituted into
# bashdb.This allow us to move this package into any suitable location
# by using --prefix as an option to configure.
AC_SUBST_DIR(INTERPRETER_NAME,"${bindir}/"`echo bash | sed "$ac_transform"`)

# WARNING: The configure-correct name for architecture-independent
# directory (the place for the bash source for the debugger) is
# datadir. The automake file seem to want to use pkgdatadir instead.

# I'm not sure how to get these to agree.

# Also, I'd like to set the default to the name that's been coded
# inside of the bash program rather than some autoconf standard; I
# don't know how to change the autoconf default that which is
# determined dynamically below.

# Get the fully expanded name of pkgdatadir. This is used in bashdb.in
# and dbg-main.sh.in and for installing debugger files.

pkgdatadir=$datadir/DEBUGGER
AC_SUBST_DIR(PKGDATADIR, $pkgdatadir)

dnl We use a diff in regression testing
AC_PATH_PROG(DIFF, diff, no)
# FIXME: check that option -b (ignore-whitspace) works
DIFF_OPTS=-b

if test "$DIFF" = no ; then
   AC_PATH_PROG(DIFF, cmp, no)
else
   dnl Try for GNU diff options.
  # MSDOG output uses \r\n rather than \n in tests
  for diff_opt in -w --unified -b ; do
    if $DIFF $diff_opt $0 $0 > /dev/null 2>&1; then
      AC_MSG_RESULT([adding $diff_opt to diff in regression tests])
      DIFF_OPTS="$DIFF_OPTS $diff_opt"
    fi
  done
fi

##################################################################
# See if --prefix was set. If not, set it to a reasonable default
# based on where bash thinks bashdb is supposed to be installed.
##################################################################
mydir=$(dirname $0)
if [[ "$prefix" = NONE ]]; then
   prefix=$($SH_PROG $mydir/compute-prefix.sh $SH_PROG)
   ac_default_prefix=$prefix
fi

#Makefiles
AC_CONFIG_FILES([ \
        Makefile                  \
        builtin/Makefile          \
        command/Makefile          \
        command/info_sub/Makefile \
        command/set_sub/Makefile  \
        command/show_sub/Makefile \
        data/Makefile             \
        doc/Makefile              \
        init/Makefile             \
        lib/Makefile              \
        test/Makefile             \
        test/data/Makefile        \
        test/example/Makefile     \
        test/integration/Makefile \
        test/unit/Makefile        \
        test/unit/require_me.sh   \
        ])

# Additional files needing substitution of values (not Makefiles).
AC_CONFIG_FILES([bashdb], [chmod +x DEBUGGER])
AC_CONFIG_FILES([test/example/bugIFS.sh],
                [chmod +x test/example/bugIFS.sh])
AC_CONFIG_FILES([test/example/hanoi.sh],
                [chmod +x test/example/hanoi.sh])
AC_CONFIG_FILES([test/example/interrupt.sh],
                [chmod +x test/example/interrupt.sh])
AC_CONFIG_FILES([test/example/bug-args.sh],
                [chmod +x test/example/bug-args.sh])
AC_CONFIG_FILES([test/unit/test-action.sh],
                [chmod +x test/unit/test-action.sh])
AC_CONFIG_FILES([test/unit/test-alias.sh],
                [chmod +x test/unit/test-alias.sh])
AC_CONFIG_FILES([test/unit/test-bashdb-trace.sh],
                [chmod +x test/unit/test-bashdb-trace.sh])
AC_CONFIG_FILES([test/unit/test-break.sh],
                [chmod +x test/unit/test-break.sh])
AC_CONFIG_FILES([test/unit/test-cmd-complete.sh],
                [chmod +x test/unit/test-cmd-complete.sh])
AC_CONFIG_FILES([test/unit/test-cmd-info-variables.sh],
                [chmod +x test/unit/test-cmd-info-variables.sh])
AC_CONFIG_FILES([test/unit/test-cmd-eval.sh],
                [chmod +x test/unit/test-cmd-eval.sh])
AC_CONFIG_FILES([test/unit/test-columns.sh],
                [chmod +x test/unit/test-columns.sh])
AC_CONFIG_FILES([test/unit/test-eval.sh],
                [chmod +x test/unit/test-eval.sh])
AC_CONFIG_FILES([test/unit/test-file.sh],
                [chmod +x test/unit/test-file.sh])
AC_CONFIG_FILES([test/unit/test-filecache.sh],
                [chmod +x test/unit/test-filecache.sh])
AC_CONFIG_FILES([test/unit/test-get-sourceline.sh],
                [chmod +x test/unit/test-get-sourceline.sh])
AC_CONFIG_FILES([test/unit/test-fns.sh], [chmod +x test/unit/test-fns.sh])
AC_CONFIG_FILES([test/unit/test-frame.sh], [chmod +x test/unit/test-frame.sh])
AC_CONFIG_FILES([test/unit/test-lib-eval.sh],
                [chmod +x test/unit/test-lib-eval.sh])
AC_CONFIG_FILES([test/unit/test-lib-list.sh],
                 [chmod +x test/unit/test-lib-list.sh])
AC_CONFIG_FILES([test/unit/test-msg.sh], [chmod +x test/unit/test-msg.sh])
AC_CONFIG_FILES([test/unit/test-io.sh],  [chmod +x test/unit/test-io.sh])
AC_CONFIG_FILES([test/unit/test-pre.sh], [chmod +x test/unit/test-pre.sh])
AC_CONFIG_FILES([test/unit/test-require.sh],
                [chmod +x test/unit/test-require.sh])
AC_CONFIG_FILES([test/unit/test-run.sh], [chmod +x test/unit/test-run.sh])
AC_CONFIG_FILES([test/unit/test-save-restore.sh],
                [chmod +x test/unit/test-save-restore.sh])
AC_CONFIG_FILES([test/unit/test-set0.sh],
                [chmod +x test/unit/test-set0.sh])
AC_CONFIG_FILES([test/unit/test-sort.sh],
                [chmod +x test/unit/test-sort.sh])
AC_CONFIG_FILES([test/unit/test-validate.sh],
                [chmod +x test/unit/test-validate.sh])

AC_CONFIG_FILES([test/integration/test-bash-rematch],
                [chmod +x test/integration/test-bash-rematch])
AC_CONFIG_FILES([test/integration/test-bug-break],
                [chmod +x test/integration/test-bug-break])
AC_CONFIG_FILES([test/integration/test-bug-step-subshell],
                [chmod +x test/integration/test-bug-step-subshell])
AC_CONFIG_FILES([test/integration/test-complete],
                [chmod +x test/integration/test-complete])
AC_CONFIG_FILES([test/integration/test-debug],
                [chmod +x test/integration/test-debug])
AC_CONFIG_FILES([test/integration/test-delete],
                [chmod +x test/integration/test-delete])
AC_CONFIG_FILES([test/integration/test-export],
                [chmod +x test/integration/test-export])
AC_CONFIG_FILES([test/integration/test-file-with-spaces],
                [chmod +x test/integration/test-file-with-spaces])
AC_CONFIG_FILES([test/integration/test-interrupt],
                [chmod +x test/integration/test-interrupt])
AC_CONFIG_FILES([test/integration/test-misc],
                [chmod +x test/integration/test-misc])
AC_CONFIG_FILES([test/integration/test-setshow],
                [chmod +x test/integration/test-setshow])
AC_CONFIG_FILES([test/integration/test-info-args],
                [chmod +x test/integration/test-info-args])
AC_CONFIG_FILES([test/integration/test-settrace],
                [chmod +x test/integration/test-settrace])
AC_CONFIG_FILES([test/integration/test-sig],
                [chmod +x test/integration/test-sig])

AC_CONFIG_FILES([ \
        bashdb-main.inc \
        bashdb-trace \
        doc/macros.texi \
        test/integration/check-common.sh \
        ])

AC_CONFIG_COMMANDS([default],[[
# Keep old dates on these files to prevent rebuilding.
touch -cr $ac_srcdir/configure.ac doc/bashdb.1
touch -cr $ac_srcdir/configure.ac doc/bashdb-man.html
if test -e $ac_srcdir/doc/version-bashdb.texi ; then
        echo timestamp > $ac_srcdir/doc/stamp-vti
        touch -cr $ac_srcdir/configure.ac $ac_srcdir/doc/version-bashdb.texi \
        $ac_srcdir/doc/stamp-vti \
        $ac_srcdir/doc/bashdb.info*
fi
]],[[]])

AC_OUTPUT
echo
echo "========================================================="
echo "Bash version: $bash_version"
echo "Location    : $SH_PROG"
echo "Prefix      : $prefix"
if $($SH_PROG $mydir/check-prefix.sh $SH_PROG $prefix); then
    echo "prefix checks out"
else
    echo "Warning: prefix doesn't match what is in bash for 'bash --debugger ...' to work"
fi

if test x"$build_set0" != x; then
   echo "We will try to build the set0 builtin to set variable \$0"
   echo "using source located at ${BASH_SRC}."
elif test "$bash_4_or_greater" = no ; then
   echo 'We will not try to build the set $0 builtin.'
fi
