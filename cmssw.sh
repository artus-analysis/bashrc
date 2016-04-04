#!/bin/bash

#source cmssw
set_cmssw()
{
	export SCRAM_ARCH=${1-:slc5_amd64_gcc462}
	if [ -z "$VO_CMS_SW_DIR" ]
	then
		echo "ERROR: 'VO_CMS_SW_DIR' is not set!"
	else
		source $VO_CMS_SW_DIR/cmsset_default.sh
		if [ ! -z "$CMSSW_BASE" ]
		then
			eval `scramv1 runtime -sh`
		fi
	fi
}

alias cmssw_slc5_gcc462="set_cmssw slc5_amd64_gcc462"
alias cmssw_slc6_gcc472="set_cmssw slc6_amd64_gcc472"
alias cmssw_slc6_gcc481="set_cmssw slc6_amd64_gcc481"
alias cmssw_slc6_gcc491="set_cmssw slc6_amd64_gcc491"
