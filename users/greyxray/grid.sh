#!/bin/bash
# Grid certificates
echo " * --> export greyxray/grid.sh"

alias vpi='voms-proxy-info -all'
alias myvomsproxyinit='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'
export X509_USER_PROXY=$HOME/.globus/x509up

# rwth
alias gridftp='echo "cd /pnfs/physik.rwth-aachen.de/cms/store/user/ohlushch"; uberftp grid-ftp'
# alias vpi='voms-proxy-init -voms cms:/cms/dcms -valid 192:00'
