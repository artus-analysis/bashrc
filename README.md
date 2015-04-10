Shared .bashrc
==============

Usage
-----

    git clone https://github.com/artus-analysis/bashrc.git

Then create `.bashrc` file in your home directory and add the following line

    source /full_path_to/bashrc/default.sh

You can also create your own `username` file in the `users` subdirectoy, it will get sourced by `default.sh`.

The gitconfig can be used in your ~/.gitconfig file as:

    [include]
        path = /path/to/bashrc/gitconfig

Contribution
------------

Some rules for the default.sh file:
- do not source programs that others might want to source differently (e.g. ROOT, CMSSW, ...)
- do not depend on any user settings
- do not use `echo` without the test for a "dumb" terminal because this breaks `scp` etc.


