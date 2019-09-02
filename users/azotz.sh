#!/usr/bin/bash

export HARRY_REMOTE_USER=azotz
export X509_USER_PROXY=$HOME/.globus/x509up
# export LANG=en_US.UTF-8
# export LD_LIBRARY_PATH=/cvmfs/grid.cern.ch/centos7-ui-4.0.3-1_umd4v3/usr/lib64:/cvmfs/grid.cern.ch/centos7-ui-4.0.3-1_umd4v3/usr/lib:/usr/lib64/nvidia:/usr/lib/nvidia
# export SINGULARITY_SHELL="/bin/bash --norc"

alias cmssrc='export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch && source $VO_CMS_SW_DIR/cmsset_default.sh'
alias crabsrc='source /cvmfs/cms.cern.ch/crab3/crab.sh'
alias httsrc='source ${CMSSW_BASE}/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh'
alias gcsrc='export PATH=$PATH:${CMSSW_BASE}/src/grid-control:${CMSSW_BASE}/src/grid-control/scripts'
alias set_voms='export X509_USER_PROXY=~/k5-ca-proxy.pem'
alias set_x509='export X509_USER_PROXY=~/.globus/x509'
alias set_x509up='export X509_USER_PROXY=~/.globus/x509up'
alias vpi='voms-proxy-init --voms cms:/cms/dcms --valid 192:00'
alias scratch='cd /net/scratch_cms3b/zotz/'
#alias set_singularity='singularity shell /cvmfs/singularity.opensciencegrid.org/bbockelm/cms\:rhel6'
alias gridftp='echo "cd /pnfs/physik.rwth-aachen.de/cms/store/user/azotz"; uberftp grid-ftp'
alias myrsync='rsync -avSzh --progress'
alias meld='export PATH=/usr/bin/:$PATH && meld'

set_singularity(){
	singularity shell /cvmfs/singularity.opensciencegrid.org/bbockelm/cms\:rhel6 -c 'bash'
}

set_analysis(){
	set_cmssw && httsrc && set_x509up
}
set_skimming(){
	set_cmssw && set_x509 && crabsrc && gcsrc
}

set_ssh-agent(){
	eval `ssh-agent -s` && ssh-add
}
#SSH_ENV="$HOME/.ssh/environment"
#
#function start_agent {
#    echo "Initialising new SSH agent..."
#    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
#    echo succeeded
#    chmod 600 "${SSH_ENV}"
#    . "${SSH_ENV}" > /dev/null
#    /usr/bin/ssh-add;
#}
#
# Source SSH settings, if applicable
#
#if [ -f "${SSH_ENV}" ]; then
#    . "${SSH_ENV}" > /dev/null
#    #ps ${SSH_AGENT_PID} doesn't work under cywgin
#    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#        start_agent;
#    }
#else
#    start_agent;
#fi
