#!/bin/bash

if [ -z "$BASHRCDIR" ]
then
	BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

# CMSSW
[ -f $BASHRCDIR/cmssw.sh ] && source $BASHRCDIR/cmssw.sh

# ENVIRONMENT
LS_COLORS='di=1;36:fi=0:ln=93:pi=5:so=5:bd=5:cd=5:or=93:mi=0:ex=31:*.rpm=90:*.png=35:*.jpg=35'
export LS_COLORS
export PS1="\[\033[01;36m\]\A \[\033[01;32m\]\u@\h \[\033[01;34m\]\W \$ \[\033[00m\]"
export EDITOR=/usr/bin/vim
export SKIM_WORK_BASE=/nfs/dust/cms/user/pistone/kappa/

#export PROMPT_COMMAND='echo -ne "\033]0;${STR}${PWD##/*/}\007"'
unset PROMPT_COMMAND



# ALIASES
alias gridftp='echo "cd /pnfs/physik.rwth-aachen.de/cms/store/user/pistone"; uberftp grid-ftp'
alias ls='ls --color'
alias ll='ls -l'
alias ltr='ll -tr'

# CMSSW
alias setanalysis='setanalysis747'
alias setskim='setskimming8026'


## functions
# set the title of the xterm window
function setTitle(){
    echo -ne "\033]0;$@\007"
}

function gridinit {
	export X509_USER_PROXY=$HOME/.globus/proxy.grid
	voms-proxy-init -voms cms:/cms/dcms -valid 192:00
}

# go to SONAS space
function nfs {
	cd /nfs/dust/cms/user/pistone/
}

# go to artus samples folder
function artus {
	cd /nfs/dust/cms/user/pistone/htautau/artus/
}

# setup CRAB
function crabsetup {
	source /cvmfs/cms.cern.ch/crab3/crab.sh
	cd $CMSSW_BASE/src/Kappa/Skimming/higgsTauTau/
	gridinit
}

# skimming preparations
function skimprep {
	source /cvmfs/cms.cern.ch/crab3/slc6_amd64_gcc493/cms/crabclient/3.3.1611-comp3/etc/init-light.sh
	gridinit
}


# dCache
# https://twiki.opensciencegrid.org/bin/view/ReleaseDocumentation/LcgUtilities#Using_LCG_Utils_commands
alias mylcg-ls='lcg-ls -b -v -l -D srmv2'
alias mylcg-cp='lcg-cp -v -b -D srmv2'
alias mylcg-del='lcg-del -b -v -l -D srmv2'

# Syntax highlighting in less
VLESS=$(find /usr/share/vim -name "less.sh")
if [ ! -z $VLESS ]; then
	alias less=$VLESS
fi

# GIT
setgitcolors()
{
	git config color.branch auto
	git config color.diff auto
	git config color.interactive auto
	git config color.status auto
	git config color.ui auto
}



# Artus
function genSetup {
  export SCRAM_ARCH=slc6_amd64_gcc481
  #export PATH=/afs/desy.de/user/p/pistone/grid-control-devel:$PATH
  export PATH=~/grid-control/:$PATH
  export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
  source $VO_CMS_SW_DIR/cmsset_default.sh
  cd /nfs/dust/cms/user/pistone/genStudies/CMSSW_7_1_5/src
  eval 'cmsenv'
  #export HARRY_USERPC='lx3b07.physik.rwth-aachen.de'
  #export HARRY_REMOTE_USER='cpistone'
  source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
}

setanalysis715() {
	cd /nfs/dust/cms/user/pistone/CPStudies/CMSSW_7_1_5/src
	
	set_cmssw slc6_amd64_gcc481
	
	export HARRY_REMOTE_USER='cpistone'

	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/src/
}


setanalysis747() {
	cd /nfs/dust/cms/user/pistone/CPStudies/CMSSW_7_4_7/src
	
	set_cmssw slc6_amd64_gcc481
	
	export HARRY_REMOTE_USER='cpistone'

	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/src/
}


# Kappa
setskimming763() {
	cd /nfs/dust/cms/user/pistone/Skimming/CMSSW_7_6_3/src
	
	set_cmssw slc6_amd64_gcc493
	
	cd $CMSSW_BASE/src/
}


setskimming8020() {
	cd /nfs/dust/cms/user/pistone/Skimming/CMSSW_8_0_20/src
	
	set_cmssw slc6_amd64_gcc530
	
	cd $CMSSW_BASE/src/
}


setskimming8021() {
	cd /nfs/dust/cms/user/pistone/Skimming/CMSSW_8_0_21/src
	
	set_cmssw slc6_amd64_gcc530
	
	cd $CMSSW_BASE/src/
}


setskimming8026() {
	cd /nfs/dust/cms/user/pistone/Skimming/CMSSW_8_0_26_patch1/src
	
	set_cmssw slc6_amd64_gcc530
	
	cd $CMSSW_BASE/src/

	export PATH=$PATH:$CMSSW_BASE/src/grid-control:$CMSSW_BASE/src/grid-control/scripts

}
