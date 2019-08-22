#!/bin/bash
echo " * --> export hlushchenko_common_cmssw.sh"
shopt -s direxpand
# http://qaru.site/questions/6390755/multiple-conditions-in-an-if-statement-in-bash-not-working
os=$(lsb_release -si)
version=$(lsb_release -sr)

scrambshort() {
    tfile=$(mktemp /tmp/scrambshort.XXXXXXXXX)

    scram b -j $CORES &> $tfile
    if [ $? -ne 0 ] ; then  cat $tfile
    else echo "compiled"
    fi

    # Delete the temp file
    rm -f "$tfile"
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
scrambb() {
    scram b -j $CORES
    temp_reply=$?
    tput bel
    return $temp_reply
}

# alias scramb='scram b -j $CORES; temp_reply=$?; tput bel; return $temp_reply'
alias scramb='scrambshort'
alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'
