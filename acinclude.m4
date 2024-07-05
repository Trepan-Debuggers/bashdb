AC_DEFUN([AC_BASHDB_PACKAGE], [
dnl Allow choosing the package name to avoid clashes with
dnl bash if beeing installed side-by-side
AC_ARG_VAR(
       ALT_PACKAGE_NAME,
       AS_HELP_STRING([],[alternate packagename to use (default is "$1")])
)
if test -z "${ALT_PACKAGE_NAME}"; then
       ALT_PACKAGE_NAME="$PACKAGE_NAME"
fi

dnl define PACKAGE and VERSION.
PACKAGE=$ALT_PACKAGE_NAME
VERSION=$PACKAGE_VERSION
AC_DEFINE_UNQUOTED(PACKAGE,$PACKAGE)
AC_DEFINE_UNQUOTED(VERSION,$VERSION)
AC_SUBST(PACKAGE)
AC_SUBST(VERSION)
])


AC_DEFUN([AC_SUBST_DIR], [
        ifelse($2,,,$1="$2")
        $1=`(
            test "x$prefix" = xNONE && prefix="$ac_default_prefix"
            test "x$exec_prefix" = xNONE && exec_prefix="${prefix}"
            eval echo \""[$]$1"\"
        )`
        AC_SUBST($1)
])

AC_DEFUN([AC_BASHDB_PREFIX_DEFAULT], [
   ac_default_prefix=`eval (dirname= [$]0)`
])
