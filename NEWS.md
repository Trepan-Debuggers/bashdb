Version 5.2-0.1.2.0
-------------------

- Preset breakpoints in per project .bashdbrc -
- Fix failure to set conditional breakpoint using condition command
- Document startup behavior under "entry-exit"
- Manpage corrections

Version 5.1-0.1.1.2
-------------------

Lots of changes! To be filled in later.


Version 5.0-0.1.1.2 gecko gecko
-------------------------------

* Save/restore BASH_REMATCH more reliably Fixes https://sourceforge.net/p/bashdb/bugs/62/
* Simpiler test-interrupt looping.  Thanks to Alastair Smith
* Keep up with pygmentize ...  Using defaults will be less work in the end.
  Fixes	https://sourceforge.net/p/bashdb/bugs/64/
* Get all Pygments style a user has installednot just builtins
  Thanks are due to John Purnell. See https://sourceforge.net/p/bashdb/tickets/4/
* Determine BASH_REMATCH value based on BASH_REMATCH value rather than a regexp on
  the last bash command. This is flaky, but less so.
* Better BASH_REMATCH save/restore...  restore $1, $2, etc.
* Set BASH_REMATCH in eval
* Add "!" suffix to "kill" command
* Document fixes and improvements
* Track $0 when it changes inside debugged progam.

Version 5.0-0.1.1.1
--------------------

* Document "condition" better
* Show history before running it
* Document "info variables" better.
* Remove markdown bug.
* Add -x, -r, -i flags to info `show variables`, and add est
* Fix some small typos in comments
* Properly filter `_Dbg_` variables out of "info var"
* Update docs remove mention of $0 not set. In bash 5.0 $0 is set.


Version 5.0-0.1.1.0 Labor Day
------------------------------

Sept 3, 2019

* Revise for Bash 5.0
* Use BASH_ARGV0
* remove custom builtins; all of our internal bash fns are now bash internal functions

Version 4.4-0.1.0.1  L'il sis 55
--------------------------------

Nov 17, 2018

* Preserve BASH_REMATCH Bug #56
* Add more of the test files added in git from 4.4.0-1.0.0 into the tarball. Bug #52
* Change some "print"s to "printf" and a fix typo Bug #53

Version 4.4-0.1.0.0
--------------------
Oct 27, 2018 - 7x9

* Better handling of blanks in filenames
* expand "backtrace": allow gdb negative count
* Add -s/--source option
* Fix test for working pygmentize. Bug #48
* Allow gdb-compatible enable/disable with no args
* gdb "delete" (no args - deletes all breakpoints) implemented
* Fix "clear" command with no args

Version 4.4-0.94
-----------------
August 24, 2017

* Compute prefix better. Should run better on macosx, netbsd, and  Solaris (and possibly others or Linux set up more wierdly) unmodified

Version 4.4-0.93
----------------
August 4, 2017

* add "bash" as an alias for "shell"
* Respect DARK_BG and use term-background.sh to detect it
  Note: we are more aggressive now about setting highlghting
* Fix debugging in the presense of "set -e"
* Bash 4.4 test fixes
* Sort completions
* configure respects --prefix which was broken in autoconf 2.69
* change bug reporting address

Version 4.2-0.92
----------------
April 30, 2017

* Allow source-code colorization via pygments style. use `set style`
* Help text now formated via Rst.
* Paragraph reflow adjusts to line width
* Revise help docs

Version 4.3-0.92
----------------
May 30, 2016 Mom

* Better breakpoint deletion status This helps frontends like realgud
* Nicholas Bamber's from issues #35 and #36 bashdb-man.pod: s
* Works on bash 4.4
  pelling mistake SIGXFSZ in some envionments.
* Guard againyst install-data running rm / !
* `--highlight` changed from taking no parameters to
  `--highlight=dark|light`. And we now accomdate dark terminals more
    properly.
* Add `tty set` `tty show`
* Add sectioning in online help

Version 4.3-0.91
----------------
Dec 14, 2014 Late Gecko

* Fix bug in clear command
* Fix bug in source code filename not updating
* Fix bug in saving/restoring nullglob
* Document set highlight better

Version 4.3-0.9
---------------
Sept 15, 2014

* Make this work on bash 4.3.
* Incompatible change: make more like gdb. `u` is no longer up and `d`
  is `delete` not `down`
* Add completion for `eval?` and `eval` to refer to current source line.
* Changes to tolerate more foreign OS's like FreeBSD or old Solaris
* add `set tty` `show tty` debugger commands
* Misc bugs fixed

Version 4.2-0.9
---------------
2011-4-18

* Add loadable module `set0` to set `$0`. Used when `bashdb` is run initially
* Add loadable module "readc" which is builtin read with command completion
  To use Both of the above, you need to compile with bash source `--with-bash-src=`
* Some tab command completion if "readc" is installed
* Remove hard-wiring of `info`, `set`, and `show` commands.
* Expand help text for various commands
* Debugger commands can be the smallest unique prefix
* Fix bugs in 'trace', 'untrace', and "info args" commands
* "set debugging" is not "set debug" to match gdb
* Unit tests are faster and have less white space but more useful information
* eval? evaluates the RHS of an assignment statement

Version 4.2-0.8
---------------

* Reinstate code to set $0 can makes running via bashdb more like
  running without debugger. Add `set dollar0` command.
* Some code reorganization to improve modularity and testing
* Show frame number and backtrace line when switching frames. For front-ends
* Better temp file cleanup before debugger "kill -9".
* Better test for pygmentize and replace tabs with blanks in source code.

Version 4.2-0.7 - Ides of March
-------------------------------
2011-3-15

* Updates for bash 4.2
* syntax coloring if the Python pygments package installed (and
  --highlight option used)
* easy way to evaluate the current source line or expression inside
  the source line (debugger commands "eval" and "eval?")
* ability to go into a nested shell but keeping existing variables and
  functions set. (debugger command "shell") With this, one needs...
* ability to save variables to an outer shell ("set_vars" function
  inside the interactive shell)
* ability to save values from inside a subshell to the outer shell
  (debugger command "export")
* add --init-file (akin to same option in bash) to have bash code
  sourced

Version 4.2-0.6 - giant madagascar day gecko
--------------------------------------------
2010-12-10

* Debugger `list` command carries on where we last left off and
  centers around a line unless given a start and end line number. l> added.
* Fixed `--no-init` (`--nx`, `-n`) option
* Fixed to work on bash version 4.2
* Reorganized command-processing code to simplify it, make it more dynamic,
  and allow for better expansion increasing DRYness. As a result
  some short abbreviations of commands have been dropped. Use "alias"
  to add back any that you want.
* Make "display" command more like gdb. Note this is an incompatible change.
  Left to do is to start indexing from 1.
* Emacs lisp code has been removed. Please multi-debugger code from
  http://github.com/rocky/emacs-dbgr instead.
* Numerous little bugs fixed.

Version 4.1-0.5
---------------
2010-10-27

* Add `set autolist`, `show autolist`.
* Fix bugs when file contained spaces in a directory portion of the path
* `set force` deprecated. Use `set different`.
* Code reorganization to support subcommands (set/show/info) and allow
  for growth

Version 4.1-0.4
---------------
2010-07-09

* Rewrite to use bash associative arrays (first in 4.0) and automatic
  file descriptor selection for input (first in 4.1). As a result, we
  need bash 4.1 or greater.
* "info program" shows the command to be executed.
* tests run clean on Solaris
* many help corrections and improvements
* `.bashdbinit` is now `$HOME/.bashdbrc`
* code is cleaner, more reliable and more maintainable (at least by
  me). Some small bugs fixed.

Version 4.0-0.4
----------------
2009-10-27

* Handle file names with embedded blanks. More parameters in calls are now
  quoted properly
* Add `set force`, `step+`", and `step-` commands.
* Preface more variable names with _Dbg_. Missed a use with "i" which
  wreaked havoc in debugging some programs which used variable i.
* Use builtin readarray if bash 4 (or greater) detected.
* Fix bug in stepping inside a subshell
* Remove the triplicate banner when running bash --debugger
* Tolerate bash 4.1

Version 4.0-0.3
---------------
2009-04-10

* Allow arbitrary number of aliases
* Bug fix for bash 4.x don't try to return negative values in functions
* Allow building on bash 3.1
* Fix bug in alternating between "step" and "next" commands
* Some other small doc and bug fixes.

Version 4.0-0.2
---------------
2008-11-17

* Minor bug fixes

Version 4.0-0.1
---------------
2008-10-27

* Major rewrite and reorganization of code.
* compatible with bash 4.0
* "alias" command added, short commands names are now aliases and not
* hard-coded in
* autoeval mode added: if set, commands that aren't debugger commands are
* eval'd
* Add step+, step-, and "set force": force stepping to go to another line.
* Add builtin set0. Debugger will $0 (program name) if possible.
* "help" now shows lists of commands in columns
* Add set/show annotate. Add Emacs support for this
* Add gdb-like "edit" command to edit source where stopped.
* Dbg_set_trace -> Dbg_debugger more often
* Add unit tests via Kate Ward's `shunit2`.
* add trace/untrace to add xtrace to a function.
* Portable long options support via Stéphane Chazelas
* More (most?) debugger variables now start with `_Dbg_`.
* Greatly improve GNU Emacs support via gdba.
* Many bug fixes.

Version 3.1 0.09
----------------
2007-10-27

* Add set/show trace-commands to make the same as gdb 6.6
* show commands now allows for a starting number and +, same as gdb
* Reduce assumption that undefined means '' - initialize more variables.
  Working towards inserting "set -u".
* variable and tilde expansion now occurs in cd command. Note gdb
  does tilde expansion but not variable expansion like $HOME.
* add linetrace delay
* make FreeBSD tests work, cygwin signals are working so test are run there
* documentation updates
* emacs code improved
* some installation bugs fixed
* file name was sometimes incorrectly reported when debugged script set IFS

Version 3.1 0.08
-----------------
2007-1-20

 - Files coming from function line-specifications should be read in.
   Debian Bug #40336

 - add a gdb-like "load" command to force reading in a file.

 - negative numbers allowed in "frame" (and "up" and "down") commands.
   In particular "frame -1" refers to the oldest frame.  Some
   refactoring of this code.

 - Note setting $PS4 in doc.

 - Help, manual-page and documentation fixes.

Version 3.1 0.07
----------------
2006-12-10

* Add gdb-like "signal" command
* Add "kill" command for those cases where "quit" doesn't work.
* Add mechanism to set up signal handlers so debugger is entered,
  or we just print the signal.
* document how to do call line tracing from within a program, i.e.
  like the above signal handling setup, the debugger is not entered
  first.
* Allow an optional line-spec on "continue" debugger command.
* Add --enable-getopt option to disable GNU getopt for systems that have
  non-GNU getopt like NetBSD
* Fix bug in tracking parameters $1, $2, etc
* Emacs interface bug fixes
* readarray builtin internal changes
* Document updates
* Make sure we don't complain about bash 3.2. This debugger works on both.

Version 3.1 0.06
----------------
2006-07-21

* Add gdb 'commands' command:
  runs debugger commands at a specified breakpoint
* Add gdb 'info program'. (Shows program status)
* Add ability to invoke from inside a running program rather than
  at the outset (set_trace)
* Add a better line tracing:
   * shows bash nesting,
   * bash subshell nesting
   * function nesting
   * source line preserving initial indentation
* Add line tracing command-line option in bashdb: -X, and long option --trace
* add ability to turn on and off line tracing from inside a program
* Revise sample sessions in bashdb document
* Sourcing a debugger command file now prints the
  command before executing it.
* Executing a string (option -c or --command) shows the command
  to be run in the call stack.
* Attempt to get documentation on GNU Emacs section in order. Describe
  bashdbtrack.
* Go over documentation yet again. When will I ever get this right?

Version 3.1 0.05
----------------
2006-03-24

* Add `complete` (command completion),
* Add `cd`, `pwd`
* Add gdb-style set/show logging.
* Better checking to see if we have  bash 3.1 (as opposed to 3.0)
* GNU Emacs debugging improvements, including...
  * Add shell prompt tracking in GNU Emacs (bashdbtrack - like
    Python's pdbtrack)
  * Patches to allow VPATH (or build outside of source tree)
  * Numerous documentation changes
  * Break out command files even more.

Version 3.1 0.04 (initial 3.1 release)
--------------------------------------
2006-01-16

* Showing which command on a line with multiple commmands works again.
  Reinstate regression tests which use that.
* Add a loadable routine to read a script into an array fast. This
  speeds up the startup on reading large scripts very much.
* Install compiled GNU emacs lisp
* We were reporting script line sizes as one larger than the actual size
* Bash location matches installation in bashdb documentation

Version 3.00 0.03 (bugfix and palindromic-version-number release)
-----------------------------------------------------------------
2005-12-10

* Changes to make ddd work better
  * "info args" works correctly
  * "help run" works
  * Do all the directory removing/creating/symbolic linking so that bash
    finds the include file it needs. This was real ugly. I couldn't have
    undertaken to try to figure this out without my GNU Makefile debugger
    and the "write" command.

Version 3.00 0.02 (cleanup release)
-----------------------------------
2005-07-24

* if texi2html isn't installed, don't give an error on "make"
* allow regression tests to be run using the Bourne shell's /bin/sh
* removing failed tests on bash 3.0
* "make distcheck" now works
* go over INSTALL instructions

Version 3.00 0.01
-----------------
2004-11-11

* First release for bash 3.0

Version 0.44
------------
* Show progress bar during reading target scripts.

Version 0.43
------------
2004-05-15

* Add `file` command
* Expand `bash.1` to include more rebash extensions, e.g. variable names
* Improve documentation
* Fix bug listing line numbers and restarting when debugged program has
  done a cd. Save initial cwd.
* don't install gud unless we have emacs version 21.0 to 21.3.
* reduce spurious warnings in bash and rebash regression tests.
* test for null filename in reading in source.
* Lots of gcc -Wall compiler warnings removed. There were some potential
  uses of uninitalized variables (if not one outright bug).
* fix mis-configuration for OSs that have both GNU gettext and one in libc

Version 0.42
------------
2003-09-20

* Autostuff improvements
* fixes to make Cygwin, OS X and AIX builds
* configurable package and executable names
* Allow modification the philosophical parts the bashdb reference
  manual to placate Matthias Klose and presumably Debian folks
* Bug: a comment line in the history was taken as a timestamp and we
  dumped core. Non-timestamp comment lines should appear in the history now.
* Bug: was not expanding source filename in debugger the correct way.
* Mention HISTTIMEFORMAT in bash.1
* Add bashdb manual page.
* Changes to allow building outside of source tree.
* Add Debian bash 2.05b patches provided by Matthias Klose.

Version 0.41
------------
2003-08-08

* The line number in multi-line assignments had been the line number where
  the assignment ends, not the beginning. Thus assignments with
  back-ticked subshells gave the wrong line number.
* V (info variables) command working thanks to Mikael Andersson
* Add `help show <command>` and `help info <command>`
* More global variables start out `_Dbg_` now (e.g. `source_` -> `_Dbg_source_`)
* Add long overdue `THANKS`

Version 0.40
------------
2003-6-13

* "make distcheck" from debugger directory works
* bashdb doc moved under debugger directory
* Make portability changes for cygwin and OS's that don't have wcwidth
* Install public bash 2.05b patches 005-007
* use diff -u if that's available on regression tests

Version 0.39
------------
2003-5-27

* history now is timestamped. Use environment variable HISTTIMEFORMAT
  to customize using strftime specifiers.
* tty detection made less more generic
+ The timestamp patch is was posted to bug-readline@gnu.org; there is no
  response.


Version 0.38
------------
2003-4-29

* Was not finding source file if we did a cd in the debugged script
  and the source file name was relative. Expand source file names.

Version 0.37
------------
April Fool's Day 2003

*  As a result of the below ddd's break/clear icon/buttons should work:
  *  Add "set annotate".
  *  Make breakpoint output more like gdb's. make show output more like gdb's
  *  Canonicalize filenames on breakpoints, actions, lists.
  *  add gdb "show dir" and do lookup based on source name and $cdir:$cwd
*  _bashdb_ -> _Dbg_
*  Add ~ to filename translation characters

Version 0.36
------------

*  Bug: if IFS set character in filename: the filename would be truncated.
   Handle IFS save/restore more pervasively by saving on DEBUG handler
   entry.

*  Bug/Feature fix: Restart now quits all subshells before issuing its
   restart (exec) command.

*  Mechanism for having variables set in a subshell persist in a parent
   shell worked out. Some of the global debugger settings (like
   listsize, history) use this.

*  debugger "print" command now uses double quote expansion rules.
   (So print *** will expand filenames). We were having evaluation problems
   in printing strings like "This won't work" (the single quote).

*  Bug: setting shell variables with double/single quotes other
   meta characters now works.

*  Bug: caller() returned mismatched functions for line numbers/filenames.
   Also now returns null string if no caller.

*  Add + to list of filename translation characters.

+  Patches for this version is posted to bash maintainer; word March 31st
   2003, that bash debugger patches have been integrated in a modified
   form into "mainline bash code".

Version 0.35
------------

*  Bug: if IFS was not blank setting  _bashdb_old_set_opts might fail.
   Save and restore IFS before using "set"

*  Bug: (parse.y) line number was not updated properly when in a here
   documented with an unquoted delimiter and containing backslash newline.

*  Bug, sort of: now set BASH_COMMAND to for head (for i in x y z ...)
   in case head (case x in ), and in select head (select s in).

*  Feature: "restart" now saves debugger environment. Environment variable
   BASHDB_RESTART give the state file to read.

*  Add environment variable BASHDB_INPUT to have a debugger command
   file get read. This can be a space-separated list of files. Allow
   -x many times in bashdb.

*  Patches: Install public bash 2.05b patches 001-004.

*  When reading large fileswhich takes a long time (e.g. "configure"
   scripts), print out status every 1000 lines.

Version 0.34
------------

*  Bug: if no script we were running "set" to dump environment.

*  Bug: "H count" was broken due to typo.

*  We now keep track of the subshell level: dynamic variable
   BASH_SUBSHELL and the debugger prints these as ()'s inside of the
   prompt.

*  "quit" leaves nested subshells more properly. Now takes an optional
   argument to specify how many subshells to leave.

*  Update gud.el (Masatake YAMATO), remove examples/bashdb/bashdb.el which may
   cause confusion and set expectations for examples/bashdb (via README)

Version 0.33
------------

*  Regression tests work on FreeBSD, OSX (as well as Linux and Solaris)

*  Fix following bugs:

   * exit handler was getting called each time we exited a subshell.

   * "bash --debugger script args" was not setting args properly.

   * (configure) remove --with-debugger-start which are for
     packages. Is variable DEBUGGER_START_FILE now. Versions are more
     automatically picked up from a central setting. (More could be done
     though). Thanks to c_thomps@ecolinux.no-ip.com.

   * not setting fntrace correctly on debugger exit.

   * wrong line number on case selector statement. Was esac rather than case.

   * was getting max line number for some files properly

   * (makefile) man2html.o not removed on clean

*  Be able to handle EXIT like other signals (stop/nostop stack/nostack).

*  Add provision for finding out which command is going to be executed.
   Useful on multi-statement lines, conditional tests, for-loop headers a
   eval (since the statement might be first "eval $foo" and then
   "echo this is my life."

*  Display command in debugger session we are on the same line/file and this
   command changed.

*  Canonicalize filevars via a file-expand routine. Allows many ways to
   refer to the same file.

*  Add option to have files show only short (basename) names, useful in testing

*  Add set/show of these (basename, debugging debugger).

*  Add -c option on bashdb. Analogous to "bash -c string"

*  correct releases automatically put in "bash -v" and debugger M commands.

*  Clean up signal handling code some. No longer need to pass LINENO.
   Add routine to do some of the common entry/exit things.

Version 0.32
------------

*  Line number reporting improved.

*  Fix bug in using trap line numbers inside traps. BASH_LINENO had
   been wrong for the parts inside of a trap.

*  Fix bug in case line numbers reporting line number of "esac" rather than case clause

*  Fix bug in "down" command

*  Bug in regression test run-all not picking up right shell sometimes.

*  Make command "x" (display variable) much more useful and smarter
   and more like perl5db's "x" command: show variable attributes (via
   declare -p) or function body (via declare -f) evaluates an expression if
   those fail and if *that* fails do what good ol' "print" would do.

*  Add gdb's:
	"condition" command.
	"info break <n>".
	"handle" command
	"info signal"

*  Signal handling more like gdb.

*  bashdb patches for ddd

*  Change help be more like gdb to facilitate ddd support.

*  Improve bashdb.el and patches for gud.el

*  Missing "finish" help info.


Version 0.31
------------

*  Fix bug where stack trace current line entry was sometimes wrong.
   No longer mangle line number in stack changing commands.

*  Implement gdb "finish" (some line number weirdnesses though.)

*  Don't clobber debugged script's INT or ERR trap signal if set, but
   do change them inside the debugger.

*  All debugger functions now start _bashdb

*  Expand history commands: "H -n" and "! n" work like perl5db.

*  short command v (versions) changed to M to match perl5db.

Version 0.30
------------

*  Fix bugs in debugger output when debugged program redirects I/O

*  Fix bug in setting $# via the way we set $1, $2 and so on. We now
   also handle an arbitrary number of parameters.

*  Fix/change history. Numbers now match prompt numbers. Can use !n, !-n as
   well as hi [-]n. Also ![-]n:p instead of H n. Can limit the number
   of history items listed on the H command.

*  Add GDB's "set args" command.

*  Add GDB's "set editing" command.

*  Add GDB's set/show prompt and allow for more flexible prompt customization.

*  Add GDB-like tty command and bashdb option -t for this.
   Unlike GDB though, you can redirect debugger output to a file.

*  Minor tweaks to "help" and "show". "show subtopic" works.

Version 0.29
------------

*  Fix bug in "make uninstall"

*  $? is saved and preserved for use inside "eval", "print", "watch",
   "display", "break" and "action" expressions.

*  Can also refer to $1, $2, ... in commands mentioned above.

*  debug-level nesting (the number of times we are nested in debugger)
   is now shown in prompt via new exported variable BASHDB_LEVEL.

*  Implement "skip" command. (Don't run next command.) Integrate this into
   "debug" command.

*  First cut at gdb-type "return" (premature return from function or
   sourced program).

*  Document caller() builtin function and "debug" debugger command.

* "Search" now works like gdb and perl5db. Fix a small bug in search
   forward: was not resetting line to search location.

Version 0.28
------------

*  Can refer to parameters $1 $2, ... in "print", "eval" and breakpoint
   conditions.

*  Parameters appear in call stack. To do this:

*  BASH_ARGC and BASH_ARGV arrays added. One is a stack of the count of
   the parameters and the other a stack of the parameters.

Version 0.27
------------

*  Add forward and backward search.

*  Add Perl "a" and "A" (action) commands.

*  Add builtin caller().

Version 0.26
------------

*  Document "break" command.

*  Change "line" to "linespec" in online help where
   appropriate.

*  Add commands "tbreak" (one-time break) and "display" (automatic display).

*  Add provision to debug into a script ("debug" command), and leave
   script without going back into debugger command loop
   (BASHDB_QUIT_ON_QUIT environment variable).

*  Document command "tbreak", "enable" and "disable" in manual.

Version 0.25
------------

*  Fix core dump on error (when no source file).

*  Fix bug where "watche x > 24" was creating output to file 24.

*  "restart" now picks up full bash name from BASH environment variable.

*  bash --debugger -c "..." now works.

   To accomplish the above, environment variable BASH_EXECUTION_STRING
   was added which contains the contents what was passed after -c.

*  Command files now nest and pick up where they left off in between
   script execution.

*  save "set" parameters on debugger entry and restore them. Inside the
   debugger: set +xv.

*  add ARG array for $1, $2 and so on. "info args" now shows these.

*  Revise and update doc for above and (hopefully) better overall
   organization.

*  Better installation instructions.
   Revise bash's top-level README and INSTALL's (debugger and top
   level) to note debugger changes.

Version 0.24
------------

*  Line numbers of initial "for var  in..." and "select" listed or stopped.
   Error messages on those lines should print correctly.

*  Rename debugger variables so as not to conflict with possible user
   variables (such as "i").

*  Don't allow stepping into debugger on program exit.
   loop on command loop in "exit" handler.

*  Function names now supported.  breakpoints can be set on them. "list" now
   allows a function name.

   To add function name support, the semantics of "declare -F" have
   changed: the source file and line number is now added in the output.

   However in non-interactive mode, the line number is wrong. It is the
   caller line.

*  These commands have been extended to include linespecs
   "continue", "break" (tbreak), "list".


Version 0.23
------------

*  More work on breakpoints and watchpoints, error checking
   * Allow breaking on file:line.
   * Give counts on number of times hit
   * Allow enabling/disabling/clearing watchpoints via "w" suffix
*  fix bugs
      handling break/watch conditions
      eval without a tty
      "-" command size wrong
      #comment handling
      make cmd_loop read safe from tampering with IFS
*  More texinfo manual revisions
*  Separate debugger tests from bash tests

Version 0.22
------------

*  More complete texinfo manual
*  Automake improvements to install Emacs lisp (Masatake YAMATO)
*  Set/show started
*  List with no arguments works like gdb and Perl's debugger
    list regression test added
*  Add frame command
*  Add signal handler for exit so we don't exit debugger when exiting program
*  case statements now indicate line number of "case WORD".

Initial release -

Initial release of something that's worthy of being called a debugger!

In contrast to earlier ksh/bash debuggers, this release has:

Line numbers and source text are reported correctly
  - through loops
  - through conditionals
  - inside functions
  - inside sourced files

A change in source file is now tracked - we don't assume one script
file nor do we create a fake script file with a funny name and run
that.

Emacs support via GUD (grand-unified debugger)

Step/next (to step inside a function or ignore it) now work
  - even works on "source"

Call stack display.
 - Since "source" is a builtin function that shows up in the call stack
 - function names, filenames and line numbers appear in call stack

Command arguments to debugged routine are left intact (if using bash
--debugger). In particular $0 is the program name.

Debugging interface similar (and largely a subset of) Perl's debugger
interface with gdb long mnemonics. (Well, okay: where - but perhaps
more in the future like "up" and "down").

Even without using *our* debugging script, there are changes to bash
that make other debugging (or writing other debuggers) more
amenable. In particular, line numbers of command substitution ``,
$(), and {}, now gives the absolute line number in the file rather
than relative to the beginning of the substitution. (So error
reporting you generally see that an unhelpful message that error
occurred on line 1.) Also support for call stacks with source files
and line numbers can be helpful for stand-alone debugging and error
reporting
