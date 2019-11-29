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
export DIR_BASHHISTORY=/home/ohlushch/bash_history
SERVERBASH=${DIR_BASH}/users/ohlushch.sh
COMMONBASH=${DIR_BASH}/users/hlushchenko_common.sh  # ~ tilda is not expanded in scripts https://stackoverflow.com/a/3963747/3152072
# Updating bash repository
alias pushbash="cd $DIR_BASH; git pull; git add -p; git commit -m 'olena:from naf'; git push; cd -"
alias pullbash="cd $DIR_BASH; git pull; cd -; source $COMMONBASH"
alias vimbash="vim $SERVERBASH"
alias vimbashcommon="vim $COMMONBASH"
alias cdbash="cd $DIR_BASH"

# Run ssh-agent
if [[ -v TMPFILEAGENT ]]; then
    echo "TMPFILEAGENT:" \"$TMPFILEAGENT\"
    ssh_agent_pid=$(awk '{ print $3 }' ${TMPFILEAGENT})
    kill -HUP "$ssh_agent_pid"
fi
export TMPFILEAGENT=$(mktemp /tmp/abc-script.XXXXXX)
eval "$(ssh-agent -s)" > ${TMPFILEAGENT}
# ssh-add  ~/.ssh/id_rsa
ssh-add  ~/.ssh/id_rsa_nopass

source  ~/bashrc/users/hlushchenko_common.sh
source  ~/bashrc/users/hlushchenko_common_cmssw.sh
#source $BASHRCDIR/users/hlushchenko_common.sh

# try to comment out
source ~/git-prompt.sh

# History
# mkdir -p $DIR_BASHHISTORY
export HISTTIMEFORMAT="%F %T: "
# Save and reload the history after each command finishes : https://unix.stackexchange.com/a/18443/137225
export HISTCONTROL=ignoreboth  # no duplicate entries
shopt -s histappend
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
# export PROMPT_COMMAND="[\[$(date +%D\ %H:%M)\]]\n\[\033[104m\]\h : \w \[\033[00m\] \[\033[104m\]\$\[\033[00m\]; history -a; history -c; history -r"
# CMSSW
[ -f $BASHRCDIR/cmssw.sh ] && source $BASHRCDIR/cmssw.sh

# ENVIRONMENT
export PS1="\[\033[104m\]\h : \w \$\[\033[00m\] "
export LANG=en_US.UTF-8
export EDITOR=vim
export LS_OPTIONS="-N -T 0 --color=auto"


export HARRY_REMOTE_USER='ohlushch'
export PATH="$HOME/.local/bin:$HOME/usr/bin:$PATH"
export DIR_PRIVATESETTINGS=${HOME}/Work/dirtyscripts
alias cddirt="cd $DIR_PRIVATESETTINGS"
source ~/bashrc/users/greyxray/dirtyscripts.sh


# ALIASES
alias meld='export PATH=/usr/bin/:$PATH && meld'
alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'


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

# Job Submission
setcrab3() {
	source /cvmfs/cms.cern.ch/crab3/crab.sh
}

alias setartus=setanalysis10214

## Working environments

### Combine
alias setcombine='source ~/git-prompt.sh ; setcombine10216ul'
setcombine10216ul()
{
    # https://github.com/KIT-CMS/sm-htt-analysis/blob/master/utils/init_cmssw.sh
    cd /home/ohlushch/Work/Combine/CMSSW_10_2_16_UL/src

    if version_gteq $OSVER '7' ; then
        set_cmssw slc7_amd64_gcc700
    elif version_gteq $OSVER '6' ; then
        set_cmssw slc6_amd64_gcc700
    fi
    cd /home/ohlushch/Work/Combine/CMSSW_10_2_16_UL/src/CombineHarvester/MSSMvsSMRun2Legacy

    export PATH="$DIR_PRIVATESETTINGS/fes:$PATH"
}
### Shapes
alias setshapes='source ~/git-prompt.sh ; setharry10216 ; setshapes949'
alias setmastershapes='setshapesmaster'

setshapes949() {
    set -a ; source   $HOME/Work/SHAPES/sm-htt-analysis/utils/setup_samples.sh; set +a
    # export PATH="$HOME/.local/bin:$HOME/usr/bin:$PATH"
    cd /home/ohlushch/Work/SHAPES/ES-subanalysis
    source bin/setup_env.sh
    # GIT_PS1_HIDE_IF_PWD_IGNORED='disable'
    DIR_SMHTT=""
}

setshapesmaster() {
    echo "CMSSW env taken from ~/Work/Artus/CMSSW_10_2_14/src"
    cd ~/Work/Artus/CMSSW_10_2_14/src
    if version_gteq $OSVER '7' ; then
        export SCRAM_ARCH=slc7_amd64_gcc700
    elif version_gteq $OSVER '6' ; then
        export SCRAM_ARCH=slc6_amd64_gcc700
    fi
    source $VO_CMS_SW_DIR/cmsset_default.sh
    set_cmssw $SCRAM_ARCH
    cd -

    cd /home/ohlushch/Work/SHAPES/sm-htt-analysis

    # get the propper python
    LCG_RELEASE=94
    if uname -a | grep ekpdeepthought
    then
        source /cvmfs/sft.cern.ch/lcg/views/LCG_${LCG_RELEASE}/x86_64-ubuntu1604-gcc54-dbg/setup.sh
    else
        if version_gteq $OSVER '7' ; then
            echo /cvmfs/sft.cern.ch/lcg/views/LCG_${LCG_RELEASE}/x86_64-centos7-gcc62-opt/setup.sh
            source /cvmfs/sft.cern.ch/lcg/views/LCG_${LCG_RELEASE}/x86_64-centos7-gcc62-opt/setup.sh
        elif version_gteq $OSVER '6' ; then
            echo /cvmfs/sft.cern.ch/lcg/views/LCG_${LCG_RELEASE}/x86_64-slc6-gcc62-opt/setup.sh
            source /cvmfs/sft.cern.ch/lcg/views/LCG_${LCG_RELEASE}/x86_64-slc6-gcc62-opt/setup.sh
        fi
    fi
    [[ ":$PYTHONPATH:" != *"$HOME/.local/lib/python2.7/site-packages:"* ]] && PYTHONPATH="$HOME/.local/lib/python2.7/site-packages:${PYTHONPATH}"
    export PYTHONPATH

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

    # start with 2017
    source utils/setup_samples.sh 2017
    ERA=2017
    CHANNELS="et"
    BINNING=shapes/binning.yaml
}

### HP
alias setharry='setharry810 ; export PATH="$DIR_PRIVATESETTINGS/fes:$PATH"'
setharry10216() {
    alias grfc='get_root_file_content.py'
    curr_dirr=$PWD
    # cd /home/ohlushch/Work/HP/CMSSW_8_1_0/src
    cd /home/ohlushch/Work/HP/CMSSW_10_2_16/src
    set_cmssw slc6_amd64_gcc700

    source $CMSSW_BASE/src/Artus/Configuration/scripts/ini_ArtusAnalysis.sh
    source $CMSSW_BASE/src/Artus/HarryPlotter/scripts/ini_harry_cmssw.sh
    export KITHIGGSTOTAUTAUPATH=$CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau

    # overwrite artus settings
    export HARRY_URL=http://etpwww.etp.kit.edu/~${HARRY_REMOTE_USER}/
    export ARTUS_WORK_BASE="/storage/8/${USER}/htautau/artus/"
    export WEB_PLOTTING_MKDIR_COMMAND="mkdir -p /etpwww/web/ohlushch/public_html/{subdir}"
    export WEB_PLOTTING_COPY_COMMAND="cp {source} /etpwww/web/ohlushch/public_html/{subdir}"
    export WEB_PLOTTING_LS_COMMAND="ls /etpwww/web/ohlushch/public_html/{subdir}"

    export HP_WORK_BASE_COMMON="/storage/8/${USER}/htautau/artus/HP_WORK_BASE_COMMON"

    # echo $cernpass | kinit -l 120h ${HARRY_REMOTE_USER}@CERN.CH
    # use then you get this fancy index with regex search: http://ekpwww.etp.kit.edu/~jbechtel/plots_archive/2019_08_07/plots/mt/index.html
    # cp /home/jbechtel/WebGallery/gallery.py  /ekpwww/web/ohlushch/
    # python  /ekpwww/web/ohlushch/gallery.py /ekpwww/web/ohlushch/public_html/{subdir} --metadata blah

    cd $curr_dirr
    cd -
    changeHistfile ${FUNCNAME[0]}
}
setharry810() {
    alias grfc='get_root_file_content.py'
    curr_dirr=$PWD
    cd /home/ohlushch/Work/HP/CMSSW_8_1_0/src
    set_cmssw slc6_amd64_gcc530

    source $CMSSW_BASE/src/Artus/Configuration/scripts/ini_ArtusAnalysis.sh
    source $CMSSW_BASE/src/Artus/HarryPlotter/scripts/ini_harry_cmssw.sh
    export KITHIGGSTOTAUTAUPATH=$CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau

    # overwrite artus settings
    export HARRY_URL=http://etpwww.etp.kit.edu/~${HARRY_REMOTE_USER}/
    export ARTUS_WORK_BASE="/storage/8/${USER}/htautau/artus/"
    export WEB_PLOTTING_MKDIR_COMMAND="mkdir -p /etpwww/web/ohlushch/public_html/{subdir}"
    export WEB_PLOTTING_COPY_COMMAND="cp {source} /etpwww/web/ohlushch/public_html/{subdir}"
    export WEB_PLOTTING_LS_COMMAND="ls /etpwww/web/ohlushch/public_html/{subdir}"

    export HP_WORK_BASE_COMMON="/storage/8/${USER}/htautau/artus/HP_WORK_BASE_COMMON_810"

    # echo $cernpass | kinit -l 120h ${HARRY_REMOTE_USER}@CERN.CH
    # use then you get this fancy index with regex search: http://ekpwww.etp.kit.edu/~jbechtel/plots_archive/2019_08_07/plots/mt/index.html
    # cp /home/jbechtel/WebGallery/gallery.py  /ekpwww/web/ohlushch/
    # python  /ekpwww/web/ohlushch/gallery.py /ekpwww/web/ohlushch/public_html/{subdir} --metadata blah

    cd $curr_dirr
    cd -
    changeHistfile ${FUNCNAME[0]}
}
# alias grep='/bin/grep'
# sethappy() {
# 	cd  ~/RWTH/Artus/CMSSW_7_4_7/src/
# 	set_cmssw slc6_amd64_gcc491;
# 	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh;

# }
### FRIENDS
setfriends(){
    cd  /portal/ekpbms1/home/ohlushch/friends/CMSSW_10_2_14/src
    if version_gteq $OSVER '7' ; then
        export SCRAM_ARCH=slc7_amd64_gcc700
    elif version_gteq $OSVER '6' ; then
        export SCRAM_ARCH=slc6_amd64_gcc700
    fi
    export $SCRAM_ARCH
    source $VO_CMS_SW_DIR/cmsset_default.sh
    set_cmssw slc6_amd64_gcc700
    # source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
}
### Artus
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

setsshaggent()
{
        eval "$(ssh-agent -s)"
        # ssh-add  ~/.ssh/id_rsa
        ssh-add  ~/.ssh/id_rsa_nopass
}
