#!/bin/bash
#echo "wolfschlaeger.sh loaded"
if [ -z "$BASHRCDIR" ]
then
	BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

# screen
[ -f $BASHRCDIR/screenrc.sh ] && ln -s $BASHRCDIR/screenrc ~/.screenrc

# CMSSW
[ -f $BASHRCDIR/cmssw.sh ] && source $BASHRCDIR/cmssw.sh

# ENVIRONMENT
export PS1="\[\033[104m\]\h : \w \$\[\033[00m\] "
export LANG=en_US.UTF-8
export EDITOR=vim
export LS_OPTIONS="-N -T 0 --color=auto"
export X509_USER_PROXY=$HOME/.globus/x509up

# ALIASES
alias scramb='scram b -j 8; echo $?'
alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
alias meld='export PATH=/usr/bin/:$PATH && meld'
alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'
alias myvomsproxyinit='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'
alias gitpullcmssw='git fetch origin && git merge origin/master'

# CMSSW
alias setkitanalysis='setkitanalysis747'
alias setkitskimming='setkitskimming80261'
alias settauvalidation='settauvalidation9001'
alias setcrab='setcrab3'
alias setdesyanalysis='setdesyanalysis825'
alias setdesyanalysis747='setdesyanalysis747'
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
function gridinit {
	export X509_USER_PROXY=$HOME/.globus/proxy.grid
	voms-proxy-init -voms cms:/cms/dcms -valid 192:00
}


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
export USERPC='lx3b71'

setdesyanalysis825() {
	cd ~/desy_analysis/DesyTauAnalysesRun2_25ns/CMSSW_8_0_25/src
	
	source init_CMSSW.sh

	cd $CMSSW_BASE/src/
}
setdesyanalysis747() {
	cd ~/desy_analysis/DesyTauAnalysesRun2_25ns/CMSSW_7_4_7/src

	source init_CMSSW.sh

	cd $CMSSW_BASE/src
}
setkitanalysis747() {
        cd ~/cms_analysis/CMSSW_7_4_7/src

        set_cmssw slc6_amd64_gcc491
	eval "$(ssh-agent -s)"
	ssh-add
        source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh

        cd $CMSSW_BASE/src/
}
setkitanalysis810() {
        cd ~/cms_analysis/CMSSW_8_1_0/src
        set_cmssw slc6_amd64_gcc530
	eval "$(ssh-agent -s)"
	ssh-add
        source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
        cd $CMSSW_BASE/src/
}

