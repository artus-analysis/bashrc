#!/bin/bash

if [ -z "$BASHRCDIR" ]
then
	BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

# screen
[ -f $BASHRCDIR/screenrc.sh ] && ln -s $BASHRCDIR/screenrc ~/.screenrc

# CMSSW
[ -f $BASHRCDIR/cmssw.sh ] && source $BASHRCDIR/cmssw.sh

# ENVIRONMENT
export PS1HOSTCOLOR="1;32"
export PS1='\[\e[${PS1HOSTCOLOR}m\][\u\[\e[1;32m\]@\[\e[${PS1HOSTCOLOR}m\]\h \[\e[m\]\[\e[1;34m\]\W\[\e[${PS1HOSTCOLOR}m\]]\[\e[1;33m\]$(parse_git_branch_and_add_brackets) \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]\[\033[00m\]'
export LANG=en_US.UTF-8
export EDITOR=vim
export LS_OPTIONS="-hN --color=auto --group-directories-first"
export X509_USER_PROXY=$HOME/.globus/x509up

# ALIASES
alias scramb='scram b -j `grep -c ^processor /proc/cpuinfo` ; echo $?'
alias scrambdebug='scram b -j `grep -c ^processor /proc/cpuinfo` USER_CXXFLAGS="-g"'
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
alias meld='export PATH=/usr/bin/:$PATH && meld'
alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'
alias myvomsproxyinit='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'
alias gitpullcmssw='git fetch origin && git merge origin/master'

# CMSSW
alias setkitanalysis='setkitanalysis810'
alias setkitskimming='setkitskimming9411'
alias settauvalidation='settauvalidation9001'
alias setcrab='setcrab3'
export PATH=/afs/cern.ch/user/v/valya/public/dasgoclient/:$PATH

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

# Job Submission
setcrab3() {
	source /cvmfs/cms.cern.ch/crab3/crab.sh
}


# Artus
#export USERPC='lx3b09'
export USERPC='lx3b15'


setkitanalysis810() {
	#cd ~/home/cms/htt/analysis/CMSSW_8_1_0/src
	#cd /.automount/home/home__home2/institut_3b/wiens/Analysis/CMSSW_8_1_0/src
	cd /.automount/home/home__home2/institut_3b/wiens/Analysis/analysis/CMSSW_8_1_0/src

	set_cmssw slc7_amd64_gcc530
	#set_cmssw slc6_amd64_gcc530

	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh

	cd $CMSSW_BASE/src/
}


setkitanalysis747() {
	cd /.automount/home/home__home2/institut_3b/wiens/Analysis/CMSSW_7_4_7/src

	set_cmssw slc6_amd64_gcc491

	export HARRY_REMOTE_USER=lwiens
	export HARRY_USERPC=lx3b15.rwth-aachen.de
	export HARRY_SSHPC=$HARRY_USERPC

	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh

	cd $CMSSW_BASE/src/
}

setkitskimming9411() {
	cd /home/home2/institut_3b/wiens/Analysis/skimming/CMSSW_9_4_11_cand2/src
	#set_cmssw slc6_amd64_gcc530
	set_cmssw slc7_amd64_gcc530

	source /cvmfs/cms.cern.ch/crab3/crab.sh
	#export X509_USER_PROXY='/home/home2/institut_3b/wiens/.globus/x509'
	export PATH=$PATH:$CMSSW_BASE/src/grid-control:$CMSSW_BASE/src/grid-control/scripts

	cd $CMSSW_BASE/src/
}

setkitskimming20190515() {
	cd /home/home2/institut_3b/wiens/Analysis/skimming/skim20190515/CMSSW_9_4_11_cand2/src
	#export X509_USER_PROXY='/home/home2/institut_3b/wiens/.globus/x509'

	#set_cmssw slc6_amd64_gcc530
	set_cmssw slc7_amd64_gcc530

	cd $CMSSW_BASE/src/
	#source /cvmfs/cms.cern.ch/crab3/crab.sh
	export PATH=$PATH:$CMSSW_BASE/src/grid-control:$CMSSW_BASE/src/grid-control/scripts
}
