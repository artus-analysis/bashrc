#!/bin/bash
echo "Ok bash, hlushch"
if [ -z "$BASHRCDIR" ]
then
	BASHRCDIRd$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

# CMSSW
[ -f $BASHRCDIR/cmssw.sh ] && source $BASHRCDIR/cmssw.sh

# ENVIRONMENT
export PS1="\[\033[104m\]\h : \w \$\[\033[00m\] "
export LANG=en_US.UTF-8
export EDITOR=vim
export LS_OPTIONS="-N -T 0 --color=auto"

# ALIASES
alias scramb='scram b -j 8; echo $?'
alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
alias meld='export PATH=/usr/bin/:$PATH && meld'
alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'
alias myvomsproxyinit='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'

# CMSSW
alias setcrab='setcrab3'
alias setkitskimming='echo "mot set alias"'
#alias setgenerator='setgenerator7118'

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
export USERPC='lx3b83'

setkitanalysis715() {
	cd /home/home2/institut_3b/hlushchenko/Work/CheckReciep/CMSSW_7_1_5/src
	set_cmssw slc6_amd64_gcc481
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	cd $CMSSW_BASE/src/
}

setkitskimming763() {
	cd  ~/RWTH/CMSSW_7_6_3/src #~/home/cms/htt/skimming/CMSSW_7_6_3/src
	set_cmssw slc6_amd64_gcc493
	cd $CMSSW_BASE/src/
}
setkitskimming8010() {
	cd  ~/RWTH/CMSSW_8_0_10/src #~/home/cms/htt/skimming/CMSSW_8_0_10/src
	set_cmssw slc6_amd64_gcc530
	cd $CMSSW_BASE/src/
}


setkitskimming763_Fabiotest()
{
	cd  ~/RWTH/CMSSW_7_6_3/src #~/home/cms/htt/skimming/CMSSW_7_6_3/src
    set_cmssw slc6_amd64_gcc493
    cd $CMSSW_BASE/src/
}

sourcecrab='source /cvmfs/cms.cern.ch/crab3/crab.sh'

setskimming942()
{
 cd  ~/RWTH/Kappa/CMSSW_9_4_2/src
 set_cmssw slc6_amd64_gcc630
 cd $CMSSW_BASE/src/
}
