#!/bin/bash
echo "Ok bash, ohlushch.sh is for ekp machine"
if [ -z "$BASHRCDIR" ]
then
	BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#cd $0

# Grid certificates
source $BASHRCDIR/users/greyxray/grid.sh

#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#cd $0
DIR_BASH=${HOME}/bashrc
# DIR_BASHHISTORY=/nfs/dust/cms/user/glusheno/bash_history
SERVERBASH=${DIR_BASH}/users/ohlushch.sh
COMMONBASH=${DIR_BASH}/users/hlushchenko_common.sh  # ~ tilda is not expanded in scripts https://stackoverflow.com/a/3963747/3152072
# Updating bash repository
alias pushbash="cd $DIR_BASH; git pull; git add -p; git commit -m 'olena:from naf'; git push; cd -"
alias pullbash="cd $DIR_BASH; git pull; cd -; source $COMMONBASH"
alias vimbash="vim $SERVERBASH"
alias vimbashcommon="vim $COMMONBASH"
alias cdbash="cd $DIR_BASH"

# Run ssh-agent
eval "$(ssh-agent -s)"
#ssh-add  ~/.ssh/id_rsa
ssh-add  ~/.ssh/id_rsa_nopass

source  ~/bashrc/users/hlushchenko_common.sh
#source $BASHRCDIR/users/hlushchenko_common.sh

source ~/git-prompt.sh

# History
# mkdir -p $DIR_BASHHISTORY
export HISTTIMEFORMAT="%F %T: "
# Save and reload the history after each command finishes : https://unix.stackexchange.com/a/18443/137225
export HISTCONTROL=ignoreboth  # no duplicate entries
shopt -s histappend                      # append to history, don't overwrite it
# export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
# export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
# https://unix.stackexchange.com/a/48113/137225 :
# Forse to save all commands to the history : all history in all tabs is stored
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# https://unix.stackexchange.com/a/1292/137225 : After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# CMSSW
[ -f $BASHRCDIR/cmssw.sh ] && source $BASHRCDIR/cmssw.sh

# ENVIRONMENT
export PS1="\[\033[104m\]\h : \w \$\[\033[00m\] "
export LANG=en_US.UTF-8
export EDITOR=vim
export LS_OPTIONS="-N -T 0 --color=auto"

# ALIASES
CORES=`grep -c ^processor /proc/cpuinfo`
alias scramb='scram b -j $CORES; echo $?; tput bel'
alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
alias meld='export PATH=/usr/bin/:$PATH && meld'
alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'
alias gits='git status'
alias gitf='git fetch origin'
alias gitl='git log'
alias gitln='git log -n'

## CMSSW working environments
alias setkitanalysis='setkitanalysis949_naf'
alias setcrab='setcrab3'
alias setkitskimming='setkitskimming8010'
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

alias setartus=setanalysis10214
## Working environments
alias grep='/bin/grep'
sethappy() {
	cd  ~/RWTH/Artus/CMSSW_7_4_7/src/
	set_cmssw slc6_amd64_gcc491;
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh;

}

setanalysis10214(){
    cd  ~/Work/Artus/CMSSW_10_2_14/src
    SCRAM_ARCH=slc6_amd64_gcc700
    export $SCRAM_ARCH
    source $VO_CMS_SW_DIR/cmsset_default.sh
    set_cmssw slc6_amd64_gcc700
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
}

setanalysis949(){
    cd  ~/Work/Artus/CMSSW_9_4_9/src
    SCRAM_ARCH=slc6_amd64_gcc630; export $SCRAM_ARCH
        source $VO_CMS_SW_DIR/cmsset_default.sh
    set_cmssw slc6_amd64_gcc630
 source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
}

setkitanalysis949() {
	cd /afs/desy.de/user/g/glusheno/RWTH/KIT/sm-htt-analysis/CMSSW_9_4_9/src
	SCRAM_ARCH=slc6_amd64_gcc630; export $SCRAM_ARCH
	source $VO_CMS_SW_DIR/cmsset_default.sh
	# cmsenv
    set_cmssw slc6_amd64_gcc630

    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
}

setkitskimming763() {
	cd ~/home/cms/htt/skimming/CMSSW_7_6_3/src
	set_cmssw slc6_amd64_gcc493
	cd $CMSSW_BASE/src/
}

#/afs/desy.de/user/g/glusheno/RWTH/CMSSW_7_4_7

setkitanalysis747() {
    cd /afs/desy.de/user/g/glusheno/RWTH/CMSSW_7_4_7/src
    set_cmssw slc6_amd64_gcc491
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    cd $CMSSW_BASE/src/
}


setkitskimming8014() {
    cd /afs/desy.de/user/g/glusheno/RWTH/CMSSW_8_0_14/src
    set_cmssw slc6_amd64_gcc530
    cd $CMSSW_BASE/src/
}

setkitskimming8020() {
	cd /afs/desy.de/user/g/glusheno/RWTH/CMSSW_8_0_20/src
    set_cmssw slc6_amd64_gcc530
    cd $CMSSW_BASE/src/
}

setrasp(){
    cd /afs/desy.de/user/g/glusheno/RWTH/CMSSW_8_0_7_patch2/src
    set_cmssw slc6_amd64_gcc530
    cd -
}

setkitskimming8026patch1Crabtest()
{
    cd /afs/desy.de/user/g/glusheno/RWTH/CRABtest/CMSSW_8_0_26_patch1/src
    set_cmssw slc6_amd64_gcc530;
    cd $CMSSW_BASE/src/
}

setkitskimming763_Fabiotest()
{
	cd  ~/RWTH/CMSSW_7_6_3/src #~/home/cms/htt/skimming/CMSSW_7_6_3/src
    set_cmssw slc6_amd64_gcc493
    cd $CMSSW_BASE/src/
}

setmva ()
{
	cd  ~/RWTH/MVAtraining/CMSSW_8_0_26_patch1/src
    set_cmssw slc6_amd64_gcc530;
	cd  /nfs/dust/cms/user/glusheno/TauIDMVATraining2016/Summer16_25ns_V1/tauId_v3_0/trainfilesfinal_v1
}

setmva9()
{
    cd  ~/RWTH/MVAtraining/CMSSW_9_2_4/src
    set_cmssw slc6_amd64_gcc530;#slc6_amd64_gcc700;
	cd /nfs/dust/cms/user/glusheno/TauIDMVATraining2017/Summer17_25ns_V1_allPhotonsCut/tauId_v3_0/trainfilesfinal_v1
}

setmva9v2()
{
    cd ~/RWTH/MVAtraining/CMSSW_9_4_2/src
	set_cmssw slc6_amd64_gcc630
    #cd /nfs/dust/cms/user/glusheno/TauIDMVATraining2017/Summer19_25ns_V1_allPhotonsCut/tauId_v3_0/trainfilesfinal_v1
}


# GIT Aliases
alias pullArtus='cd $CMSSW_BASE/src/Artus; git fetch origin; git merge origin/master; cd -'
alias pullKappaTools='cd $CMSSW_BASE/src/KappaTools;git fetch origin; git merge origin/master; cd -'
alias pullHtTT='cd $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/; git fetch origin; git merge origin/master; cd -'
alias pullKappa='cd $CMSSW_BASE/src/Kappa; git fetch origin; git merge origin/master; cd -'
alias pullall='pullArtus; pullKappaTools; pullHtTT; pullKappa'
alias scramball='cd $CMSSW_BASE/src; scramb ; cd -'
alias pullandscramb='pullall; scramball'

setsshaggent()
{
        eval "$(ssh-agent -s)"
        ssh-add  ~/.ssh/id_rsa
}
