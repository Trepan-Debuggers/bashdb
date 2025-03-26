# To install from the sourceforge git repository

## Prerequisites

You'll need autotools and related packages

* autoconf
* automake
* autoheader

You'll also need packages:

* texinfo

## Get sources

Sources are in git.

```
   $ git clone https://github.com/Trepan-Debuggers/bashdb
   $ cd bashdb
```

## Build configure

```
   $ bash ./autogen.sh
```

## Make code

```
   $ bash ./configure
```

## Make and test code

```
   $ make # but I prefer remake better
   $ make check
```

## Install
   $ make install # may need sudo
