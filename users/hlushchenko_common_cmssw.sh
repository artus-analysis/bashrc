#!/bin/bash
echo " * --> export hlushchenko_common_cmssw.sh"

# http://qaru.site/questions/6390755/multiple-conditions-in-an-if-statement-in-bash-not-working
os=$(lsb_release -si)
version=$(lsb_release -sr)

scrambshort() {
    touch temp_scramb_std.txt
    scram b -j $CORES &> temp_scramb_std.txt;
    if [ $? -ne 0 ] ; then
        cat temp_scramb_std.txt
    else echo "compiled"
    fi
    rm temp_scramb_std.txt
    tput bel
}

transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX )
    curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
    # cat $tmpfile | pbcopy; # Only for OS X
    cat $tmpfile;
    rm -f $tmpfile;
}

# CMSSW
# alias scramb='scram b -j $CORES; temp_reply=$?; tput bel; return $temp_reply'
scrambb() {
    scram b -j $CORES
    temp_reply=$?
    tput bel
    return $temp_reply
}
alias scramb='scrambb'
alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'
