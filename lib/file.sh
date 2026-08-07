# -*- shell-script -*-
# Things related to file handling.
#
#   Copyright (C) 2002-2004, 2006, 2008-2010, 2014, 2018, 2020 Rocky
#   Bernstein rocky@gnu.org
#
#   bashdb is free software; you can redistribute it and/or modify it under
#   the terms of the GNU General Public License as published by the Free
#   Software Foundation; either version 2, or (at your option) any later
#   version.
#
#   bashdb is distributed in the hope that it will be useful, but WITHOUT ANY
#   WARRANTY; without even the implied warranty of MERCHANTABILITY or
#   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#   for more details.
#
#   You should have received a copy of the GNU General Public License along
#   with bashdb; see the file COPYING.  If not, write to the Free Software
#   Foundation, 59 Temple Place, Suite 330, Boston, MA 02111 USA.

# Directory search patch for unqualified file names.
# We resolve against the current working directory first because that's most likely what the script does at runtime.
# cwd is the current working directory, _Dbg_cdir is the directory in which the script is located.
typeset -a _Dbg_dir
_Dbg_dir=( '\$cwd' '\$cdir' )

# _Dbg_cdir is the directory in which the script is located.
[[ -z ${_Dbg_cdir} ]] && typeset _Dbg_cdir="${_Dbg_source_file%/*}"
[[ -z ${_Dbg_cdir} ]] && typeset _Dbg_cdir="$(pwd)"

# Either fill out or strip filename as determined by "basename_only"
# and annotate settings
_Dbg_adjust_filename() {
  typeset -r filename="$1"
  if (( _Dbg_set_annotate == 1 )) ; then
    echo "$(_Dbg_resolve_expand_filename "$filename")"
  elif ((_Dbg_set_basename)) ; then
    echo "${filename##*/}"
  else
    echo "$filename"
  fi
}

# Canonicalize $1. For now if _Dbg_set_basename is set we just want
# the basename of that.
function _Dbg_file_canonic {
    if (( $# != 1 )) ; then
	echo '??'
	return 1
    fi
    typeset filename="$1"
    (( _Dbg_set_basename )) && filename=${filename##*/}
    echo "$filename"
    return 0
}

# $1 contains the name you want to glob. return 0 if exists and is
# readable or 1 if not.
# The result will be in variable $filename which is assumed to be
# local'd by the caller
_Dbg_tilde_expand_filename() {
  filename="${1/#\~/$HOME}"
  [[ -r "$filename" ]]
}

#
# Resolve $1 to a full file name which exists. First see if filename has been
# mentioned in a debugger "file" command. If not and the file name
# is a relative name use _Dbg_dir to substitute a relative directory name.
# '' is echo'd if no file found. Return 0 (in $?) if found, 1 if not.
#
function _Dbg_resolve_expand_filename {
  if (( $# == 0 )) ; then
    _Dbg_errmsg "Internal debug error _Dbg_resolve_expand_filename(): null file to find"
    echo ''
    return 1
  fi

  typeset find_file="$1"
  # Is this one of the files we've that has been specified in a debugger # "FILE" command?
  typeset try_find_file
  try_find_file="${_Dbg_file2canonic["$find_file"]}"
  if [[ -n "$try_find_file" ]] ; then
    echo "$try_find_file"
    return 0
  fi

  # Absolute path name
  if [[ ${find_file:0:1} == '/' ]] ; then
    try_find_file="$(_Dbg_expand_filename "$find_file")"
    if [[ -e "$try_find_file" ]] ; then
      echo "$try_find_file"
      return 0
    fi

    # Return error because absolute path does not exist
    echo ''
    return 1
  fi

  # Resolve file using _Dbg_dir
  typeset -i n=${#_Dbg_dir[@]}
  typeset -i i
  for (( i=0 ; i < n; i++ )) ; do
    typeset basedir="${_Dbg_dir[i]}"
    if [[ "$basedir" == '\$cdir' ]] ; then
      basedir="$_Dbg_cdir"
    elif [[ "$basedir" == '\$cwd' ]] ; then
      basedir="$(pwd -P)"
    fi

    try_find_file="$(_Dbg_expand_filename "$basedir/$find_file")"
    if [[ -e "$try_find_file" ]] ; then
      echo "$try_find_file"
      return 0
    fi
  done

  # Return error because no file was found
  echo ''
  return 1
}
