#!/bin/bash
echo " * --> export glusheno.sh"

if [ -z "$BASHRCDIR" ]
then
	BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

alias vpi='voms-proxy-init -voms cms:/cms/dcms -valid 192:00'
alias cmsdust='cd /nfs/dust/cms/user/glusheno/'
type cmsdust

# Run ssh-agent
eval "$(ssh-agent -s)"
#ssh-add  ~/.ssh/id_rsa
ssh-add  ~/.ssh/id_rsa_nopass


#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#cd $0
DIR_BASH=${HOME}/RWTH/bashrc
DIR_BASHHISTORY=/nfs/dust/cms/user/glusheno/bash_history
SERVERBASH=${HOME}/RWTH/bashrc/users/glusheno.sh
COMMONBASH=${HOME}/RWTH/bashrc/users/hlushchenko_common.sh  # ~ tilda is not expanded in scripts https://stackoverflow.com/a/3963747/3152072

DIR_PRIVATESETTINGS=${HOME}/RWTH/KIT/privatesettings
source ${DIR_PRIVATESETTINGS}/env_scripts/git-prompt.sh
export HARRY_REMOTE_USER='ohlushch'
# Path contains only pathes to the scripts
export PATH="$HOME/.local/bin:$PATH"
export PATH=$DIR_BASH/scripts:$PATH
export PATH=$DIR_PRIVATESETTINGS/gc:$PATH
export PATH=$DIR_PRIVATESETTINGS/playground:$PATH
export PATH=$DIR_PRIVATESETTINGS/artus:$PATH
# export PATH=$DIR_PRIVATESETTINGS/python_wrappers:$PATH
# Path contains only pathes to MODULES with __init__ defined
[[ ":$PYTHONPATH:" != *"$HOME/.local/lib/python2.7/site-packages:"* ]] && PYTHONPATH="$HOME/.local/lib/python2.7/site-packages:${PYTHONPATH}"
[[ ":$PYTHONPATH:" != *"$DIR_PRIVATESETTINGS:"* ]] && PYTHONPATH="$DIR_PRIVATESETTINGS:${PYTHONPATH}"

source $COMMONBASH
export PYTHONPATH

# History
mkdir -p $DIR_BASHHISTORY
export HISTTIMEFORMAT="%F %T: "
# Save and reload the history after each command finishes : https://unix.stackexchange.com/a/18443/137225
export HISTCONTROL=ignoreboth  # no duplicate entries
shopt -s histappend                      # append to history, don't overwrite it
# export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
# export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"
# https://unix.stackexchange.com/a/48113/137225 :
# Forse to save all commands to the history : all history in all tabs is stored
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

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
alias myvomsproxyinit='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'

scrambshort() {
    touch temp_scramb_std.txt
    scram b -j $CORES &> temp_scramb_std.txt;
    if [ $? -ne 0 ] ; then
        cat temp_scramb_std.txt
    else echo "compiled"
    fi
    rm temp_scramb_std.txt
    tput bel
}

transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX )
    curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
    # cat $tmpfile | pbcopy; # Only for OS X
    cat $tmpfile;
    rm -f $tmpfile;
}

# CMSSW
alias scramb='scram b -j $CORES; echo $?; tput bel'
alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'
alias setcrab='setcrab3'
## CMSSW working environments
## Top level alias
alias setanalysis='setkitanalysis'
alias setartus='setkitartus'
alias setskimming='setkitskimming'
alias setshapes='setharry ; setkitshapes'
alias setff='setkitff'
alias setcombine='setcombine810'
### KIT
alias setkitanalysis='setkitanalysis949_naf'
alias setkitartus='setkitartus949_naf'
alias setkitskimming='setkitskimming9412'
alias setkitshapes='setshapes949_naf'
alias setkitff='setff804'

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

## Working environments
alias zombie='kinit; aklog'
alias grep='/bin/grep'
# Updating bash repository
alias Pushbash="cd $DIR_BASH; git pull; git add *; git commit -m 'olena:from naf'; git push; cd -"
alias pushbash="cd $DIR_BASH; git pull; git add -p; git commit -m 'olena:from naf'; git push; cd -"
alias pullbash="cd $DIR_BASH; git pull; cd -; source $COMMONBASH"
alias vimbash="vim $SERVERBASH"
alias vimbashcommon="vim $COMMONBASH"
alias cdbash="cd $DIR_BASH"
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
	cd  ~/RWTH/Artus/CMSSW_7_4_7/src/
	set_cmssw slc6_amd64_gcc491
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh

    changeHistfile ${FUNCNAME[0]}
}

setshapes949_naf() {
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

setkitanalysis949_naf() {
	cd /afs/desy.de/user/g/glusheno/RWTH/KIT/sm-htt-analysis/CMSSW_9_4_9/src
	SCRAM_ARCH=slc6_amd64_gcc630
    export $SCRAM_ARCH
	source $VO_CMS_SW_DIR/cmsset_default.sh
	# cmsenv
    set_cmssw slc6_amd64_gcc630

    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh


    changeHistfile ${FUNCNAME[0]}
}

setkitartus949_naf() {
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Artus/CMSSW_9_4_9/src
    SCRAM_ARCH=slc6_amd64_gcc630
    export $SCRAM_ARCH
    source $VO_CMS_SW_DIR/cmsset_default.sh
    # cmsenv
    set_cmssw slc6_amd64_gcc630

    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh


    changeHistfile ${FUNCNAME[0]}
}

setkitartus9412_naf() {
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Artus/CMSSW_9_4_12/src
    export SCRAM_ARCH=slc6_amd64_gcc630
    source $VO_CMS_SW_DIR/cmsset_default.sh
    set_cmssw slc6_amd64_gcc630

    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh


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
