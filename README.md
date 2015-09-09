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

Some helpful settings for `screen` are given in the `screenrc` file. Link to it via 

    ln -s /path/to/bashrc/screenrc ~/.screenrc

The scripts/ folder contains some helpful tools:
- ro.py and rot.py, scripts to directly start a TBrowser
- superqstat.py, tool to get an overview on batch system status

Contribution
------------

Some rules for the default.sh file:
- do not source programs that others might want to source differently (e.g. ROOT, CMSSW, ...)
- do not depend on any user settings
- do not use `echo` without the test for a "dumb" terminal because this breaks `scp` etc.


CMSSW
------------
Some commands for setting up CMSSW are available, simply add

    source /full_path_to/bashrc/cmssw.sh

to your .bashrc file.

With the commands defined in cmssw.sh, e.g. `cmssw_slc6_gcc491`,
you can set the SCRAM architecture. CMSSW can then be installed with `cmsrel`,
e.g. `cmsrel CMSSW_7_4_5_ROOT5`.
