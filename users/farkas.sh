#!/bin/bash

if [ -z "$BASHRCDIR" ]
then
	BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

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
alias scramb='scram b -j ${N_PARALLEL}; echo $?' #building the project via scram b -j 4
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
export USERPC='lx3b57'


setkitanalysis810() {
	export HARRY_REMOTE_USER=mfarkas
	cd /.automount/home/home__home2/institut_3b/farkas/Documents/BA/CMSSW_8_1_0/src
	
	set_cmssw slc7_amd64_gcc530
	
	source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
	
	cd $CMSSW_BASE/
	cd ..
	setgitcolors
}


setnotes() {
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
