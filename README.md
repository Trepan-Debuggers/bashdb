[![Build Status Circle](https://circleci.com/gh/rocky/bashdb.svg?&style=shield)](https://circleci.com/gh/rocky/bashdb)

[![Packaging status](https://repology.org/badge/vertical-allrepos/zshdb.svg)](https://repology.org/project/zshdb/versions)

Here, we have a debugger for Bash 5.2 and higher.

Other branches in this repository support earlier versions of Bash. For example, use branch 4.1 for Bash version 4.1.

The command syntax generally follows that of the [zsh debugger ](https://github.com/rocky/zshdb), trepanning debuggers and, more generally, GNU debugger *gdb*.

There are 3 ways to get into the debugger. If bash (with debugger support enabled which is the default) is installed and the debugger are *both* installed properly. Then:

```
   bash --debugger -- bash-script-name script-arg1 script-arg2...
```

If bash isn't installed in a way that will find bashdb, then:

```
   bashdb [bashdb-opts] -- bash-script-name script-arg1 script-arg2...
```

The downside here is that $0 will be "bashdb" not
bash-script-name. Also call stack will show the invocation to bashdb.

Finally, to invoke the debugger from the script

```
  # my script
  # work, work, work, ...

  # Load debugger support
  source <bashdb-installation>/bashdb-trace -L <bashdb-installation>
  # work, work, work or not...
  _Dbg_debugger; :   # Calls the debugger at the line below
  stop_here
```

An advantage of the above is that there is no overhead up until you
invoke the debugger. Typically for large bash programs like
configuration scripts, this is a big win.

*IMPORTANT NOTE IF YOU USE THE ABOVE TO DEBUG CONFIGURE SCRIPTS...*

stdin is closed by configure early on. This causes the debugger to quit.
You can get around this invoking a command script that sets debugger
up input and output. Run tty to figure out what the terminal tty is set to.

```
  $ tty
  /dev/pts/3
  $
```

Above it came out to */dev/pts/3*. Let's go with that. Put the folliwng
in a file say */tmp/bashdb-configure*

```
  source /dev/pts/3
  tty /dev/pts/3
```

Now arrange to read that configuration file using the *-x* or *--eval-command*
switch:

```
  source <bashdb-installation>/bashdb-trace -L <bashdb-installation> -x /tmp/bashdb-configure
```

* [manual page](http://bashdb.sourceforge.net/bashdb-man.html)

See *INSTALL* for generic GNU configure installation instructions.
