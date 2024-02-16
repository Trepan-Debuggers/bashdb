.. index:: info; variables
.. _info_variables:

Info Variables
----------------

**info variables [**-i**|**--integer**][**-r**|**--readonly**][**-x**|**--exports**][**-a**|**--indexed**][**-A*|**--associative**][**-t**|**--trace**][**-p**|**--properties**]

list global and local variable names.

Options:

    -i | --exports restricted to integer variables
    -r | --readonly restricted to read-only variables
    -x | --exports restricted to exported variables
    -a | --indexed restricted to indexed array variables
    -A | --associative restricted to associative array variables
    -t | --trace restricted to traced variables
    -p | --properties display properties of variables as printed by declare -p


Examples:
+++++++++

::

    info variables        # show all variables
    info variables -p     # show all variables with their properties
    info variables -r     # show only read-only variables
    info variables -i     # show only integer variables
