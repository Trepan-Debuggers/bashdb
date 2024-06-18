## Process this file with automake to produce Makefile.in -*-Makefile-*-.

# Don't forget to add the *.in files of new tests to configure.ac in the root folder
TESTS = test-action.sh \
        test-alias.sh \
        test-bashdb-trace.sh \
        test-break.sh \
        test-cmd-complete.sh \
        test-cmd-eval.sh \
        test-cmd-info-variables.sh \
        test-columns.sh \
        test-filecache.sh \
        test-file.sh \
        test-fns.sh \
        test-frame.sh \
        test-get-sourceline.sh \
        test-io.sh \
        test-lib-eval.sh \
        test-lib-list.sh \
        test-msg.sh \
        test-pre.sh \
        test-require.sh \
        test-run.sh \
        test-save-restore.sh \
        test-sort.sh \
        test-validate.sh

tests_sources = $(notdir $(TESTS:=.in))

abs_srcdir=@abs_srcdir@
abs_builddir=@abs_builddir@

AM_TESTS_ENVIRONMENT = \
  srcdir="$(abs_srcdir)"; \
  builddir="$(abs_builddir)"; \
  export srcdir builddir;
LOG_COMPILER = $(SH_PROG)
AM_LOG_FLAGS = $(abs_srcdir)/shunit2 \
               $(abs_srcdir)/helper.sh $(abs_srcdir)/mock-cmd.sh \
               $(abs_srcdir)/require_me.sh

EXTRA_DIST = \
	helper.sh \
	mock-cmd.sh \
	require_me.sh \
	require_me.sh.in $(TESTS) shunit2 $(tests_sources)

test: check
test-unit: check

MOSTLYCLEANFILES = *.orig *.rej
