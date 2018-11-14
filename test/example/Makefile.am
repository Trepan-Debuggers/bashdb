check_DATA =            \
	bug-args.sh.in  \
	bug-clear.sh    \
	bug-loc.sh      \
	bug-step.sh     \
	bug-step-subshell.sh \
	bugI.sh         \
	bugIFS.sh.in    \
	dbg-test1.sh    \
	dbg-test1.sub   \
	dbg-test2.sh    \
	debug.sh        \
	fib.sh          \
	gcd.sh          \
	hanoi.sh.in     \
	interrupt.sh.in \
	library.sh      \
	multi.sh        \
	nexting.sh      \
	parm.sh         \
	restart.sh      \
	settrace.sh     \
	sig.sh          \
	sig-bug.sh      \
	skip.sh         \
	stepping.sh     \
	subshell.sh

TESTS_ENVIRONMENT =      \
  srcdir="$(abs_srcdir)" \
  builddir="$(abs_builddir)"

abs_srcdir=@abs_srcdir@
abs_builddir=@abs_builddir@

EXTRA_DIST = $(check_DATA) README

MOSTLYCLEANFILES = *.orig *.rej
