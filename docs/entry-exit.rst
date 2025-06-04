Entering the Bash Debugger
**************************

.. toctree::
.. contents::

Startup Behavior
================

You can customize bashdb's initialization process such as setting up
breakpoints to facilitate complex issue trouble shooting. This can be achieved
by creating per-user or per-project rc files named ``.bashdbrc`` under your
home directory or any directory in your project. The per-user rc file is loaded
first, followed by the per-project rc file. Therefore, you can override
settings in your per-project ``.bashdbrc`` file.

The follow code snippet demonstrates a per-project ``.bashdbrc`` with a few
breakpoints configured:

.. code:: console

        $ cd my-project
        $ cat .bashdbrc

        # explicit load is required to make
        # code in this file available to bashdb
        load ./libs/functions.sh
        break ./main.sh:13 $cmd == "start"
        break ./libs/functions.sh:332

Currently explicit loading of programs invoked by main script is required.
Therefore, in this example, the ``load`` command makes the code defined in the
``libs/functions.sh`` available to the debugging session. Once the per-project
``.bashdbrc`` is configured, you can launch the debugger under the directory
where the ``.bashdbrc`` located as follows:

.. code:: console

        $ bashdb main.sh start

        bash debugger, bashdb, release 5.2-1.1.2

        Copyright 2002-2004, 2006-2012, 2014, 2016-2019, 2021, 2023-2024 Rocky Bernstein
        This is free software, covered by the GNU General Public License, and you are
        welcome to change it and/or distribute copies of it under certain conditions.

        (/home/user/my-project/main.sh:3):
        3:      source ./libs/functions.sh
        File /home/user/my-project/libs/functions.sh loaded.
        Breakpoint 1 set in file /home/user/my-project/libs/functions.sh, line 332.
        Breakpoint 2 set in file /home/user/my-project/main.sh, line 13.
        bashdb<4> info breakpoints
        Num Type       Disp Enb What
        1   breakpoint keep y   /home/user/my-project/libs/functions.sh:332
        2   breakpoint keep y   /home/user/my-project/main.sh:13
                stop only if $cmd == "start"

In this example, bashdb shows the two breakpoints presetted by the
``.bashdbrc`` file when it finishes startup. The ``info breakpoints`` command,
abbreviated as ``i b``, reveals the second breakpoint is a conditional
breakpoint.

Invoking the Debugger Initially
===============================

The simplest way to debug your program is to run ``bashdb``. Give
the name of your program and its options and any debugger options:

.. code:: console

        $ cat /etc/profile

        if [ "${PS1-}" ]; then
            if [ "`id -u`" -eq 0 ]; then
              PS1='# '
            else
              PS1='$ '
            fi
          fi
        fi

        if [ -d /etc/profile.d ]; then
          for i in /etc/profile.d/*.sh; do
            if [ -r $i ]; then
              . $i
            fi
          done
          unset i
        fi

        $ bashdb /etc/profile

For help on ``bashdb`` or options, use the ``--help`` option.

.. code:: console

        $ bashdb --help

	Usage:
           bashdb [OPTIONS] <script_file>

        Runs bash <script_file> under a debugger.

        options:
        ...



Calling the debugger from your program
======================================

Sometimes it is not possible to invoke the program you want debugged
from the ``bashdb`` or from ``bash --debugger``.

Although the debugger tries to set things up to make it look like your
program is called, sometimes the differences matter. Also, once the debugger
is loaded this can slows in parts that you do not want to debug.

So instead, you can add statements into your program to call the
debugger at the spot in the program you want. To do this, you source
``bashdb/dbg-trace.sh`` from where wherever it appears on your
filesystem.  This needs to be done only once.

After that, you call ``_Dbg_debugger``.

Consider the example of the previous section, but you to debug
``/etc/profile.d/bash_completion.sh`` and skip over the other default
profile scripts at high speed. Here is how you might do this:

.. code:: console

        if [ "${PS1-}" ]; then
          # 15 lines omitted
        fi

        if [ -d /etc/profile.d ]; then
          for i in /etc/profile.d/*.sh; do
            if [ -r $i ]; then
              if [[ $i == "/etc/profile.d/bash_completion.sh"; then
                # Load in debugger
                . /usr/share/bashdb/bashdb-trace -q
                # Call debugger
                _Dbg_debugger
              fi
              . $i
           fi
          done
         unset i
        fi

Until the first call to ``_Dbg_debugger``, there is no debugger overhead.

Note that ``_Dbg_debugger`` causes the statement *after* the call to be stopped.
