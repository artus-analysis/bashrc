#!/bin/bash
#echo "Ok bash, ohlushch.sh is for cern machine"
source  ~/bashrc/users/hlushchenko_common.sh

# law
source /afs/cern.ch/user/m/mrieger/public/law_sw/setup.sh

# b bril lumi tool
export PATH=$HOME/.local/bin:/afs/cern.ch/cms/lumi/brilconda-1.1.7/bin:$PATH

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -z "$BASHRCDIR" ]
then
    BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi
#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#cd $0
DIR_PRIVATESETTINGS=${HOME}/dirtyscripts
source ${DIR_PRIVATESETTINGS}/env_scripts/git-prompt.sh
#-------------------------------------------------------------
# Terminal colors
#-------------------------------------------------------------
[ -f "$BASHRCDIR/dir_colors" ] && eval `dircolors $BASHRCDIR/dir_colors` || eval `dircolors -b`
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -h --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    alias ls='ls -h'
fi
# Syntax highlighting in less
VLESS=$(find /usr/share/vim -name "less.sh")
if [ ! -z $VLESS ]; then
    alias less=$VLESS
fi
# User specific aliases and functions
#
#case $- in
#*i*)    # interactive shell
#source /afs/cern.ch/eng/clic/software/setupSLC6.sh #source /afs/cern.ch/eng/clic/software/scripts/setupSLC6.sh
#;;
#*)      # non-interactive shell
#;;
#esac
#source setupSLC6.sh


#-------------------------------------------------------------
# CERN specific
#-------------------------------------------------------------
export EDITOR=vim
export LS_OPTIONS="-N -T 0 --color=auto"
# Packages
export PATH=${HOME}/sublime:$PATH
PATH=$PATH:$HOME/bin
export PATH=/afs/cern.ch/sw/XML/texlive/latest/bin/x86_64-linux:$PATH
#export PYTHONPATH=/home/ohlushch/python_packages/lib/python2.7/site-packages:$PYTHONPATH
# Castor
export RFIO_USE_CASTOR_V2=yes
export STAGE_SVCCLASS=ilcdata
export STAGE_HOST=castorpublic
# Aliases
alias pushbash='cd ~/bashrc; git pull; git add -p; git commit -m "olena:from cern"; git push; cd -'
alias vimbash="vim ~/bashrc/users/ohlushch_cern.sh"
alias vimbashcommon="vim ~/bashrc/users/hlushchenko_common.sh"
alias meld='export PATH=/usr/bin/:$PATH && meld'
alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'

setsshaggent()
{
        eval "$(ssh-agent -s)"
        ssh-add  ~/.ssh/id_rsa
}


#-------------------------------------------------------------
# CMS specific
#-------------------------------------------------------------
alias scramb='scram b -j $CORES; echo $?; tput bel'
alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'

# CMSSW
[ -f $BASHRCDIR/cmssw.sh ] && source $BASHRCDIR/cmssw.sh

## CMSSW working environments
alias setkitanalysis=''
alias setkitskimming=''

# dCache
# https://twiki.opensciencegrid.org/bin/view/ReleaseDocumentation/LcgUtilities#Using_LCG_Utils_commands
alias myvomsproxyinit='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'
alias mylcg-ls='lcg-ls -b -v -l -D srmv2'
alias mylcg-cp='lcg-cp -v -b -D srmv2'
alias mylcg-del='lcg-del -b -v -l -D srmv2'
# Job Submission
alias setcrab3='source /cvmfs/cms.cern.ch/crab3/crab.sh'
alias setcrab='setcrab3'

export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh
#-------------------------------------------------------------
# CMS environments
#-------------------------------------------------------------
setrelval940()
{
    cd /afs/cern.ch/user/o/ohlushch/workspace/CMSSW_9_4_0_pre3/src/
    SCRAM_ARCH=slc6_amd64_gcc630; export $SCRAM_ARCH
    cmsenv
}

setrelval1030()
{
    # cd /afs/cern.ch/user/o/ohlushch/workspace/CMSSW_10_2_0_pre2/src/
    cd /afs/cern.ch/user/o/ohlushch/workspace/relVal/CMSSW_10_3_0_pre4/src/
    SCRAM_ARCH=slc6_amd64_gcc700; export $SCRAM_ARCH
    cmsenv
}

# Mass regression
setmass9413UL1()
{
    cd /afs/cern.ch/user/o/ohlushch/workspace/Nostradamass/ntupleBuilder
    SCRAM_ARCH=slc6_amd64_gcc630
    source /cvmfs/cms.cern.ch/cmsset_default.sh
    scram project CMSSW CMSSW_9_4_13_UL1
    cd CMSSW_9_4_13_UL1/src
    eval `scramv1 runtime -sh`
}

setmass947()
{
    cd /afs/cern.ch/user/o/ohlushch/workspace/Nostradamass/ntupleBuilder
    SCRAM_ARCH=slc6_amd64_gcc630
    source /cvmfs/cms.cern.ch/cmsset_default.sh
    scram project CMSSW CMSSW_9_4_7
    cd CMSSW_9_4_7/src
    eval `scramv1 runtime -sh`
}


setmass940patch1()
{
    cd /afs/cern.ch/user/o/ohlushch/workspace/Nostradamass/ntupleBuilder
    SCRAM_ARCH=slc6_amd64_gcc630
    source /cvmfs/cms.cern.ch/cmsset_default.sh
    scram project CMSSW CMSSW_9_4_0_patch1
    cd CMSSW_9_4_0_patch1/src
    eval `scramv1 runtime -sh`
}

setmass931()
{
    cd /afs/cern.ch/user/o/ohlushch/workspace/Nostradamass/ntupleBuilder
    SCRAM_ARCH=slc6_amd64_gcc630
    source /cvmfs/cms.cern.ch/cmsset_default.sh
    scram project CMSSW CMSSW_9_3_1
    cd CMSSW_9_3_1/src
    eval `scramv1 runtime -sh`
}
setmass9210()
{
    cd /afs/cern.ch/user/o/ohlushch/workspace/Nostradamass/ntupleBuilder
    echo "### Set up CMSSW"
    SCRAM_ARCH=slc6_amd64_gcc630
    source /cvmfs/cms.cern.ch/cmsset_default.sh
    scram project CMSSW CMSSW_9_2_10
    cd CMSSW_9_2_10/src
    eval `scramv1 runtime -sh`
}

renewablekinit() {
   while true;
   do
      kinit -R
      aklog
      sleep 21600
   done
}
#kinit -l 48h -r 100d
#renewablekinit &

setharry ()
{
    temp_pwd=$PWD
    # export SCRAM_ARCH=slc6_amd64_gcc630
    export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
    source $VO_CMS_SW_DIR/cmsset_default.sh
    cd ~/workspace/HP/CMSSW_8_1_0/src/

    # set_cmssw slc6_amd64_gcc630;
    source /afs/cern.ch/user/o/ohlushch/workspace/HP/CMSSW_8_1_0/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh;
    # CREDENTIAL_PATH=${KRB5CCNAME/FILE:/};
    # LOCAL_KERBEROS_PATH=${HOME}/.krb/HP/$(basename $CREDENTIAL_PATH);
    # if test -f "$LOCAL_KERBEROS_PATH"; then
    #     echo "$LOCAL_KERBEROS_PATH exist";
    # else
    #     cp ${CREDENTIAL_PATH} $LOCAL_KERBEROS_PATH;
    # fi;
    # echo "$KRB5CCNAME  -->  FILE:$LOCAL_KERBEROS_PATH";
    # export KRB5CCNAME=FILE:$LOCAL_KERBEROS_PATH;
    # changeHistfile ${FUNCNAME[0]}
    cd $temp_pwd
}
# GIT Aliases
alias pullArtus='cd $CMSSW_BASE/src/Artus; git fetch origin; git merge origin/master; cd -'
alias pullKappaTools='cd $CMSSW_BASE/src/KappaTools;git fetch origin; git merge origin/master; cd -'
alias pullHtTT='cd $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/; git fetch origin; git merge origin/master; cd -'
alias pullKappa='cd $CMSSW_BASE/src/Kappa; git fetch origin; git merge origin/master; cd -'
alias pullall='pullArtus; pullKappaTools; pullHtTT; pullKappa'
alias scramball='cd $CMSSW_BASE/src; scramb ; cd -'
alias pullandscramb='pullall; scramball'
