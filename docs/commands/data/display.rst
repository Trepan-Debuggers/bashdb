.. index:: display
.. _display:

Set a Display Expression (``display``)
--------------------------------------

**display** [*stmt*]

Evaluate *stmt* each time the debugger is stopped. If *stmt* is omitted, evaluate
all of the display statements that are active. In contrast, **info display**
shows the display statements without evaluating them.

Examples:
+++++++++

::

   display echo $x  # show the current value of x each time debugger stops
   display          # evaluate all display statements


.. seealso::

   :ref:`undisplay <undisplay>` to cancel display requests previously made, and
	`info display <info_display>`.
