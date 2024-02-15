.. index:: tbreak
.. _tbreak:

Set a Temporary Breakpoint (tbreak)
-----------------------------------

**tbreak** [ *location* ] [**if** *condition*]

With a line number argument, set a break there in the current file.
With a function name, set a break at first executable line of that
function.  Without argument, set a breakpoint at current location.  If
a second argument is `if`, subsequent arguments given an expression
which must evaluate to true before the breakpoint is honored.

The location line number may be prefixed with a filename or module
name and a colon.

Examples:
+++++++++

::

   tbreak     # Break where we are current stopped at
   tbreak 10  # Break on line 10 of the file we are currently stopped at
   tbreak /etc/profile:10   # Break on line 10 of /etc/default
   tbreak myfile:45    # Use relative file name

.. seealso::

   :ref:`break <break>`, :ref:`condition <condition>`, :ref:`delete <delete>`.
