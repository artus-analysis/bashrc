#!/bin/bash
echo "Ok bash, glusheno.sh"
if [ -z "$BASHRCDIR" ]
then
	BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

alias vpi='voms-proxy-init -voms cms:/cms/dcms -valid 192:00'
#echo -n "vpi:"
type vpi

alias gridftp='echo "cd /pnfs/physik.rwth-aachen.de/cms/store/user/ohlushch"; uberftp grid-ftp'
#echo -n "gridftp:"
type gridftp

alias cmsdust='cd /nfs/dust/cms/user/glusheno/'
#echo -n "cmsdust:"
type cmsdust


eval "$(ssh-agent -s)"
#ssh-add  ~/.ssh/id_rsa
ssh-add  ~/.ssh/id_rsa_nopass


#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
#cd $0
DIR_PRIVATESETTINGS=${HOME}/RWTH/KIT/privatesettings
DIR_BASH=${HOME}/RWTH/bashrc
SERVERBASH=${HOME}/RWTH/bashrc/users/glusheno.sh
COMMONBASH=${HOME}/RWTH/bashrc/users/hlushchenko_common.sh  # ~ tilda is not expanded in scripts https://stackoverflow.com/a/3963747/3152072
source ${DIR_BASH}/git-prompt.sh
# Path contains only pathes to the scripts
export PATH="$HOME/.local/bin:$PATH"
export PATH=$DIR_BASH/scripts:$PATH
export PATH=$DIR_PRIVATESETTINGS/gc:$PATH
export PATH=$DIR_PRIVATESETTINGS/playground:$PATH
# Path contains only pathes to MODULES with __init__ defined
[[ ":$PYTHONPATH:" != *"$HOME/.local/lib/python2.7/site-packages:"* ]] && PYTHONPATH="$HOME/.local/lib/python2.7/site-packages:${PYTHONPATH}"
source $COMMONBASH
export PYTHONPATH

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
alias scramb='scram b -j $CORES; echo $?; tput bel'
alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
# alias meld='export PATH=/usr/bin/:$PATH && meld'
# alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'
alias myvomsproxyinit='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'

scrambshort(){
    touch temp_scramb_std.txt
    scram b -j $CORES &> temp_scramb_std.txt;
    if [ $? -ne 0 ] ; then
        cat temp_scramb_std.txt
    else echo "compiled"
    fi
    rm temp_scramb_std.txt
    tput bel
}

## CMSSW working environments
alias setkitanalysis='setkitanalysis949_naf'
alias setkitartus='setkitartus949_naf'
alias setkitskimming='setkitskimming8010'
alias setcrab='setcrab3'
# Top level alias
alias setanalysis='setkitanalysis'
alias setartus='setkitartus'
alias setcrab='setcrab3'
alias setskimming='setkitskimming'
alias setshapes='setshapes949_naf'
alias setff='setff804'

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
alias pushbash="cd $DIR_BASH; git pull; git add -p; git commit -m 'olena:from naf'; git push; cd -"
alias pullbash="cd $DIR_BASH; git pull; cd -; source $COMMONBASH"
alias vimbash="vim $SERVERBASH"
alias vimbashcommon="vim $COMMONBASH"
alias cdbash="cd $DIR_BASH"
# Updating dirtyscripts repository
alias pushdirt="cd $DIR_PRIVATESETTINGS; git pull; git add -p; git commit -m 'from naf'; git push; cd -"
alias pulldirt="cd $DIR_PRIVATESETTINGS; git pull; cd -;"
alias cddirt="cd $DIR_PRIVATESETTINGS"

alias setcombine='setcombine810'
setcombine810(){
    cd ~/RWTH/KIT/Combine/CMSSW_8_1_0/src/
	set_cmssw slc6_amd64_gcc530
}
setcombine747(){
	cd ~/RWTH/KIT/Combine/CMSSW_7_4_7/src/
	set_cmssw slc6_amd64_gcc491
}

setharry() {
	cd  ~/RWTH/Artus/CMSSW_7_4_7/src/
	set_cmssw slc6_amd64_gcc491
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
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
}

setff804() {
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Shapes/ES-subanalysis/sm-htt-analysis/CMSSW_8_0_4/src
    export SCRAM_ARCH=slc6_amd64_gcc530
    # export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
    source $VO_CMS_SW_DIR/cmsset_default.sh
    set_cmssw slc6_amd64_gcc530
}

setkitanalysis949_naf() {
	cd /afs/desy.de/user/g/glusheno/RWTH/KIT/sm-htt-analysis/CMSSW_9_4_9/src
	SCRAM_ARCH=slc6_amd64_gcc630
    export $SCRAM_ARCH
	source $VO_CMS_SW_DIR/cmsset_default.sh
	# cmsenv
    set_cmssw slc6_amd64_gcc630

    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
}

setkitartus949_naf() {
    cd /afs/desy.de/user/g/glusheno/RWTH/KIT/Artus/CMSSW_9_4_9/src
    SCRAM_ARCH=slc6_amd64_gcc630
    export $SCRAM_ARCH
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
