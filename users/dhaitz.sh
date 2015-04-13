#!/bin/bash
#personal bashrc for dhaitz

[ -f ~berger/sw/ekpini.sh ] && . ~berger/sw/ekpini.sh batch

export PATH=/usr/users/dhaitz/home/git/grid-control:/usr/users/dhaitz/.local/bin:$PATH

# source CMSSW; initialize Excalibur
cal()
{
    # source CMSSW path according to host
    if [[ `hostname` == *ekpcms5* ]]; then
        cd ~/home/CMSSW_5_3_14_patch2
        cmssw_slc5_gcc462
        cd ../git/excalibur/
        source scripts/ini_excalibur
        alias merl='merlin -NL'
    elif [[ `hostname` == *ekpcms6* ]]; then
        cd ~/home/artus/CMSSW
        set_cmssw `ls bin`
        cd ~/home/artus/Excalibur
        . scripts/ini_excalibur.sh
        . ini_merlin.sh
    elif [[ `hostname` == *naf* ]]; then
        cd ~/CMSSW_5_3_14_patch2
        cmssw_slc6_gcc472
        cd ../git/excalibur/
        source scripts/ini_excalibur
    elif [[ `hostname` == *ekpsg01* ]]; then
        cd ~/excalibur-test//CMSSW_5_3_22
        cmssw_slc6_gcc472
        cd ../excalibur/
        source scripts/ini_excalibur
    else
        echo "unknown HOST"
    fi
}
alias merl="merlin.py --live evince"
alias superqstat="superqstat.py -S"
alias qcd="cd $HOME/home/qcd/sherivf && . scripts/ini.sh"
alias rot="rot.py"

alias gridui=". /cvmfs/grid.cern.ch/emi-wn-3.7.3-1_sl6v2/etc/profile.d/setup-emi3-wn-example.sh"
alias grid="~berger/sw/ekpini.sh grid"

roo()
{
	ro.py $@ &
}

cmssw()
{
	cd ~/home/artus/CMSSW
	set_cmssw `ls bin`
	cd -
}
export DATE=`date +%Y_%m_%d`

if [[ `hostname` == *ekp* ]]; then
    export CMSSW_GIT_REFERENCE=/storage/a/${USER}/.cmsgit-cache
fi

copykrb5()
{
    KRB5_PATH=$HOME/.krb5_cache
    CREDENTIAL_PATH=${KRB5CCNAME/FILE:/}
    # Move to Home
    cp ${CREDENTIAL_PATH} $KRB5_PATH
    # Reset KRB5CCNAME
    export KRB5CCNAME=FILE:$KRB5_PATH
}

alias scr='scram b -j 10'
scra()
{
    (cd ${CMSSW_BASE}/src && scr)
}

xcopy()
{
    #xrdcp -f root://cms-xrd-global.cern.ch/$1 /storage/a/${USER}/$2
    xrdcp root://xrootd.unl.edu/$1 /storage/a/${USER}/$2
}

alias gotrunk.py='${HOME}/git/grid-control/go.py'
alias gostable.py='${HOME}/git/gc-stable/go.py'
if [ $HOSTNAME == "ekpcms5" ]; then
    alias gostable.py='${HOME}/home/git/gc-stable/go.py'
    alias gofixes.py='${HOME}/home/git/gc-fixes/go.py'
fi

alias mak='make -j -B'

export CVSROOT=$USER@cmscvs.cern.ch:/cvs_server/repositories/CMSSW
export HISTSIZE=100000000
export HISTCONTROL=ignoredups

scree () { screen -t $1 -S $1; }

#TODO move some of this stuff to the git config
alias gits="git status"
alias gitc="git commit"
alias gita="git add"
alias gitd="git diff"
alias gitkk='gitk --all &'
alias gmerge="(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)"

alias autoformat='for i in `find . -name "*.formatted"`; do mv $i ${i%.*}; done'

alias evil5="cmssw_slc5_gcc462"
alias evil6="cmssw_slc6_gcc472"
alias evil7="cmssw_slc6_gcc481"
alias evil8="cmssw_slc6_gcc491"

# script to calculate the average number of evts/s from the output of a 
# excalibur run with grid-control.
averageEvents ()
{(
    find $1 -name job.stdout.gz | xargs less | grep Status | cut -d"-" -f 3 | cut -d"/" -f 1 > /tmp/averageEvents_$USER.txt
    awk '{sum+=$1; echo $1} END { print "Average = ",sum/NR}' /tmp/averageEvents_$USER.txt
)}
