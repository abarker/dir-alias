.. default-role:: code

dir-alias
#########

Define fancier Bash aliases for commonly-used directories.  These do not
conflict with ordinary Bash aliases except that only one can use any particular
alias name.  This script makes use of the fact that functions and variables in
Bash have distinct namespaces.

::

   Usage: dir-alias <shortcut-name> [<directory-path>] [-c <command-to-run>]"

The `dir-alias` command:

* Defines the alias name as a shell function to `cd` to the directory.

* Defines the alias name as a shell variable to access the directory-path
  string easily.

* Optionally takes an arbitrary command string after `-c` to execute after
  performing the directory change.  (The directory argument is optional when a
  command is passed in.  The passed-in command can optionally take its own
  arguments.)

* Exports the function and variable so they can be used in shell scripts.

* Allows the use of previously-defined directory-alias variables in the
  definition of new ones.

Usage
-----

Here is a basic `dir-alias` usage:

.. code-block:: bash

   dir_alias proj ~/programming/my_project/proj_dir # Simple directory alias.

   # Now there is a shell varible proj holding the directory name:
   ls $proj # Executes an ls of the directory ~/programming/my_project/proj_dir 

   # There is also a shell function defined to cd to the directory:
   proj # Executes a cd to ~/programming/my_project/proj_dir 

This is a `dir-alias` command with an optional command-string to execute after the `cd`:

.. code-block:: bash

   dir_alias my_tmp ~/tmp -c "echo 'You are in ~/tmp directory'"

Finally, here are some `dir-alias` commands that work similar to regular Bash
aliases in that they are not assocated with a directory and so do not perform a
`cd` operation automatically.  No shell variable is set in these cases.  The
examples here also take argments.

.. code-block:: bash

   dir-alias demo -c "echo first arg is \$1 and second arg is \$2"

   demo a b # Prints out "first arg is a and second arg is b".

   # A dir-alias that acts an like ordinary Bash alias, on the rest of the command line.
   dir-alias ls -c "ls -a \$@"

To display all the aliases defined with `dir-alias` you can type `dir-alias`
with no arguments.  The command will print out all the aliases defined by
`dir_alias` in a neat format.  Any aliases which shadowed an existing command
at the time it was defined, excluding shell functions or a regular Bash
aliases, are marked with a ``*`` symbol after the alias name in the listing.

The command `aliases` is also defined to list all the regular Bash aliases
followed by all the aliases defined by `dir-aliases`, in a similar format.

To unset the function, shell variable, and remove the alias from the list of
directory aliases use `un-dir-alias <alias-name>`.

Setup
-----

Just clone this repo or copy the file `dir_alias_commands.bash` somewhere and
source it in your `~/.bashrc` like this:

.. code-block:: bash

   source dir_alias_commands.bash

After that command you can use `dir-alias` in your `.bashrc` as well as in your
interactive shells.

