.. index:: set; autolist
.. _set_autolist:

List Statements on Debugger Entry (`set auto list`)
---------------------------------------------------

**set autolist** [ **on** | **off** ]

Run the :ref:`list <list>` command every time you stop in the
debugger.

With this, you will get output like:

::

    bashdb<0> set autolist on
    Auto run of 'list' command is on.
    bashdb<1> s
    (/etc/profile:20):
    20:	if [ -d /etc/profile.d ]; then
     15:          PS1='$ '
     16:        fi
     17:      fi
     18:    fi
     19:
     20: => if [ -d /etc/profile.d ]; then
     21:      for i in /etc/profile.d/*.sh; do
     22:        if [ -r $i ]; then
     23:          . $i
     24:        fi
    bashdb<2> s
    (/etc/profile:21):
     21:	  for i in /etc/profile.d/*.sh; do
     16:        fi
     17:      fi
     18:    fi
     19:
     20:    if [ -d /etc/profile.d ]; then
     21: =>   for i in /etc/profile.d/*.sh; do
     22:        if [ -r $i ]; then
     23:          . $i
     24:        fi
     25:      done

.. seealso::

   :ref:`show autolist <show_autolist>`
