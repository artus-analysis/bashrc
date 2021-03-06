#!/bin/bash

BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

[ -f $BASHRCDIR/default.sh ] && source $BASHRCDIR/default.sh


if [[ `hostname -s` = ekpgisub ]]; then
    return
fi

case $HOSTNAME in
	"ekpcms"*|"nafhh"*|"lxplus"*|"ekpblus"*)
		ISLOGIN="true"
	;;
esac

[ "$TERM" != "dumb" ] && [ ! -z $ISLOGIN ] && echo -e "Login\c"

[ -f /etc/bashrc ] && source /etc/bashrc
#  .gitconfig
#if login: Login to host ... sonst nix
#hostname
#username (==berger?)
#root? $ blue # red
#local, portal, batch/cluster?
#yellow green   red

#variables:
#PATH
#nano

#aliases
#voms  voinfo, vobox
#
#functions:


#ini:		laptop
#			lx	ekp	naf	cer
#root		+	+	+	+	?
#cmssw56		rc	ini	done
#cmsenv			aut	au?	+
#ex			+	+	+	+
#higgs		+	+	+	+
#grid			+	+	+
#lhapdf			+	+	+

#git compl., history, nano, colors



####################################################################
# Shell variables
####################################################################
# bash settings

# path pc lang editor python
export USERPC="ekplx32"
export LANG=en_US.UTF-8
export EDITOR=nano
export LS_OPTIONS='-N -T 0 --color=auto'
export PYTHONSTARTUP=$HOME/.pythonrc

# prompt
[ "$TERM" != "dumb" ] && export PS1='\[\033[01;33m\]\h\[\033[00m\]:\[\033[01;34m\]\w \[\033[01;34m\]\$\[\033[00m\] '
[ "$TERM" != "dumb" ] && [ -f .git-completion.bash ] && source ~/.git-completion.bash &&
case "$HOSTNAME" in
	"ekpcms"*|"nafhh"*|"lxplus"*)
		PS1='\[\033[01;33m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[0;32m\]$(__git_ps1 "[%s]") \[\033[01;34m\]\$\[\033[00m\] '
		;;
	"ekpblus"*)
		PS1='\[\033[01;31m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[0;32m\]$(__git_ps1 "[%s]") \[\033[01;34m\]\$\[\033[00m\] '
		;;
	*)
		PS1='\[\033[33m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[0;32m\]$(__git_ps1 "[%s]") \[\033[01;34m\]\$\[\033[00m\] '
		;;
esac

[ -d /home/berger/sw/texmf ] && export TEXINPUTS=.:/home/berger/sw/texmf/tex/latex///:
[ -f /etc/local/aliases.sh ] && source /etc/local/aliases.sh

alias gitv='vsn=$(git describe --long) && vsn=${vsn/-/\.} && vsn=${vsn/v/} && echo "Excalibur ${vsn/-*/} ($(git describe --long))"'
#portals
alias vobox='ini grid; gsissh -p 1975 cms-kit.gridka.de'
alias ex='mini excalibur'

####################################################################
# Host specific settings
####################################################################


[ -d /home/berger/sw/bin ] && export PATH=$PATH:/home/berger/sw/bin

[ "$TERM" != "dumb" ] && [ ! -z $ISLOGIN ] && echo -e " to \c"

####################################################################
# User functions
####################################################################


getid()
{
	ps wafux | grep -v grep | grep berger | grep $1 | awk '{print $2 " " $11 $12 $13}'
}

gr()
{
	grep -rI $1 src/
}

####################################################################

mini() # user programs at ekp
{
	case "$1" in
		"")
			echo "ini (excalibur|higgs|lhapdf|ex)"
		;;
		kappadev)
			cd /home/berger/test/CMSSW_5_3_14
			ini cmssw5
			cd /home/berger/test/Kappa
			PROMPT_COMMAND="echo -ne \"\033]0;Kappa development\007\""
		;;
		excalibur1)
			cd /home/berger/oldexcalibur/CMSSW_5_3_14_patch2
			ini cmssw5
			cd /home/berger/oldexcalibur/excalibur
			source scripts/ini_excalibur
			export EXCALIBUR_WORK=/storage/8/berger/excalibur
			PROMPT_COMMAND="echo -ne \"\033]0;Excalibur\007\""
		;;
		excalibur2|ex)
			export SCRAM_ARCH=slc6_amd64_gcc481
			cd /home/berger/excalibur/CMSSW_7_4_0_pre9/src
			ini cmssw7
			cd /home/berger/excalibur/Excalibur
			source scripts/ini_excalibur.sh
			export EXCALIBUR_WORK=/storage/8/berger/excalibur
			PROMPT_COMMAND="echo -ne \"\033]0;Excalibur2\007\""
		;;
		higgs)
			cd /home/berger/higgs/CMSSW_5_3_9/
			ini cmssw5
			cd src/Desy*
			cd TauTauAnalysis/test/
			source ~phit/neurobayes_64/setup_neurobayes.sh
		;;
		lhapdf)
			export LHAPDF=/home/berger/sw/lhapdf590
			export PATH=$PATH:$LHAPDF/bin
			export LHAPATH=$LHAPDF/share/lhapdf/PDFsets
			export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LHAPDF/lib
			export PYTHONPATH=$PYTHONPATH:$LHAPDF/lib/python2.6/site-packages
		;;
		*)
			echo "mini:" $1 "not found"
			mini
	esac
}


[ "$TERM" != "dumb" ] && [ ! -z $ISLOGIN ] && echo $HOSTNAME
[ "$TERM" != "dumb" ] && [ "$HOSTNAME" == "ekpcms5" ] && cd /home/berger
[ "$TERM" != "dumb" ] && [ "$HOSTNAME" == "ekpcms6" ] && cd /home/berger

