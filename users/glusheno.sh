#!/bin/bash
echo " * --> export glusheno.sh for naf"
source  ~/bashrc/users/hlushchenko_common_cmssw.sh

if [ -z "$BASHRCDIR" ]
then
	BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

# Grid certificates
source $BASHRCDIR/users/greyxray/grid.sh

# Run ssh-agent
eval "$(ssh-agent -s)"
#ssh-add  ~/.ssh/id_rsa
ssh-add  ~/.ssh/id_rsa_nopass

# Kerberos ticket
# for screen sessions: https://twiki.cern.ch/twiki/bin/viewauth/CMS/KITHiggsAnalysisTWiki
CREDENTIAL_PATH=${KRB5CCNAME/FILE:/}
LOCAL_KERBEROS_PATH=${HOME}/.krb/$(basename $CREDENTIAL_PATH)
# Move to Home
if test -f "$LOCAL_KERBEROS_PATH"; then
    echo "$LOCAL_KERBEROS_PATH exist"
else
    cp ${CREDENTIAL_PATH} $LOCAL_KERBEROS_PATH
fi
# Reset KRB5CCNAME
# echo "$KRB5CCNAME  -->  FILE:$LOCAL_KERBEROS_PATH"
# export KRB5CCNAME=FILE:$LOCAL_KERBEROS_PATH
renewablekinit() {
   while true;
   do
      kinit -R
      aklog
      sleep 21600
   done
}
# kinit -l 48h -r 100d
# renewablekinit &

#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#cd $0
DIR_BASH=${HOME}/RWTH/bashrc
DIR_BASHHISTORY=/nfs/dust/cms/user/glusheno/bash_history
SERVERBASH=${HOME}/RWTH/bashrc/users/glusheno.sh
COMMONBASH=${HOME}/RWTH/bashrc/users/hlushchenko_common.sh  # ~ tilda is not expanded in scripts https://stackoverflow.com/a/3963747/3152072

# GIT extras
DIR_PRIVATESETTINGS=${HOME}/RWTH/KIT/privatesettings
source ${DIR_PRIVATESETTINGS}/env_scripts/git-prompt.sh
export HARRY_REMOTE_USER='ohlushch'
# Path contains only pathes to the scripts
export PATH="$HOME/.local/bin:$PATH"
# export PATH=$DIR_BASH/scripts:$PATH
# export PATH=$DIR_PRIVATESETTINGS/gc:$PATH
# export PATH=$DIR_PRIVATESETTINGS/playground:$PATH
# export PATH=$DIR_PRIVATESETTINGS/artus:$PATH
# export PATH=$DIR_PRIVATESETTINGS/root_scripts:$PATH
# export PATH=$DIR_PRIVATESETTINGS/python_scripts:$PATH
#GIT lfs
export PATH=$PATH:/nfs/dust/cms/user/glusheno/afs/apps/go/bin  #  actual go
# GOROOT == /nfs/dust/cms/user/glusheno/afs/apps/go/ - don't touch this!
export GOPATH=/nfs/dust/cms/user/glusheno/afs/apps/go_path  #  git-lfs is installed here
export GOBIN="$GOPATH/bin"
export PATH=$PATH:/nfs/dust/cms/user/glusheno/afs/apps/go_path/bin/  #  git-lfs served from here


setprivatesettings(){
    declare -a modules=(
        $DIR_BASH/scripts
        $DIR_PRIVATESETTINGS/gc
        $DIR_PRIVATESETTINGS/btagging
        $DIR_PRIVATESETTINGS/playground
        $DIR_PRIVATESETTINGS/artus
        # $DIR_PRIVATESETTINGS/root_scripts
        $DIR_PRIVATESETTINGS/python_scripts
    )

    for i in "${modules[@]}"
    do
        if [ -d "$i" ]
        then
            chmod +x $i/*
            [[ ":$PATH:" != *"$i:"* ]] && PATH="$i:${PATH}"
        else
            echo "Couldn't find package: " $i
        fi
    done
    export PATH
}
setprivatesettings

# export PATH=$DIR_PRIVATESETTINGS/python_wrappers:$PATH
# Path contains only pathes to MODULES with __init__ defined
[[ ":$PYTHONPATH:" != *"$HOME/.local/lib/python2.7/site-packages:"* ]] && PYTHONPATH="$HOME/.local/lib/python2.7/site-packages:${PYTHONPATH}"
[[ ":$PYTHONPATH:" != *"$DIR_PRIVATESETTINGS:"* ]] && PYTHONPATH="$DIR_PRIVATESETTINGS:${PYTHONPATH}"

source $COMMONBASH
export PYTHONPATH

# History
# https://www.thomaslaurenson.com/blog/2018/07/02/better-bash-history/
mkdir -p $DIR_BASHHISTORY
export HISTTIMEFORMAT="%F %T: "
# Save and reload the history after each command finishes : https://unix.stackexchange.com/a/18443/137225
export HISTCONTROL=ignoreboth  # no duplicate entries
# shopt -s  # command for inspection
shopt -s histappend                      # append to history, don't overwrite it
# shopt -s cmdhist
# export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
# export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
# https://unix.stackexchange.com/a/48113/137225 :
# Forse to save all commands to the history : all history in all tabs is stored
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# Save and reload the history after each command finishes
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# https://unix.stackexchange.com/a/1292/137225 : After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
# export PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# CMSSW
[ -f $BASHRCDIR/cmssw.sh ] && source $BASHRCDIR/cmssw.sh

# ENVIRONMENT
git='/cvmfs/cms.cern.ch/slc6_amd64_gcc630/cms/cmssw/CMSSW_9_4_9/external/slc6_amd64_gcc630/bin/git'
export PS1="\[\033[104m\]\h : \w \$\[\033[00m\] "
export LANG=en_US.UTF-8
export EDITOR=vim
export LS_OPTIONS="-N -T 0 --color=auto"

# ALIASES
CORES=`grep -c ^processor /proc/cpuinfo`
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
# alias meld='export PATH=/usr/bin/:$PATH && meld'
# alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'
# alias myvomsproxyinit='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'
DUST=/nfs/dust/cms/user/glusheno/
alias cddust='cd $DUST'


alias setcrab='setcrab3'
## CMSSW working environments
## Top level alias
alias setanalysis='setkitanalysis'
alias setartus='setkitartus'
alias setartus2017='setkitartus949'
alias setartus2018='setkitartus10214'
alias setkappa='setskimming'
alias setskimming='setkitskimming'
alias setshapes='setharry ; setkitshapes'
alias setff='setkitff'
alias setcombine='setcombine810'
### KIT
alias setkitanalysis='setkitanalysis949'
alias setkitartus='setkitartus10214'
alias setkitskimming='setkitskimming10214'
alias setkitshapes='setshapes949'
alias setkitff='setff804'
alias setfriends='setfriends10214'

# dCache
# https://twiki.opensciencegrid.org/bin/view/ReleaseDocumentation/LcgUtilities#Using_LCG_Utils_commands
alias mylcg-ls='lcg-ls -b -v -l -D srmv2'
alias mylcg-cp='lcg-cp -v -b -D srmv2'
alias mylcg-del='lcg-del -b -v -l -D srmv2'

# HTC_condor
# condor_rm [username]: kill all your jobs
alias c_sub='condor_submit'
alias c_q='condor_q'
alias c_rm='condor_rm'
alias c_hist='condor_history'
alias c_status='condor_status'
alias c_inspect='condor_status -long'
alias c_list='condor_status -constraint '

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

## Working environments
alias zombie='kinit; aklog'
alias grep='/bin/grep'
# Updating bash repository
alias pullbash="cd $DIR_BASH; git pull; cd -; source $COMMONBASH"
alias vimbash="vim $SERVERBASH"
alias vimbashcommon="vim $COMMONBASH"
alias cdbash="cd $DIR_BASH"
alias Pushbash="cd $DIR_BASH; git pull; git add *; git commit -m 'olena:from naf'; git push; cd -"
# alias pushbash="cd $DIR_BASH; git pull; git add -p; git commit -m 'olena:from naf'; git push; cd -"
pushbash() {
    cd $DIR_BASH
    git pull
    git add -p

    if [[ $# -eq 0 ]] ; then
        git commit -m 'olena:from naf'
    else
        git commit -m "\"$1\""
    fi

    git push
    cd -
}
# Updating dirtyscripts repository
alias pushdirt="cd $DIR_PRIVATESETTINGS; git pull; git add -p; git commit -m 'from naf'; git push; cd -"
alias pulldirt="cd $DIR_PRIVATESETTINGS; git pull; cd -;"
alias cddirt="cd $DIR_PRIVATESETTINGS"

monitoreNumOpenFiles(){
    MAXOPENFILES="$(lsof | grep glusheno | grep Higg | wc -l)"

    while true
    do
        n="$(lsof | grep glusheno | grep Higg | wc -l)"
        [[ $n -gt $MAXOPENFILES ]] && MAXOPENFILES=$n
        sleep 1;
        echo "MAXOPENFILES:" $MAXOPENFILES "opened:" $n
    done
}

setfriends10214(){
    cd /nfs/dust/cms/user/glusheno/afs/RWTH/KIT/FriendTreeProducer/CMSSW_10_2_14/src/
    set_cmssw slc6_amd64_gcc700

    changeHistfile ${FUNCNAME[0]}
}

setcombine810(){
    cd ~/RWTH/KIT/Combine/CMSSW_8_1_0/src/
	set_cmssw slc6_amd64_gcc530

    changeHistfile ${FUNCNAME[0]}
}

setcombine747(){
	cd ~/RWTH/KIT/Combine/CMSSW_7_4_7/src/
	set_cmssw slc6_amd64_gcc491

    changeHistfile ${FUNCNAME[0]}
}

setharry() {
    curr_dirr=$PWD
	cd  ~/RWTH/Artus/CMSSW_8_1_0/src/
	set_cmssw slc6_amd64_gcc530
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    export WEB_PLOTTING_MKDIR_COMMAND="xrdfs eosuser.cern.ch mkdir -p /eos/user/${HARRY_REMOTE_USER:0:1}/${HARRY_REMOTE_USER}/www/plots_archive/{subdir}"
    export WEB_PLOTTING_COPY_COMMAND="xrdcp -s -f {source} root://eosuser.cern.ch//eos/user/${HARRY_REMOTE_USER:0:1}/${HARRY_REMOTE_USER}/www/plots_archive/{subdir}"
    export WEB_PLOTTING_LS_COMMAND="xrdfs eosuser.cern.ch ls /eos/user/${HARRY_REMOTE_USER:0:1}/${HARRY_REMOTE_USER}/www/plots_archive/{subdir}"

    echo $cernpass | kinit -l 120h ${HARRY_REMOTE_USER}@CERN.CH

    # web plotting - ok didn't work
    # CREDENTIAL_PATH=${KRB5CCNAME/FILE:/}
    # LOCAL_KERBEROS_PATH=${HOME}/.krb/HP/$(basename $CREDENTIAL_PATH)
    # Move to Home
    # if test -f "$LOCAL_KERBEROS_PATH"; then
    #     echo "$LOCAL_KERBEROS_PATH exist"
    # else
    #     cp ${CREDENTIAL_PATH} $LOCAL_KERBEROS_PATH
    # fi
    # Reset KRB5CCNAME
    # echo "$KRB5CCNAME  -->  FILE:$LOCAL_KERBEROS_PATH"
    # export KRB5CCNAME=FILE:$LOCAL_KERBEROS_PATH
    # export KRB5CCNAME=/afs/desy.de/user/g/glusheno/.krb/ticket
    cd $curr_dirr
    cd -
    changeHistfile ${FUNCNAME[0]}
}

setshapes949() {
    echo "CMSSW env taken from /afs/desy.de/user/g/glusheno/RWTH/KIT/sm-htt-analysis/CMSSW_9_4_9/src"
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/sm-htt-analysis/CMSSW_9_4_9/src
    SCRAM_ARCH=slc6_amd64_gcc630
    export $SCRAM_ARCH
    source $VO_CMS_SW_DIR/cmsset_default.sh
    # cmsenv
    set_cmssw slc6_amd64_gcc630
    cd -
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis
    source bin/setup_env.sh

    DIR_SMHTT=""

    changeHistfile ${FUNCNAME[0]}
}


setshapesmaster_naf() {
    echo "CMSSW env taken from /afs/desy.de/user/g/glusheno/RWTH/KIT/sm-htt-analysis/CMSSW_9_4_9/src"
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/sm-htt-analysis/CMSSW_9_4_9/src
    SCRAM_ARCH=slc6_amd64_gcc630
    export $SCRAM_ARCH
    source $VO_CMS_SW_DIR/cmsset_default.sh
    set_cmssw slc6_amd64_gcc630
    cd -

    # get the propper python
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/master/sm-htt-analysis
    source ../../ES-subanalysis/bin/setup_cvmfs_sft.sh

    declare -a modules=(
        $PWD/datacard-producer
        $PWD/shape-producer
        $PWD/shape-producer/shape_producer/
        $PWD
    )

    for i in "${modules[@]}"
    do
        if [ -d "$i" ]
        then
            [[ ":$PYTHONPATH:" != *"$i:"* ]] && PYTHONPATH="$i:${PYTHONPATH}"
        else
            echo "Couldn't find package: " $i
        fi
    done
    export PYTHONPATH

    renice -n 19 -u `whoami`
    changeHistfile ${FUNCNAME[0]}
}

setff804_swoz() {
    # CMSSW
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/sm-htt-analysis/CMSSW_8_0_4/src
    export SCRAM_ARCH=slc6_amd64_gcc530
    source $VO_CMS_SW_DIR/cmsset_default.sh
    set_cmssw slc6_amd64_gcc530

    # export SCRAM_ARCH=slc6_amd64_gcc630
    # source $VO_CMS_SW_DIR/cmsset_default.sh
    # set_cmssw slc6_amd64_gcc630

    # CVMFS
    # source /cvmfs/sft.cern.ch/lcg/views/LCG_94/x86_64-slc6-gcc62-opt/setup.sh
    # root -l /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/sm-htt-analysis/CMSSW_8_0_4/src/HTTutilities/Jet2TauFakes/data_2017/SM2017/tight/vloose/et/fakeFactors.root
    # source /cvmfs/sft.cern.ch/lcg/views/LCG_93c/x86_64-slc6-gcc62-opt/setup.sh
    [[ ":$PYTHONPATH:" != *"$HOME/.local/lib/python2.7/site-packages:"* ]] && PYTHONPATH="$HOME/.local/lib/python2.7/site-packages:${PYTHONPATH}"

    # Python packages
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/sm-htt-analysis
    declare -a modules=(
        # $PWD/datacard-producer
        /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/shape-producer
        $PWD/fake-factors
        $PWD
    )
    for i in "${modules[@]}"
    do
        if [ -d "$i" ]
        then
            [[ ":$PYTHONPATH:" != *"$i:"* ]] && PYTHONPATH="$i:${PYTHONPATH}"
        else
            echo "Couldn't find package: " $i
        fi
    done

    export PYTHONPATH

    ARTUS_OUTPUTS=/nfs/dust/cms/user/glusheno/htautau/artus/ETauFakeES/skim_Nov/merged
    KAPPA_DATABASE=/afs/desy.de/user/g/glusheno/RWTH/KIT/Artus/CMSSW_9_4_9/src/Kappa/Skimming/data/datasets.json
    FF_database_ET=/afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/sm-htt-analysis/CMSSW_8_0_4/src/HTTutilities/Jet2TauFakes/data_2017/SM2017/tight/vloose/et/fakeFactors.root


    changeHistfile ${FUNCNAME[0]}
}

setff804() {
    # I haven't sourced 7_4_7 explicitly.But it ran through with the usual LCG view
    # CMSSW
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/sm-htt-analysis/CMSSW_8_0_4/src
    export SCRAM_ARCH=slc6_amd64_gcc530
    source $VO_CMS_SW_DIR/cmsset_default.sh
    eval `scramv1 runtime -sh`
    # set_cmssw slc6_amd64_gcc530

    # [[ ":$PYTHONPATH:" != *"$HOME/.local/lib/python2.7/site-packages:"* ]] && PYTHONPATH="$HOME/.local/lib/python2.7/site-packages:${PYTHONPATH}"

    # Python packages
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/
    declare -a modules=(
        # $PWD/datacard-producer
        /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/shape-producer
        /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/shapes/fake-factors
        /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/
    )
    for i in "${modules[@]}"
    do
        if [ -d "$i" ]
        then
            [[ ":$PYTHONPATH:" != *"$i:"* ]] && PYTHONPATH="$i:${PYTHONPATH}"
        else
            echo "Couldn't find package: " $i
        fi
    done

    export PYTHONPATH

    ERA=2017
    CONFIGKEY=m_vis
    CATEGORYMODE=inclusive

    ARTUS_OUTPUTS=/nfs/dust/cms/user/glusheno/htautau/artus/ETauFakeES/skim_Nov/merged
    KAPPA_DATABASE=/afs/desy.de/user/g/glusheno/RWTH/KIT/Artus/CMSSW_9_4_9/src/Kappa/Skimming/data/datasets.json
    FF_database_ET=/afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/sm-htt-analysis/CMSSW_8_0_4/src/HTTutilities/Jet2TauFakes/data_2017/SM2017/tight/vloose/et/fakeFactors.root
    FF_database_ET=/nfs/dust/cms/user/glusheno/FF/Jet2TauFakesFiles/SM2017/tight/vloose/et/fakeFactors.root


    changeHistfile ${FUNCNAME[0]}
}

setkitanalysis949() {
	cd /afs/desy.de/user/g/glusheno/RWTH/KIT/sm-htt-analysis/CMSSW_9_4_9/src
	SCRAM_ARCH=slc6_amd64_gcc630
    export $SCRAM_ARCH
	source $VO_CMS_SW_DIR/cmsset_default.sh
	# cmsenv
    set_cmssw slc6_amd64_gcc630

    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh


    changeHistfile ${FUNCNAME[0]}
}

setkitartus10214() {
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Artus/CMSSW_10_2_14/src
    SCRAM_ARCH=slc6_amd64_gcc700
    export $SCRAM_ARCH
    source $VO_CMS_SW_DIR/cmsset_default.sh
    # cmsenv
    set_cmssw slc6_amd64_gcc700

    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh


    changeHistfile ${FUNCNAME[0]}
}

setkitartus10213() {
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Artus/CMSSW_10_2_13/src
    SCRAM_ARCH=slc6_amd64_gcc700
    export $SCRAM_ARCH
    source $VO_CMS_SW_DIR/cmsset_default.sh
    # cmsenv
    set_cmssw slc6_amd64_gcc700

    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh


    changeHistfile ${FUNCNAME[0]}
}
setkitartus949() {
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Artus/CMSSW_9_4_9/src
    SCRAM_ARCH=slc6_amd64_gcc630
    export $SCRAM_ARCH
    source $VO_CMS_SW_DIR/cmsset_default.sh
    # cmsenv
    set_cmssw slc6_amd64_gcc630

    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh


    changeHistfile ${FUNCNAME[0]}
}

setkitartus9412() {
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Artus/CMSSW_9_4_12/src
    export SCRAM_ARCH=slc6_amd64_gcc630
    source $VO_CMS_SW_DIR/cmsset_default.sh
    set_cmssw slc6_amd64_gcc630

    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh


    changeHistfile ${FUNCNAME[0]}
}

# setkitskimming1029()
# {
#     cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Kappa/CMSSW_10_2_9/src
#     export SCRAM_ARCH=slc6_amd64_gcc700
#     source $VO_CMS_SW_DIR/cmsset_default.sh
#     set_cmssw slc6_amd64_gcc700
#     cd $CMSSW_BASE/src/

#     changeHistfile ${FUNCNAME[0]}
# }
setkitskimming10214()
{


    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Kappa/CMSSW_10_2_14/src
    set_cmssw slc6_amd64_gcc700
    # export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch;
    # source $VO_CMS_SW_DIR/cmsset_default.sh
    # cmsenv
    source /cvmfs/cms.cern.ch/crab3/crab.sh
    export PATH=$PATH:$CMSSW_BASE/src/grid-control:$CMSSW_BASE/src/grid-control/scripts


    changeHistfile ${FUNCNAME[0]}
}

setkitskimming10213()
{
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Kappa/CMSSW_10_2_13/src
    set_cmssw slc6_amd64_gcc700
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setkitskimming10210()
{
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Kappa/CMSSW_10_2_10/src
    set_cmssw slc6_amd64_gcc700
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setkitskimming9412()
{
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Kappa/CMSSW_9_4_12/src
    set_cmssw slc6_amd64_gcc630
    cd $CMSSW_BASE/src/


    changeHistfile ${FUNCNAME[0]}
}


setkitskimming763() {
	cd ~/home/cms/htt/skimming/CMSSW_7_6_3/src
	set_cmssw slc6_amd64_gcc493
	cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

#/afs/desy.de/user/g/glusheno/RWTH/CMSSW_7_4_7

setkitanalysis747() {
    cd /afs/desy.de/user/g/glusheno/RWTH/CMSSW_7_4_7/src
    set_cmssw slc6_amd64_gcc491
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}


setkitskimming8014() {
    cd /afs/desy.de/user/g/glusheno/RWTH/CMSSW_8_0_14/src
    set_cmssw slc6_amd64_gcc530
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setkitskimming8020() {
	cd /afs/desy.de/user/g/glusheno/RWTH/CMSSW_8_0_20/src
    set_cmssw slc6_amd64_gcc530
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setrasp(){
    cd /afs/desy.de/user/g/glusheno/RWTH/CMSSW_8_0_7_patch2/src
    set_cmssw slc6_amd64_gcc530
    cd -

    changeHistfile ${FUNCNAME[0]}
}

setkitskimming8026patch1Crabtest()
{
    cd /afs/desy.de/user/g/glusheno/RWTH/CRABtest/CMSSW_8_0_26_patch1/src
    set_cmssw slc6_amd64_gcc530;
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setkitskimming763_Fabiotest()
{
	cd  ~/RWTH/CMSSW_7_6_3/src #~/home/cms/htt/skimming/CMSSW_7_6_3/src
    set_cmssw slc6_amd64_gcc493
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setmva ()
{
	cd  ~/RWTH/MVAtraining/CMSSW_8_0_26_patch1/src
    set_cmssw slc6_amd64_gcc530;
	cd  /nfs/dust/cms/user/glusheno/TauIDMVATraining2016/Summer16_25ns_V1/tauId_v3_0/trainfilesfinal_v1

    changeHistfile ${FUNCNAME[0]}
}

setmva9()
{
    cd  ~/RWTH/MVAtraining/CMSSW_9_2_4/src
    set_cmssw slc6_amd64_gcc530;#slc6_amd64_gcc700;
	cd /nfs/dust/cms/user/glusheno/TauIDMVATraining2017/Summer17_25ns_V1_allPhotonsCut/tauId_v3_0/trainfilesfinal_v1

    changeHistfile ${FUNCNAME[0]}
}

setmva9v2()
{
    cd ~/RWTH/MVAtraining/CMSSW_9_4_2/src
	set_cmssw slc6_amd64_gcc630
    #cd /nfs/dust/cms/user/glusheno/TauIDMVATraining2017/Summer19_25ns_V1_allPhotonsCut/tauId_v3_0/trainfilesfinal_v1

    changeHistfile ${FUNCNAME[0]}
}


setmva10()
{
    cd ~/RWTH/MVAtraining/CMSSW_10_4_0_pre3/src
    set_cmssw slc6_amd64_gcc700
    #cd /nfs/dust/cms/user/glusheno/TauIDMVATraining2017/Summer19_25ns_V1_allPhotonsCut/tauId_v3_0/trainfilesfinal_v1

    changeHistfile ${FUNCNAME[0]}
}

# GIT Aliases
alias pullArtus='cd $CMSSW_BASE/src/Artus; git fetch origin; git merge origin/master; cd -'
alias pullKappaTools='cd $CMSSW_BASE/src/KappaTools;git fetch origin; git merge origin/master; cd -'
alias pullHtTT='cd $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/; git fetch origin; git merge origin/master; cd -'
alias pullKappa='cd $CMSSW_BASE/src/Kappa; git fetch origin; git merge origin/master; cd -'
alias pullall='pullArtus; pullKappaTools; pullHtTT; pullKappa'
alias scramball='cd $CMSSW_BASE/src; scramb ; cd -'
alias pullandscramb='pullall; scramball'

set_zeus()
{
    # Previously located in .profile
    CDPATH=.:$HOME:
    PRINTER=zeusps1
    LPDEST=$PRINTER
    export LPDEST PRINTER
    export zeus_pool=/afs/desy.de/group/zeus/pool/glusheno
    export dust=/nfs/dust/zeus/group/glusheno

    #stty erase \^\?
    set bell-style none

    # instead source set_env_HFSTABLE.sh
        # compiler
        source /cvmfs/sft.cern.ch/lcg/contrib/gcc/4.8/x86_64-slc6-gcc48-opt/setup.sh

        #. /afs/cern.ch/sw/lcg/contrib/gcc/4.3/i686-slc5-gcc43-opt/setup.sh
        # cernlib
        ##export CERN_ROOT=/afs/cern.ch/sw/lcg/external/cernlib/2006a/x86_64-slc5-gcc43-opt
        #export CERN_ROOT=/afs/cern.ch/sw/lcg/external/cernlib/2006a/i686-slc5-gcc43-opt

        # root
        #cd /afs/cern.ch/sw/lcg/app/releases/ROOT/5.34.00/x86_64-slc5-gcc43-opt/root/
        #. /afs/cern.ch/sw/lcg/app/releases/ROOT/5.34.00/x86_64-slc5-gcc43-opt/root/bin/thisroot.sh
        #cd -
        #cd /afs/cern.ch/sw/lcg/app/releases/ROOT/5.34.00/i686-slc5-gcc43-opt/root/
        #. /afs/cern.ch/sw/lcg/app/releases/ROOT/5.34.00/i686-slc5-gcc43-opt/root/bin/thisroot.sh

        module load root/5.34

        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/afs/desy.de/user/g/glusheno/KtJet-1.08/lib
        ##export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/afs/desy.de/user/g/glusheno/programs/KtJet-1.08/lib
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/cvmfs/sft.cern.ch/lcg/external/clhep/2.0.4.5/x86_64-slc5-gcc43-opt/lib
        #export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/cvmfs/sft.cern.ch/lcg/external/clhep/2.2.0.4/x86_64-slc6-gcc48-opt/lib
        ##export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/afs/cern.ch/sw/lcg/external/clhep/2.0.4.0/slc4_amd64_gcc34/lib

    #cd /nfs/dust/zeus/group/glushenko/isolated_photons_summer/cross_sec_EB/
    #echo home is /afs/desy.de/user/g/glusheno
}
