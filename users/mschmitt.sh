export EDITOR=/usr/bin/nano

#!/bin/bash
#personal bashrc for mschmitt

[ -f ~berger/sw/ekpini.sh ] && . ~berger/sw/ekpini.sh batch

alias setroot=". $ROOTSYS/bin/thisroot.sh"

export DATE=`date +%Y_%m_%d`


case "$HOSTNAME" in
        "ekpcms"*)
        export ANA=/home/mschmitt/analysis
            ;;
	"ekpsg0"*)
	export ANA=/home/mschmitt/
	    ;;
        "nafhh"*)
        export ANA=/nfs/dust/cms/user/mschmitt/analysis
	export X509_USER_PROXY=/nfs/dust/cms/user/mschmitt/x509up
	echo $X509_USER_PROXY
            ;;
        "lxplus"*)
            ;;
esac

ana_76(){
  cd $ANA/CMSSW_7_1_5/ && . ./.bash-setup
}

ana_80(){
  cd $ANA/CMSSW_8_0_4/ && . ./.bash-setup
}

tmvaGui(){
(cd $ANA/TMVA-v4.2.0/test/ && root -x TMVAGui.C)
  }

tmvaLink(){
  rm -f $ANA/TMVA-v4.2.0/test/TMVA.root && ln -s $PWD/$1 $ANA/TMVA-v4.2.0/test/TMVA.root
  }

tmvaPlot()
{
rm -f $ANA/TMVA-v4.2.0/test/TMVA.root
ln -s $PWD/$1 $ANA/TMVA-v4.2.0/test/TMVA.root
cd $ANA/TMVA-v4.2.0/test/
root -x plotall.C
cd -
}
#alias voms='voms-proxy-init -voms cms:/cms/dcms -valid 190:00'
#alias voms-dest='voms-proxy-destroy -file ~/.globus/x509up'
init_voms()
{
#export X509_USER_PROXY=/nfs/dust/cms/user/mschmitt/x509up
voms-proxy-init -voms cms:/cms/dcms -valid 192:00 -verify -debug
}
info_voms()
{
voms-proxy-info
}
