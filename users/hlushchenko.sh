#!/bin/bash
echo " * --> export hlushchenko.sh (for rwth cluster)"

alias vpi='voms-proxy-init -voms cms:/cms/dcms -valid 192:00'
alias gridftp='echo "cd /pnfs/physik.rwth-aachen.de/cms/store/user/ohlushch"; uberftp grid-ftp'
alias setsshagent='eval "$(ssh-agent -s)"; ssh-add  ~/.ssh/id_rsa'
# type gridftp

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $DIR/hlushchenko_common.sh
# source /home/home2/institut_3b/hlushchenko/Templates/bashrc/users/hlushchenko_common.sh
if [ -z "$BASHRCDIR" ]
then
    BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX )
    curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
    # cat $tmpfile | pbcopy;
    cat $tmpfile;
    rm -f $tmpfile;
}

setsshaggent()
{
    eval "$(ssh-agent -s)"
    ssh-add  ~/.ssh/id_rsa
}

# CMSSW
[ -f $BASHRCDIR/cmssw.sh ] && source $BASHRCDIR/cmssw.sh

# ENVIRONMENT
export PS1="\[\033[104m\]\h : \w \$\[\033[00m\] "
export LANG=en_US.UTF-8
export EDITOR=vim
export LS_OPTIONS="-N -T 0 --color=auto"

# ALIASES
nafn(){
    echo "glusheno@naf-cms$1.desy.de"
    ssh -XYt "glusheno@naf-cms$1.desy.de"
}
alias nafcms='ssh -XYt glusheno@naf-cms.desy.de'
alias nafcms14='ssh -XYt glusheno@naf-cms14.desy.de'
alias nafcms12='ssh -XYt glusheno@naf-cms12.desy.de'
alias scramb='scram b -j `grep -c ^processor /proc/cpuinfo`; echo $?'
#alias scramb='scram b -j 8; echo $?'
alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
alias meld='export PATH=/usr/bin/:$PATH && meld'
alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'
alias myvomsproxyinit='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'

alias pushbash='cd $BASHRCDIR; git pull; git add -p; git commit -m "olena:from rwth"; git push; cd -'
alias pullbash='cd $BASHRCDIR; git pull; cd -'
alias vimbash='vim "$BASHRCDIR"/users/hlushchenko.sh'
alias vimbashcommon='vim "$BASHRCDIR"/users/hlushchenko_common.sh'

# CMSSW
alias setanalysis='setanalysis747'
alias setcrab='setcrab3'
alias setskimming='setskimming8020'
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

alias pullArtus_dictchanges_CMSSW94X='cd $CMSSW_BASE/src/Artus; git fetch origin; git merge origin/dictchanges_CMSSW94X; cd -'
alias pullHtTT_dictchanges_CMSSW94='cd $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/; git fetch origin; git merge origin/dictchanges_CMSSW94; cd -'
alias pullKappa_dictchanges_CMSSW94X='cd $CMSSW_BASE/src/Kappa; git fetch origin; git merge origin/dictchanges_CMSSW94X; cd -'
alias pullall_dictchanges_CMSSW94X='pullArtus_dictchanges_CMSSW94X; pullKappaTools; pullHtTT_dictchanges_CMSSW94; pullKappa_dictchanges_CMSSW94X'

pullArtuFunction()
{
	cd $CMSSW_BASE/src/Artus; git fetch origin; git merge origin/$1; cd -
}

pullKappaToolsFunction()
{
	cd $CMSSW_BASE/src/KappaTools; git fetch origin; git merge origin/$1; cd -
}

pullHtTTFunction()
{
	cd $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/; git fetch origin; git merge origin/$1; cd -
}

pullKappaFunction()
{
	cd $CMSSW_BASE/src/Kappa; git fetch origin; git merge origin/$1; cd -
}

# Job Submission
setcrab3()
{
    source /cvmfs/cms.cern.ch/crab3/crab.sh
}

# Kappa, Artus
export SKIM_WORK_BASE=/net/scratch_cms3b/$USER/kappa
export USERPC='lx3b83'

#################### Set Skimming #####################

setskimming763()
{
    startingDir=$(pwd)
    cd /.automount/home/home__home2/institut_3b/hlushchenko/Work/CMSSW_7_6_3/src
    set_cmssw slc6_amd64_gcc493
    cd $startingDir
    cd $CMSSW_BASE/src/
}

setskimming8014 ()
{
    startingDir=$(pwd)
    cd ~/Work/CMSSW_8_0_14/src;
    set_cmssw slc6_amd64_gcc530;
    cd $startingDir
    cd $CMSSW_BASE/src/
}

setskimming8020 ()
{
    startingDir=$(pwd)
    cd ~/Work/CMSSW_8_0_20/src;
    set_cmssw slc6_amd64_gcc530;
    cd $startingDir
    cd $CMSSW_BASE/src/
}


setskimming8026patch1 ()
{
    startingDir=$(pwd)
    cd ~/Work/CMSSW_8_0_26_patch1/src;
    set_cmssw slc6_amd64_gcc530;
    cd $startingDir
    cd $CMSSW_BASE/src
    ARTUSPATH=/.automount/home/home__home2/institut_3b/hlushchenko/Work/CMSSW_7_4_7/src/Artus/
    SKIM_WORK_BASE=/.automount/home/home__home2/institut_3b/hlushchenko/Work/CMSSW_8_0_26_patch1/src/SKIM_WORK_BASE
}

setKSkimming8026patch1 ()
{
    startingDir=$(pwd)
    cd ~/Work/Skimming/CMSSW_8_0_26_patch1/src;
    set_cmssw slc6_amd64_gcc530;
    cd $startingDir
    cd $CMSSW_BASE/src
    ARTUSPATH=/.automount/home/home__home2/institut_3b/hlushchenko/Work/CMSSW_7_4_7/src/Artus/
    SKIM_WORK_BASE=/.automount/home/home__home2/institut_3b/hlushchenko/Work/Skimming/CMSSW_8_0_26_patch1/src/SKIM_WORK_BASE
}


setKSkimming929 ()
{
    startingDir=$(pwd)
    cd ~/Work/Skimming/CMSSW_9_2_4/src;
     set_cmssw slc6_amd64_gcc530;
    cd $startingDir
    cd $CMSSW_BASE/src
    ARTUSPATH=/.automount/home/home__home2/institut_3b/hlushchenko/Work/CMSSW_7_4_7/src/Artus/
    SKIM_WORK_BASE=/.automount/home/home__home2/institut_3b/hlushchenko/Work/Skimming/CMSSW_8_0_26_patch1/src/SKIM_WORK_BASE
}


#################### Set Analysis #####################

setanalysis715()
{
    startingDir=$(pwd)
    cd /home/home2/institut_3b/hlushchenko/Work/CheckReciep/CMSSW_7_1_5/src
    set_cmssw slc6_amd64_gcc481
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    cd $startingDir
    cd $CMSSW_BASE/src/
}

setanalysis747()
{
    startingDir=$(pwd)
    cd /home/home2/institut_3b/hlushchenko/Work/CMSSW_7_4_7/src
    set_cmssw slc6_amd64_gcc491
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    cd $startingDir
    cd $CMSSW_BASE/src/
}

setanalysis747_TauES()
{
    startingDir=$(pwd)
    cd /home/home2/institut_3b/hlushchenko/Work/TauES/CMSSW_7_4_7/src
    set_cmssw slc6_amd64_gcc491
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    cd $startingDir
    cd $CMSSW_BASE/src/
}

setanalysis747_new()
{
    startingDir=$(pwd)
    cd /home/home2/institut_3b/hlushchenko/Work/CheckReciep/CMSSW_7_4_7/src
    set_cmssw slc6_amd64_gcc491
    echo "CMSSW_BASE: $CMSSW_BASE"
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    cd $startingDir
    cd $CMSSW_BASE/src/
}

setskimming924()
{
	startingDir=$(pwd)
	cd /home/home2/institut_3b/hlushchenko/Work/CMSSW_9_2_4/src
	set_cmssw slc6_amd64_gcc530
	cd $startingDir
	cd $CMSSW_BASE/src/
}

setskimming940()
{
	startingDir=$(pwd)
	cd  /home/home2/institut_3b/hlushchenko/Work/Skimming/CMSSW_9_4_0/src
	set_cmssw slc6_amd64_gcc630
	cd $startingDir
	cd $CMSSW_BASE/src/
}

setskimming942()
{
        startingDir=$(pwd)
        cd  /home/home2/institut_3b/hlushchenko/Work/Skimming/CMSSW_9_4_2/src
        set_cmssw slc6_amd64_gcc630
        cd $startingDir
        cd $CMSSW_BASE/src/
}

setskimming944()
{
        startingDir=$(pwd)
        cd  /home/home2/institut_3b/hlushchenko/Work/Skimming/CMSSW_9_4_4/src
        set_cmssw slc6_amd64_gcc630
        cd $startingDir
        cd $CMSSW_BASE/src/
}


setanalysisdevnull()
{
    setanalysis &>/dev/null
}

setanalysis810()
{
    startingDir=$(pwd)
    cd /.automount/home/home__home2/institut_3b/hlushchenko/Work/Artus/CMSSW_8_1_0/src
    set_cmssw slc6_amd64_gcc600
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    cd $startingDir
    cd $CMSSW_BASE/src/
}

