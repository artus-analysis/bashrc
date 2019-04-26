#!/bin/bash

if [ -z "$BASHRCDIR" ]
then
	BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

# Ubuntu/Gnome
textsize()
{
	gsettings set org.gnome.desktop.interface text-scaling-factor ${1-1.0}
}

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
export N_CORES=`grep -c ^processor /proc/cpuinfo`
export N_PARALLEL=$(( $N_CORES < 20 ? $N_CORES : 20 ))

# ALIASES
alias scramb='scram b -j ${N_PARALLEL}; echo $?'
alias scrambdebug='scram b -j ${N_PARALLEL} USER_CXXFLAGS="-g"'
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
alias meld='export PATH=/usr/bin/:$PATH && meld'
alias gmerge='(export PATH=/usr/bin/:$PATH && git mergetool --tool meld)'
alias myvomsproxyinit='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'
alias gitpullcmssw='git fetch origin && git merge origin/master'

ssh_agent()
{
	eval "$(ssh-agent -s)"
	ssh-add
}

# RWTH
rdesktop_winsrv_de()
{
	rdesktop -d PHYSIK -g 93% -a 16 -k de -u tmuller winsrv.physik.rwth-aachen.de -z $@ &
}
rdesktop_winsrv_us()
{
	rdesktop -d PHYSIK -g 93% -a 16 -k en-us -u tmuller winsrv.physik.rwth-aachen.de -z $@ &
}

# CMSSW
alias setkitanalysis='setkitanalysis810'
alias setkitskimming='setkitskimming80261'
alias settauvalidation='settauvalidation9001'
alias setcrab='setcrab3'
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch/
export PATH=/afs/cern.ch/user/v/valya/public/dasgoclient/:$PATH

alias setnotes='setnotes_git'

# Operation
rdesktop_cerntscms()
{
	rdesktop -g 93% -a 24 -u tmuller -d CERN cerntscms.cern.ch -z $@ &
}

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

# Kappa, Artus
export SKIM_WORK_BASE=/net/scratch_cms3b/$USER/kappa
export USERPC='lx3b85'


setkitanalysis5332() {
	cd ~/home/cms/htt/analysis/CMSSW_5_3_32/src
	
	set_cmssw slc6_amd64_gcc472
	
	cd $CMSSW_BASE/src/
}
setkitanalysis715() {
	cd ~/home/cms/htt/analysis/CMSSW_7_1_5/src
	
	set_cmssw slc6_amd64_gcc481
	
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/src/
}
setkitanalysis747() {
	cd ~/home/cms/htt/analysis/CMSSW_7_4_7/src
	
	set_cmssw slc6_amd64_gcc491
	
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/src/
}
setkitanalysis810() {
	cd ~/home/cms/htt/analysis/CMSSW_8_1_0/src
	
	set_cmssw slc7_amd64_gcc530
	
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/src/
}


setkitskimming763() {
	cd ~/home/cms/htt/skimming/CMSSW_7_6_3/src
	
	set_cmssw slc6_amd64_gcc493
	
	cd $CMSSW_BASE/src/
}
setkitskimming8010() {
	cd ~/home/cms/htt/skimming/CMSSW_8_0_10/src
	
	set_cmssw slc6_amd64_gcc530
	
	cd $CMSSW_BASE/src/
}
setkitskimming8021() {
	cd ~/home/cms/htt/skimming/CMSSW_8_0_21/src
	
	set_cmssw slc6_amd64_gcc530
	
	cd $CMSSW_BASE/src/
}
setkitskimming80261() {
	cd ~/home/cms/htt/skimming/CMSSW_8_0_26_patch1/src
	
	set_cmssw slc7_amd64_gcc530
	
	cd $CMSSW_BASE/src/
}
setkitskimming949() {
	cd ~/home/cms/htt/skimming/CMSSW_9_4_9/src
	
	set_cmssw slc7_amd64_gcc530
	
	cd $CMSSW_BASE/src/
}


setgenerator() {
	cd ~/home/cms/htt/generator/
	set_cmssw slc6_amd64_gcc481
}


setgenerator71162() {
	setgenerator
	cd CMSSW_7_1_16_patch2/src
	
	set_cmssw slc6_amd64_gcc481
	
	cd $CMSSW_BASE/src/
}
setgenerator7118() {
	setgenerator
	cd CMSSW_7_1_18/src
	
	set_cmssw slc6_amd64_gcc481
	
	cd $CMSSW_BASE/src/
}

settauvalidation9001() {
	cd ~/home/cms/htt/tauvalidation/CMSSW_9_0_0_pre1/src
	
	set_cmssw slc6_amd64_gcc530
	
	cd $CMSSW_BASE/src/
}


setjuno() {
	[ ! -e ~/bin ] && mkdir ~/bin
	[ ! -e ~/bin/python ] && ln -s `which python27` ~/bin/python
	export PATH=~/bin:$PATH

	cd ~/home/juno/
	source Artus/Configuration/scripts/ini_artus_python_standalone.sh
	source Artus/HarryPlotter/scripts/ini_harry.sh

	cd ReliabilityCalc
}


setnotes_svn() {
	# https://github.com/cms-analysis/HiggsAnalysis-KITHiggsToTauTau/wiki/Papers#analysis-notes
	cd ~/Notes/notes
	eval `./tdr runtime -sh`
	for NOTE in *-*-*; do
		echo ""
		echo "svn up ${NOTE}"
		echo "cd ${NOTE}/trunk"
		echo "tdr --style=`[[ ${NOTE} = AN-* ]] && echo "an" || echo "paper"` b ${NOTE} && gnome-open ../../tmp/${NOTE}_temp.pdf &> /dev/null"
	done
	echo ""
}


setnotes_git() {
	# https://twiki.cern.ch/twiki/bin/viewauth/CMS/Internal/TdrProcessing
	cd ~/Notes
	
	git config --global user.name "Thomas Müller"
	git config --global user.email "t.muller@cern.ch"
	git config --global http.emptyAuth true
	kinit tmuller@CERN.CH
	
	# git clone --recursive https://:@gitlab.cern.ch:8443/tdr/papers/SMP-18-010.git
	# git clone --recursive https://:@gitlab.cern.ch:8443/tdr/notes/AN-18-051.git
	# git clone --recursive https://:@gitlab.cern.ch:8443/tdr/notes/AN-18-050.git
	
	for NOTE in *-*-*; do
		echo ""
		echo "cd ${NOTE} && eval \`utils/tdr runtime -sh\`"
		echo "git pull; gitk --all&"
		echo "tdr --temp_dir=\`pwd\`/tmp --clean --style=`[[ ${NOTE} = AN-* ]] && echo "an" || echo "paper"` b ${NOTE} && gnome-open tmp/${NOTE}_temp.pdf &> /dev/null"
	done
	echo ""
}


clean_root_partition() {
	sudo apt-get autoremove
	sudo apt-get autoclean
	sudo apt-get clean
}

