test_in_files = \
	test-bash-rematch.in \
	test-bug-step-subshell.in \
	test-complete.in 	\
	test-debug.in 		\
	test-delete.in 		\
	test-export.in 		\
	test-file-with-spaces.in \
	test-info-args.in	\
	test-interrupt.in	\
	test-misc.in		\
	test-bug-break.in       \
	test-setshow.in		\
	test-settrace.in        \
	test-sig.in

test_sources = \
	test-bash-rematch 	\
	test-bug-step-subshell 	\
	test-bug-set-e 		\
	test-complete 		\
	test-debug 		\
	test-delete 		\
	test-export 		\
	test-file-with-spaces 	\
	test-info-args		\
	test-interrupt		\
	test-misc		\
	test-setshow		\
	test-sig

check_DATA = \
	$(test_in_files)   \
	check-common.sh.in \
	interrupt.tests    \
	interrupt-3.tests  \
	lopts.tests        \
	settrace.tests 	   \
	sopts.tests        \
	test-bug-break.in  \
	test-settrace.in   \
	test-sig.in        \
	trace.tests	   \
	trace2.tests

TESTS = \
	$(test_sources) \
	test-action     \
	test-brkpt      \
	test-bug-args   \
	test-bugI       \
	test-bugIFS     \
	test-bug-loc    \
	test-bug-set-e  \
	test-bug-source \
	test-command    \
	test-display    \
	test-enable     \
	test-file-with-spaces  \
	test-finish     \
	test-frame      \
	test-interrupt  \
	test-list       \
	test-lopts 	\
	test-multi	\
	test-parm	\
	test-restart	\
	test-search	\
	test-settrace 	\
	test-skip 	\
	test-sopts 	\
	test-bug-break 	\
	test-bug-clear 	\
	test-bug-step 	\
	test-subshell 	\
	test-tbreak	\
	test-trace	\
	test-watch1	\
	test-watch2 \
	test-preset-brkpt

TESTS_ENVIRONMENT = \
  srcdir="$(abs_srcdir)" \
  builddir="$(abs_builddir)"

abs_srcdir=@abs_srcdir@
abs_builddir=@abs_builddir@

EXTRA_DIST = $(TESTS) $(check_DATA) $(test_in_files) README.md

CLEANFILES = *.check

test: check
test-integration: check

MOSTLYCLEANFILES = *.orig *.rej
