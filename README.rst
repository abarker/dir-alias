.. default-role:: code

dir-alias
#########

Fancier Bash aliases for commonly-used directories.  These do not
conflict with ordinary Bash aliases except that only one can use any particular
alias name.

The `dir-alias` command:

* Defines the alias name as a shell function to `cd` to the directory.

* Defines the alias name as a shell variable to access the directory-path
  string easily.

* Optionally takes an arbitrary command string after `-c` to execute after
  performing the directory change.  (The directory argument is optional when a
  command is passed in.  The passed-in command can optionally take its own
  arguments.)

* Exports the function and variable so they can be used in shell scripts.

* Allows the use of previously-defined directory-aliases variables in the
  definition of new ones.

Usage
-----

This is a basic `dir-alias` usage:

.. code-block:: bash

   dir_alias proj ~/programming/my_project/proj_dir # Simple directory alias.

   # Now there is a shell varible proj holding the directory name:
   ls $proj # Executes an ls of the directory ~/programming/my_project/proj_dir 

   # There is also a shell function defined to cd to the directory:
   proj # Executes a cd to ~/programming/my_project/proj_dir 

This is a `dir-alias` command that also has an optional command-string:

.. code-block:: bash

   dir_alias my_tmp ~/tmp -c "echo 'You are in ~/tmp directory'"

These are `dir-alias` commands that work similar to regular Bash aliases.

.. code-block:: bash

   dir-alias demo -c "echo first arg is \$1 and second arg is \$2"

   demo a b # Prints out "first arg is a and second arg is b".

   # A dir-alias that acts an like ordinary Bash alias, on the rest of the command line.
   dir-alias ls -c "ls -a \$@"

To display these aliases there are two new functions that work similar to calling
`alias` with no arguments:

* `show-dir-aliases`: List all the aliases defined by `dir_alias` in a neat format.
  Any aliases which shadowed an existing command other than a shell function or a
  regular Bash alias are marked with at "*" symbol after the alias name.

* `aliases`: List all the regular Bash aliases followed by all the aliases defined
  by `dir-alias`.

Setup
-----

Just clone this repo or copy the file `dir_alias_commands.bash` somewhere and
source it in your `~/.bashrc` like this:

.. code-block:: bash

   source dir_alias_commands.bash

After that command you can use `dir-alias` in your bashrc as well as in your
interactive shells.
