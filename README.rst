.. default-role:: code

dir-alias
#########

Define fancier aliases in Bash for commonly-used directories.

The `dir-alias` command:

* Defines the alias name as a shell function to `cd` to the directory.

* Defines the alias name as a shell variable to access the directory string easily.

* Optionally takes an arbitrary command string after `-c` to run after
  performing the directory change.  (The directory argument is optional when a
  command is passed in, so `dir-alias` can also be used like ordinary Bash
  aliases.)

* Exports the function and variable so they can be used in shell scripts.

* Allows the use of previously-defined directory aliases in the definition of
  new ones.

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

