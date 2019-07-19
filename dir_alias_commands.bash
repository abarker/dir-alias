# This file must be sourced from Bash; it will not work if executed as a normal script.
if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    echo "Usage: source dir_aliases_commands.bash"
    exit 1
fi
# The MIT License (MIT)
# Copyright (c) 2019 Allen Barker
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#
# This file contains the definition of the dir-alias command, along with the
# commands show-dir-aliases and aliases to display alias information.
#

DIR_ALIAS_PREFIX="dir_alias_info_" # Listing info is stored in vars with this prefix.

dir-alias() {
   usage="Usage: dir-alias <shortcut-name> [<directory-path>] [-c <command-to-run>]"
   #
   # This command creates both a shell function that changes to the directory
   # and a shell variable which contains the directory name (so you can use $
   # access the directory path to use in another command).  An optional command
   # to be executed can be passed as a string after a `-c` flag at the end.  It
   # runs after any directory change.
   #
   # Any existing shell function or ordinary alias is deleted and a new shell
   # function is created.
   #
   # Previously-defined dir-alias aliases can be used in the definition of later
   # ones.  The definitions are exported so scripts can also use them.
   local hide_indicator cmd dirname alias_name alias_type
   if [ "$1" == "" ]; then
      show-dir-aliases
      return 0
   elif [ "$2" == "" ]; then
      echo $usage
      echo "A single argument is not valid to pass to dir-alias ("$1")."
      return 1
   fi

   # Get the alias name.
   alias_name="$1"
   unset -f "$alias_name" # A new shell function will be defined; delete old one.
   unalias "$alias_name" 2>/dev/null # Remove any ordinary alias of the same name.
   alias_type=$(type -t "$alias_name")
   if [ "$alias_type" != "function" ] && [ "$alias_type" != "alias" ] && [ "$alias_type" != "" ]; then
      hide_indicator="*"
   fi

   # Get the directory name.
   shift
   if [ "$1" == "-c" ]; then
      dirname=""
   else
      dirname="$1"
      shift
   fi

   # Get the command.
   cmd=""
   if [ "$1" != "" ]; then
      if [ "$1" != "-c" ]; then
         echo $usage
         echo "A -c flag is required before the command string passed to dir-alias ('$alias_name')."
         return 1
      elif [ "$2" == "" ]; then
         echo $usage
         echo "An empty command string was passed to the -c argument to dir-alias ('$alias_name')."
         return 1
      elif [ "$3" != "" ]; then
         echo $usage
         echo "Too many arguments to dir-alias ('$alias_name').  Any command passed in must be quoted."
         return 1
      fi
      cmd="$2"
   fi

   # Define and export the shell function.  Info is stored in variables with
   # prefix $DIR_ALIAS_PREFIX because Bash cannot export arrays.
   if [ "$dirname" == "" ]; then
      eval "$alias_name() { $cmd; }" # Define shell fun with given name.
      eval 'export ${DIR_ALIAS_PREFIX}$alias_name="${alias_name}${hide_indicator} -c \"$cmd\""'
   elif [ "$cmd" == "" ]; then
      eval "$alias_name() { cd \"$dirname\"; }" # Define shell fun with the given name.
      eval 'export ${DIR_ALIAS_PREFIX}$alias_name="${alias_name}${hide_indicator} -- \"$dirname\""'
   else
      eval "$alias_name() { cd \"$dirname\"; $cmd; }" # Define shell fun with given name.
      eval 'export ${DIR_ALIAS_PREFIX}$alias_name="${alias_name}${hide_indicator} -- \"$dirname\" -c \"$cmd\""'
   fi
   export -f "$alias_name" # Export the function.

   # Define and export the shell variable if a directory name is associated with the command.
   if [ "$dirname" != "" ]; then
      eval export $alias_name='"$dirname"' # Quoted to handle spaces in dir names.
   fi
}

show-dir-aliases() {
   # Usage: show-dir-aliases
   #
   # Sort and show the list of directory aliases.  Any which shadow existing
   # commands (other than shell functions and ordinary aliases) are also marked
   # with a asterisk after the alias name.

   # Get an array of all the info variables set for dir-alias aliases.
   eval 'info_vars=(${!'"$DIR_ALIAS_PREFIX"'@})'
   info_strings=()
   for i in "${info_vars[@]}"; do
      info_strings+=("$(eval "echo \$$i")")
   done
   # Get a sorted array of all the values.
   IFS=$'\n' sorted=($(sort <<<"${info_strings[*]}")) # Sort the strings.

   for i in "${sorted[@]}"
   do
      echo $i
   done
}

aliases() {
   # Usage: aliases
   #
   # Prints out a nicer looking version of the plain alias command followed
   # by the aliases set with dir-aliases.  The show-dir-aliases command is used to
   # display the latter.

   echo "Regular aliases:"
   echo "================"
   alias | sed 's/^alias //' | sed 's/\=/ -- /'
   echo
   echo "Directory aliases:"
   echo "=================="
   show-dir-aliases
}

un-dir-alias() {
   # Usage: un-dir-alias <alias-name>

   unset ${DIR_ALIAS_PREFIX}$1
   unset -f "$1"
   unset "$1"
}

