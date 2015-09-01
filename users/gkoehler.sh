#!/bin/bash
#personal bashrc for gkoehler

[ -f ~berger/sw/ekpini.sh ] && . ~berger/sw/ekpini.sh batch
source /opt/ogs_sl6/ekpclusterSL6/common/settings.sh

VLESS=$(find /usr/share/vim -name 'less.sh')
if [ ! -z $VLESS ]; then
  alias less=$VLESS
fi



setgitcolors() {
        git config color.branch auto
        git config color.diff auto
        git config color.interactive auto
        git config color.status auto
}


set_analysis(){
    cd /home/gkoehler/CMSSW/Analysis/CMSSW_7_1_5/src
    cmssw_slc6_gcc481
    source $CMSSW_BASE/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
    export PATH=/home/gkoehler/GridControl/grid-control-1501/:$PATH
   }

