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
        "nafhh"*)
        export ANA=/nfs/dust/cms/user/mschmitt/analysis
            ;;
        "lxplus"*)
            ;;
esac


ana_cmssw_715(){
  cd $ANA/CMSSW_7_1_5/ && . ./.bash-setup && cd ./src/
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
