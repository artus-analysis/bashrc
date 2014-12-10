Shared .bashrc
==============

Usage
-----

    git clone https://github.com/artus-analysis/bashrc.git
    cd ~
    ln -s $OLDPWD/bashrc/default .bashrc

Instead of the last line, you can:

1. use your own `.bashrc` file and source the parts you like
2. create your own `username` file in this repository and
   link to it instead of linking to `default`.

The gitconfig can be used in your ~/.gitconfig file as:

    [include]
        path = /path/to/bashrc/gitconfig

Contribution
------------

Some rules for the default file:
- do not source programs that others might want to source differently (e.g. ROOT, CMSSW, ...)
- do not depend on any user settings
- do not use `echo` without the test for a "dumb" terminal because this breaks `scp` etc.


