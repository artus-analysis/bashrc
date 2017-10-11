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
export LS_OPTIONS='-N -T 0 --color=auto'

# ALIASES
alias scramb='scram b -j 8; echo $?'
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
alias gmerge="(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)"
alias myvomsproxyinit="voms-proxy-init --voms cms:/cms/dcms --valid 192:00"
alias gitpullcmssw='git fetch origin && git merge origin/master'

alias pullArtus='cd $CMSSW_BASE/src/Artus; git fetch origin; git merge origin/master; cd -'
alias pullKappaTools='cd $CMSSW_BASE/src/KappaTools; git fetch origin; git merge origin/master; cd -'
alias pullHtTT='cd $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/; git fetch origin; git merge origin/master; cd -'
alias pullKappa='cd $CMSSW_BASE/src/Kappa; git fetch origin; git merge origin/master; cd -'
alias pullall='pullArtus; pullKappaTools; pullHtTT; pullKappa'

# Syntax highlighting in less
VLESS=$(find /usr/share/vim -name 'less.sh')
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

# Artus
export USERPC="lx3b59"


setkitanalysis715() {
	#setgridcontroltrunk1501
	
	cd ~/working_directory/CMSSW_7_1_5/src
	
	set_cmssw slc6_amd64_gcc481
	
	export HARRY_USERPC=`hostname`
	export HARRY_REMOTE_USER="mfackeld"
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/src/
}

setkitanalysis747_hiwi() {
	#setgridcontroltrunk1501
	
	cd ~/working_directory_new/CMSSW_7_4_7/src
	
	set_cmssw slc6_amd64_gcc481
	
	export HARRY_USERPC=`hostname`
	export HARRY_REMOTE_USER="mfackeld"
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/src/
}

setkitanalysis80X_hiwi() {
	#setgridcontroltrunk1501
	
	cd ~/test_cmssw/CMSSW_8_0_25/src
	
	set_cmssw slc6_amd64_gcc530
	
	export HARRY_USERPC=`hostname`
	export HARRY_REMOTE_USER="mfackeld"
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/src/
}

#master thesis

setkitanalysis747() {
	#setgridcontroltrunk1501
	
	cd ~/master/CMSSW_7_4_7/src
	
	set_cmssw slc6_amd64_gcc481
	
	export HARRY_USERPC=`hostname`
	export HARRY_REMOTE_USER="mfackeld"
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/src/
}

setkitanalysis80X() {
	#setgridcontroltrunk1501
	
	cd ~/master/CMSSW_8_0_26_patch1/src
	
	set_cmssw slc6_amd64_gcc530
	
	export HARRY_USERPC=`hostname`
	export HARRY_REMOTE_USER="mfackeld"
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/src/
}

