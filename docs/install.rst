How to install
****************

.. toctree::


From a Package
----------------

Repology_ maintains a list of various bundled ``bashdb`` packages. Below are some specific distributions that contain ``bashdb``.

At the time this documentation was built, here is status that they provide:

|packagestatus|

Check the link above for more up-to-date information.


.. |packagestatus| image:: https://repology.org/badge/vertical-allrepos/bashdb.svg
		 :target: https://repology.org/project/bashdb/versions


MacOSX
+++++++

On OSX systems, you can install from Homebrew or MacPorts_.

.. code:: console

    $  brew install bashdb


From Source
------------

Github
++++++


Many package managers have back-level versions of this debugger. The most recent versions is from the github_.

To install from git:

.. code:: console

        $ git clone git://github.com/rocky/bashdb.git
        $ cd bashdb
        $ ./autogen.sh  # Add configure options. See ./configure --help


If you've got a suitable ``bashhb`` installed, then

.. code:: console

        $ make && make test


To try on a real program such as perhaps ``/etc/profile``:

.. code:: console

      $ ./bashdb -L /etc/profile # substitute /etc/profile your favorite bash script

To modify source code to call the debugger inside the program:

.. code:: console

    source path-to-bashdb/bashdb/dbg-trace.sh
    # work, work, work.

    _Dbg_debugger
    # start debugging here


Above, the directory *path-to_bashdb* should be replaced with the
directory that `dbg-trace.sh` is located in. This can also be from the
source code directory *bashdb* or from the directory `dbg-trace.sh` gets
installed directory. The "source" command needs to be done only once
somewhere in the code prior to using `_Dbg_debugger`.

If you are happy and `make test` above worked, install via:

.. code:: console

    sudo make install


and uninstall with:

.. code:: console

    $ sudo make uninstall # ;-)


.. _MacPorts: https://ports.macports.org/port/bashdb/summary
.. _Repology: https://repology.org/project/bashdb/versions
.. _github: https://github.com/rocky/bashdb
