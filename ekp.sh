#!/bin/bash

# This script provides the basic commands for typical CMS grid usage
# To use it, put this line in your ~/.bashrc (this will provide the ini command)
#   . /portal/ekpcms6/home/berger/sw/ekpini.sh
#
# If you want some programs to be sourced automatically, add them as arguments:
#   . /portal/ekpcms6/home/berger/sw/ekpini.sh root sge
#
# Once sourced, you can see all available programs to source with
#   ini

# -------------------------------------------------------------

# internal helper functions

ekpinternal_list_scram_arch()
{
	for i in $(ls /cvmfs/cms.cern.ch/slc${HOSTNAME/ekpcms/}_amd64_gcc*/cms/cmssw/${1} -d)
	do
		abc=${i/\/cvmfs\/cms.cern.ch\//}
		echo ${abc/\/cms\/cmssw\//: }
	done
}

ekpinternal_get_scram_arch()
{
	abc=$(ls /cvmfs/cms.cern.ch/slc${HOSTNAME/ekpcms/}_amd64_gcc*/cms/cmssw/${1}* -dt | head -n 1)
	abc=${abc/\/cvmfs\/cms.cern.ch\//}
	echo ${abc/\/cms\/cmssw\/*/}
}

ekpinternal_init_cmssw()
{
	export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch/
	source /cvmfs/cms.cern.ch/cmsset_default.sh
	#echo arch is $SCRAM_ARCH and vo is $VO_CMS_SW_DIR
	if [[ `pwd` =~ "CMSSW_" ]]; then
		echo "Init cmssw"
		eval `scram runtime -sh`
	fi
	gettestfile()
	{
		[[ "$2" == "" ]] && echo "Usage: gettestfile DAS_filename.root localfilename.root" && return 1
		which xrdcp &> /dev/null || echo "Do 'cmsenv' first"
		xrdcp -f root://cms-xrd-global.cern.ch/$1 /storage/6/berger/testfiles/$2
	}
}

ekpini()
{
	case "$1" in
		"")
			echo "ini (cmssw4|cmssw5|cmssw6|cmssw7|grid|root|sge|neurobayes|gc)"
		;;
		cmssw4)
			ekpinternal_init_cmssw
		;;
		cmssw5)
			export SCRAM_ARCH="slc${HOSTNAME/ekpcms/}_amd64_gcc462"  # CMSSW_5_3_14
			ekpinternal_init_cmssw
		;;
		cmssw6)
			export SCRAM_ARCH="slc${HOSTNAME/ekpcms/}_amd64_gcc472" &&  # CMSSW_6_2_11
			ekpinternal_init_cmssw
		;;
		cmssw7)
			export SCRAM_ARCH=slc6_amd64_gcc481 &&  # CMSSW_7_0_9
			ekpinternal_init_cmssw
		;;
		grid)
			command -v voinfo &> /dev/null && return 1
			#source /cvmfs/grid.cern.ch/3.2.11-1/etc/profile.d/grid-env.sh > /dev/null
			source /cvmfs/grid.cern.ch/emi3ui-latest/etc/profile.d/setup-ui-example.sh > /dev/null
			export X509_USER_PROXY=$HOME/.globus/proxy.grid
			alias voinit='voms-proxy-init -voms cms:/cms/dcms -valid 192:00' # -vomses /etc/vomses/'
			alias voinfo='voms-proxy-info --all'
		;;
		root)
			echo "ROOT is not implemented yet" && return 1
			export ROOTSYS=/cvmfs/cms.cern.ch/slc5_amd64_gcc462/lcg/root/5.32.00/
			[ ! -d $ROOTSYS ] && echo "ROOT path $SW_ROOTPATH does not exist" && return 1
			#command -v root &> /dev/null && echo "ROOT installed" && return 1
			export PATH="$PATH:$ROOTSYS/bin"
			export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ROOTSYS/lib:$ROOTSYS/lib/root"
			export PYTHONPATH=$ROOTSYS/lib/root:$PYTHONPATH
			echo -e "Loading `$ROOTSYS/bin/root-config --version` .\c" &&
			echo ".." || echo "!!!"
		;;
		python)
			#/cvmfs/cms.cern.ch/slc5_amd64_gcc462/external/python/2.7.3/bin/python
			echo "Python is not implemented yet"
		;;
		sgeold|batch)
			source /opt/ogs/ekpcluster/common/settings.sh
		;;
		sge)
			source /opt/ogs_sl6/ekpclusterSL6/common/settings.sh
		;;
		neurobayes)
			source ~phit/neurobayes_64/setup_neurobayes.sh
		;;
		gc|gridcontrol)
			export GC_PATH=/usr/users/berger/sw/grid-control_stablefixes
			export PATH=$PATH:$GC_PATH:$GC_PATH/scripts
		;;
		*)
			echo "ini:" $1 "not found."
			ini
	esac
}
