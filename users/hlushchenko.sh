#!/bin/bash
echo "Ok bash, I am hlushchenko.sh"
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
alias scramb='scram b -j 8; echo $?'
alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
alias meld='export PATH=/usr/bin/:$PATH && meld'
alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'
alias myvomsproxyinit='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'

# CMSSW
alias setkitanalysis='setkitanalysis747'
alias setcrab='setcrab3'
alias setkitskimming='setkitskimming8020'
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
#Windows popping up to ask for username and passwort after git push/pull can be avoided and replaced by a bash prompt.
unset SSH_ASKPASS""

alias pullArtus='cd $CMSSW_BASE/src/Artus; git fetch origin; git merge origin/master; cd -'
alias pullKappaTools='cd $CMSSW_BASE/src/KappaTools; git fetch origin; git merge origin/master; cd -'
alias pullHtTT='cd $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/; git fetch origin; git merge origin/master; cd -'
alias pullKappa='cd $CMSSW_BASE/src/Kappa; git fetch origin; git merge origin/master; cd -'
alias pullall='pullArtus; pullKappaTools; pullHtTT; pullKappa'

# Job Submission
setcrab3() {
	source /cvmfs/cms.cern.ch/crab3/crab.sh
}

# Artus
export USERPC='lx3b83'

#################### Set Skimming #####################

setkitskimming763() 
{
    cd /.automount/home/home__home2/institut_3b/hlushchenko/Work/CMSSW_7_6_3/src	
    set_cmssw slc6_amd64_gcc493
    cd $CMSSW_BASE/src/
}

setkitskimming8014 () 
{ 
    cd ~/Work/CMSSW_8_0_14/src;
    set_cmssw slc6_amd64_gcc530;
    cd $CMSSW_BASE/src/
}

setkitskimming8020 () 
{   
    cd ~/Work/CMSSW_8_0_20/src;
    set_cmssw slc6_amd64_gcc530;
    cd $CMSSW_BASE/src/
}


setkitskimming8026patch1 () 
{
    cd ~/Work/CMSSW_8_0_26_patch1/src;
    set_cmssw slc6_amd64_gcc530;
    cd $CMSSW_BASE/src
    ARTUSPATH=/.automount/home/home__home2/institut_3b/hlushchenko/Work/CMSSW_7_4_7/src/Artus/
    SKIM_WORK_BASE=/.automount/home/home__home2/institut_3b/hlushchenko/Work/CMSSW_8_0_26_patch1/src/SKIM_WORK_BASE
}
#################### Set Analysis #####################

setkitanalysis715() 
{
        cd /home/home2/institut_3b/hlushchenko/Work/CheckReciep/CMSSW_7_1_5/src
        set_cmssw slc6_amd64_gcc481
        source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
        cd $CMSSW_BASE/src/
}

setkitanalysis747() 
{
        cd /home/home2/institut_3b/hlushchenko/Work/CMSSW_7_4_7/src       
        set_cmssw slc6_amd64_gcc491
        source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
        cd $CMSSW_BASE/src/
}

setkitanalysis747_TauES()
{
	cd /home/home2/institut_3b/hlushchenko/Work/TauES/CMSSW_7_4_7/src 
	set_cmssw slc6_amd64_gcc491
        source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
        cd $CMSSW_BASE/src/
}

setkitanalysis747_new() 
{
        cd /home/home2/institut_3b/hlushchenko/Work/CheckReciep/CMSSW_7_4_7/src	
        set_cmssw slc6_amd64_gcc491
        echo "CMSSW_BASE: $CMSSW_BASE"
        source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
        cd $CMSSW_BASE/src/
}

setkitanalysisdevnull()
{
	setkitanalysis &>/dev/null
}

setcrab3()
{
source /cvmfs/cms.cern.ch/crab3/crab.sh
}
