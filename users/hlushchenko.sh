#!/bin/bash
echo " * --> export hlushchenko.sh (for rwth cluster)"
source "$BASHRCDIR/users/hlushchenko_common_cmssw.sh"

alias jobq='LCG_GFAL_INFOSYS=egee-bdii.cnaf.infn.it:2170 lcg-infosites --vo cms ce -f rwth-aachen'
alias jq='jobq'
#alias gestat='glite-ce-job-status -L 2 https://grid-ce.physik.rwth-aachen.de:8443/"$1"'
function gestat() {
    glite-ce-job-status -L 2  https://grid-ce.physik.rwth-aachen.de:8443/${1}
}
alias js='gestat'
alias ges='gestat'
<<<<<<< Updated upstream
alias s='screen'
screensub() {
    tfile=$(mktemp /tmp/XXXXXXXXX)
    if  [[ $# -eq 1 ]] ; then
        echo "cahnging file to $1"
        tfile=$1
        touch $tfile
        rm $tfile
        touch $tfile
    fi
    vim -c 'startinsert' $tfile
    echo "launching screenrc: $tfile"
    screen -S $(basename $tfile) -c $tfile
}
# ssubd(){
#     tfile=$(mktemp /tmp/XXXXXXXXX)
#     if  [[ $# -eq 1 ]] ; then
#         echo "cahnging file to $1"
#         tfile=$1
#         touch $tfile
#     fi
#     vim -c 'startinsert' $tfile
#     echo "launching screenrc: $tfile"
#     screen -d -S $(basename $tfile) -c $tfile
# }
ssubr() {
    if [ $# -eq 1 ] && [ -f "$1" ] ; then
      rm $1
    fi
    screensub $@
}
# ssubrd() {
#     if [ $# -eq 1 ] && [ -f "$1"] ; then
#       rm $1
#     fi
#     ssubd $@
# }
alias ssub='screensub'
sq() {
    screen -XS $1 quit
}
alias screenkill='sq'
alias sr='screen -rd'
alias sl='screen -l'


# Grid certificates
source $BASHRCDIR/users/greyxray/grid.sh
shopt -s direxpand

# SSH connections
# Run ssh-agent : https://stackoverflow.com/questions/17846529/could-not-open-a-connection-to-your-authentication-agent/4086756#4086756
# alias setsshagent='eval "$(ssh-agent -s)"; ssh-add  ~/.ssh/id_rsa'
eval `ssh-agent -s`
ssh-add  ~/.ssh/id_rsa_nopass

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

# CREAM
purgecream() {
    l=1
    while [[ l  -gt 0 ]]
    do
        l="$(glite-ce-job-list --endpoint grid-ce.physik.rwth-aachen.de:8443 | wc -l)"
        echo "$l left"
        sleep 30
    done
    sent "CREAM job purging is finished"
}

# CMSSW
[ -f $BASHRCDIR/cmssw.sh ] && source $BASHRCDIR/cmssw.sh

DIR_BASHHISTORY=/net/scratch_cms3b/hlushchenko/bash_history
DIR_BASH="${DIR}/.."
SERVERBASH=${DIR_BASH}/users/hlushchenko.sh
COMMONBASH=${DIR_BASH}/users/hlushchenko_common.sh  # ~ tilda is not expanded in scripts https://stackoverflow.com/a/3963747/3152072
DIR_PRIVATESETTINGS=${HOME}/dirtyscripts
source ${DIR_PRIVATESETTINGS}/env_scripts/git-prompt.sh
# !!! PATH sould contain only pathes to the scripts !!!
export PATH="$HOME/.local/bin:$PATH"
export PATH=$DIR_BASH/scripts:$PATH
export PATH=$DIR_PRIVATESETTINGS/gc:$PATH
export PATH=$DIR_PRIVATESETTINGS/playground:$PATH
export PATH=$DIR_PRIVATESETTINGS/python_scripts:$PATH

# gitlfn
export PATH=$PATH:~/.local/bin/go/bin  #  actual go
# GOROOT == ~/.local/bin/go/- cant touch this!
export GOPATH=~/.local/bin/go_path  #  git-lfs is installed here
export GOBIN="$GOPATH/bin"
export PATH=$PATH:~/.local/bin/go_path/bin/  #  git-lfs served from here

# export PATH=~/.local/bin:$PATH

# ENVIRONMENT
export PS1="\[\033[104m\]\h : \w \$\[\033[00m\] "
export LANG=en_US.UTF-8
export EDITOR=vim
export LS_OPTIONS="-N -T 0 --color=auto"

# Harryplotter
export HARRY_REMOTE_USER='ohlushch'
export HARRY_USERPC='lx3b57.rwth-aachen.de'

# ALIASES
nafn(){
    echo "glusheno@naf-cms$1.desy.de"
    sshpass -p $nafpass ssh -XYt "glusheno@naf-cms$1.desy.de"
}
# alias rwth='ssh -XYt ohlushch@physik.rwth-aachen.de'
alias nafcms='sshpass -p $nafpass ssh -XYt glusheno@naf-cms.desy.de'
alias nafcms14='ssh -XYt glusheno@naf-cms14.desy.de'
alias nafcms12='ssh -XYt glusheno@naf-cms12.desy.de'
alias naf='nafcms'
alias cern='ssh -XYt -o PreferredAuthentications=password -o PubkeyAuthentication=no ohlushch@lxplus6.cern.ch'
alias ekp1=' sshpass -p $ekppass ssh -XY ohlushch@bms1.etp.kit.edu'
alias ekp2=' sshpass -p $ekppass ssh -XY ohlushch@bms2.etp.kit.edu'
alias ekp3=' sshpass -p $ekppass ssh -XY ohlushch@bms3.etp.kit.edu'
alias ekp='ekp1'
#alias scramb='scram b -j 8; echo $?'
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
alias meld='export PATH=/usr/bin/:$PATH && meld'
alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'
alias pushbash='cd $BASHRCDIR; git pull; git add -p; git commit -m "olena:from rwth"; git push; cd -'
alias pullbash='cd $BASHRCDIR; git pull; cd -'
alias vimbash='vim "$BASHRCDIR"/users/hlushchenko.sh'
alias vimbashcommon='vim "$BASHRCDIR"/users/hlushchenko_common.sh'

alias Pushbash="cd $DIR_BASH; git pull; git add *; git commit -m 'olena:from naf'; git push; cd -"
alias pushbash="cd $DIR_BASH; git pull; git add -p; git commit -m 'olena:from naf'; git push; cd -"
alias pullbash="cd $DIR_BASH; git pull; cd -; source $COMMONBASH"
alias vimbash="vim $SERVERBASH"
alias vimbashcommon="vim $COMMONBASH"
alias cdbash="cd $DIR_BASH"

# CMSSW
# alias scramb='scram b -j `grep -c ^processor /proc/cpuinfo`; echo $?'
# alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'
# alias setcrab='setcrab3'
## CMSSW working environments
alias setartus='setartus10214'
alias setartusdeep='setartus10216deeptau'
alias setdeepartus='setartusdeep'
alias setartusmva='setartus10214mva'
alias setmvaartus='setartusmva'
alias setanalysis='setanalysis747'
alias setskimming='setskimming10216'
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

setfriends(){
    cd  ~/Work/KIT/friends/CMSSW_10_2_14/src/
    if version_gteq $OSVER '7' ; then
        export SCRAM_ARCH=slc7_amd64_gcc700
    elif version_gteq $OSVER '6' ; then
        export SCRAM_ARCH=slc6_amd64_gcc700
    fi
    export $SCRAM_ARCH
    source $VO_CMS_SW_DIR/cmsset_default.sh
    set_cmssw $SCRAM_ARCH
    # export PYTHONPATH=$CMSSW_BASE/src//grid-control/packages:$PYTHONPATH
    export PATH=${CMSSW_BASE}/src/grid-control/:${CMSSW_BASE}/src/grid-control/scripts/:${PATH}
    # source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
}

# Kappa, Artus
export SKIM_WORK_BASE=/net/scratch_cms3b/$USER/kappa
export USERPC='lx3b83'

setharry ()
{
    curr_dirr=$PWD
    cd /home/home2/institut_3b/hlushchenko/Work/HP/CMSSW_8_1_0/src
    set_cmssw slc6_amd64_gcc530
    echo ${cernpass} | web_plotting_no_passwd
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    cd curr_dirr
    cd -
}

#################### Set Skimming #####################
setskimming10216()
{
    startingDir=$(pwd);
    export PYTHONPATH=/.automount/home/home__home2/institut_3b/hlushchenko/Work/KIT/Artus/CMSSW_10_2_14/src/grid-control/packages:/home/home2/institut_3b/hlushchenko/Templates/bashrc;
    cd  ~/Work/Skimming/CMSSW_10_2_16_patch1/src
    set_cmssw slc6_amd64_gcc700
    export PATH=${CMSSW_BASE}/src/grid-control/:${CMSSW_BASE}/src/grid-control/scripts/:${PATH}
    cd $startingDir
    cd $CMSSW_BASE/src/
}
setskimming763()
{
    startingDir=$(pwd)
    cd /.automount/home/home__home2/institut_3b/hlushchenko/Work/CMSSW_7_6_3/src
    set_cmssw slc6_amd64_gcc493
    cd $startingDir
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setskimming8014 ()
{
    startingDir=$(pwd)
    cd ~/Work/CMSSW_8_0_14/src;
    set_cmssw slc6_amd64_gcc530;
    cd $startingDir
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setskimming8020 ()
{
    startingDir=$(pwd)
    cd ~/Work/CMSSW_8_0_20/src;
    set_cmssw slc6_amd64_gcc530;
    cd $startingDir
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
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

    changeHistfile ${FUNCNAME[0]}
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

    changeHistfile ${FUNCNAME[0]}
}


#################### Set Analysis #####################

setartus10214 ()
{
    startingDir=$(pwd)
    export PYTHONPATH=/.automount/home/home__home2/institut_3b/hlushchenko/Work/KIT/Artus/delme/CMSSW_10_2_14/src/grid-control/packages:/home/home2/institut_3b/hlushchenko/Templates/bashrc
    cd  ~/Work/KIT/Artus/delme/CMSSW_10_2_14/src
    SCRAM_ARCH=slc6_amd64_gcc700;
    export $SCRAM_ARCH;
    source $VO_CMS_SW_DIR/cmsset_default.sh;
    set_cmssw slc6_amd64_gcc700;
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh;
}

setartus10216deeptau ()
{
    startingDir=$(pwd)
    export PYTHONPATH=/.automount/home/home__home2/institut_3b/hlushchenko/Work/KIT/Artus/DeepTau/CMSSW_10_2_16/src/grid-control/packages:/home/home2/institut_3b/hlushchenko/Templates/bashrc
    cd  /home/home2/institut_3b/hlushchenko/Work/KIT/Artus/DeepTau/CMSSW_10_2_16/src
    SCRAM_ARCH=slc6_amd64_gcc700;
    export $SCRAM_ARCH;
    source $VO_CMS_SW_DIR/cmsset_default.sh;
    set_cmssw slc6_amd64_gcc700;
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh;
}

setartus10214mva ()
{
    echo "do: 'singularity shell /cvmfs/singularity.opensciencegrid.org/bbockelm/cms\:rhel6'"
    # singularity shell /cvmfs/singularity.opensciencegrid.org/bbockelm/cms\:rhel6
    startingDir=$(pwd)
    export PYTHONPATH=/home/home2/institut_3b/hlushchenko/Templates/bashrc
    cd   ~/Work/KIT/Artus/MVAID/CMSSW_10_2_16/src
    SCRAM_ARCH=slc6_amd64_gcc700;
    export $SCRAM_ARCH;
    source $VO_CMS_SW_DIR/cmsset_default.sh;
    set_cmssw slc6_amd64_gcc700;
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh;
}

setanalysis715()
{
    startingDir=$(pwd)
    cd /home/home2/institut_3b/hlushchenko/Work/CheckReciep/CMSSW_7_1_5/src
    set_cmssw slc6_amd64_gcc481
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    cd $startingDir
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setanalysis747()
{
    startingDir=$(pwd)
    cd /home/home2/institut_3b/hlushchenko/Work/CMSSW_7_4_7/src
    set_cmssw slc6_amd64_gcc491
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    cd $startingDir
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setanalysis747_TauES()
{
    startingDir=$(pwd)
    cd /home/home2/institut_3b/hlushchenko/Work/TauES/CMSSW_7_4_7/src
    set_cmssw slc6_amd64_gcc491
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    cd $startingDir
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
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

    changeHistfile ${FUNCNAME[0]}
}

setskimming924()
{
	startingDir=$(pwd)
	cd /home/home2/institut_3b/hlushchenko/Work/CMSSW_9_2_4/src
	set_cmssw slc6_amd64_gcc530
	cd $startingDir
	cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setskimming940()
{
	startingDir=$(pwd)
	cd  /home/home2/institut_3b/hlushchenko/Work/Skimming/CMSSW_9_4_0/src
	set_cmssw slc6_amd64_gcc630
	cd $startingDir
	cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setskimming942()
{
    startingDir=$(pwd)
    cd  /home/home2/institut_3b/hlushchenko/Work/Skimming/CMSSW_9_4_2/src
    set_cmssw slc6_amd64_gcc630
    cd $startingDir
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
}

setskimming944()
{
    startingDir=$(pwd)
    cd  /home/home2/institut_3b/hlushchenko/Work/Skimming/CMSSW_9_4_4/src
    set_cmssw slc6_amd64_gcc630
    cd $startingDir
    cd $CMSSW_BASE/src/

    changeHistfile ${FUNCNAME[0]}
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

    changeHistfile ${FUNCNAME[0]}
}
