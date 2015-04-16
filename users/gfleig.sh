#!/bin/bash

shopt -s expand_aliases

####################################################################
# Shell variables
####################################################################
# bash settings

# path pc lang editor python
export USERPC="ekplx16"
export LANG=en_US.UTF-8
export EDITOR=nano
export LS_OPTIONS='-N -T 0 --color=auto'
export PYTHONSTARTUP=$HOME/.pythonrc


####################################################################
# User aliases
####################################################################

alias ex='mini excalibur'
alias oldex='mini oldexcalibur'
alias ll='ls -lh'
alias la='ls -lAh'


####################################################################
# User functions
####################################################################

mini() # user programs at ekp
{
	case "$1" in
		"")
			echo "ini (excalibur|oldexcalibur)"
		;;
		excalibur)
			source ~/bashrc/cmssw.sh
			set_cmssw slc6_amd64_gcc481
			if [[ $HOSTNAME == *naf* ]]; then
				cd /afs/desy.de/user/g/gfleig/zjet/CMSSW_7_2_0/src
				eval `scramv1 runtime -sh`
				cd /afs/desy.de/user/g/gfleig/zjet/Excalibur
				source scripts/ini_excalibur.sh
				export EXCALIBUR_WORK=/nfs/dust/cms/user/gfleig/zjet
				export PATH=$PATH:/afs/desy.de/user/g/gfleig/zjet/grid-control
			else
				cd /home/gfleig/new/CMSSW_7_2_0/src
				eval `scramv1 runtime -sh`
				cd /home/gfleig/new/Excalibur
				source scripts/ini_excalibur.sh
				export EXCALIBUR_WORK=/storage/a/gfleig/zjet
				export PATH=$PATH:/home/gfleig/new/grid-control
			fi
		;;
		*)
			echo "mini:" $1 "not found"
			mini
	esac
}

rot()
{
 ipython -i $BASHRCDIR/scripts/rot.py $@
}

stty erase '^?'

# script to calculate the average number of evts/s from the output of a 
# excalibur run with grid-control.
averageEvents ()
{(
    find $1 -name job.stdout.gz | xargs less | grep Status | cut -d"-" -f 3 | cut -d"/" -f 1 > /tmp/averageEvents_$USER.txt
    awk '{sum+=$1; echo $1} END { print "Average = ",sum/NR}' /tmp/averageEvents_$USER.txt
)}
