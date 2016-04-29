#!/bin/bash

if [ -z "$BASHRCDIR" ]
then
	BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

# CMSSW
[ -f $BASHRCDIR/cmssw.sh ] && source $BASHRCDIR/cmssw.sh

# ENVIRONMENT
export PS1="\[\033[104m\]\h : \w \$\[\033[00m\] "
export LANG=en_US.UTF-8
export EDITOR=vim
export LS_OPTIONS="-N -T 0 --color=auto"

# ALIASES
alias scramb="scram b -j 8; echo $?"
alias myrsync="rsync -avSzh --progress"
alias myhtop="htop -u $USER"
alias gmerge="(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)"
alias myvomsproxyinit="voms-proxy-init --voms cms:/cms/dcms --valid 192:00"

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

# grid-control

# dCache
# https://twiki.opensciencegrid.org/bin/view/ReleaseDocumentation/LcgUtilities#Using_LCG_Utils_commands
alias mylcg-ls="lcg-ls -b -v -l -D srmv2"
alias mylcg-cp="lcg-cp -v -b -D srmv2"
alias mylcg-del="lcg-del -b -v -l -D srmv2"


# Artus
export USERPC="lx3b28"


setkitanalysis715() {
	#setgridcontroltrunk1501
	
	cd ~/home/cms/htt/analysis/CMSSW_7_1_5/src
	
	set_cmssw slc6_amd64_gcc481
	
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/src/
}
