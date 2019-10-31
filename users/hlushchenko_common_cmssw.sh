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
alias scramblong='scram b -j `grep -c ^processor /proc/cpuinfo`; echo $?'

alias setcrab='setcrab3'


# ARTUS
# -1 for just check
# 0 for no artus merge
check_download_merge() {
  failed=0
  if [[ $# -eq 0 ]] ; then
    redo=0
  else
    redo=$1
  fi
  if test -f ${d}/merg*.log ; then
    i="${d}"
    #echo "   "$i
  fi
  if [ -n "$(ls ${d}/*/output 2> /dev/null)" ]  ; then
    if ! test -f ${d}/merg*.log ; then
      i="${d}"
    fi
    #echo "   "$i
  fi
  if ! test -f ${d}/merg*.log ; then
    echo "   "${d}
  else
    n=$(($(cat ${d}/merg*.log | grep -i 'fail' | wc -l) + $(cat ${d}/merg*.log | grep -i 'err' | wc -l) + $(cat ${d}/merg*.log | grep -i 'command not found' | wc -l) ))
    if [ ! $n -eq "0" ] ; then
      echo "   "${d}/merg*.log "... ERRORED in " $n
      failed=1
      # result=$(cat ${d}/merg*.log | grep -i 'hadd exiting due to error in')
      if [[ $redo -eq -1 ]]
      then
        cat ${d}/merg*.log | grep -i 'hadd exiting due to error in'
      else
        cat ${d}/merg*.log | grep -i 'hadd exiting due to error in' | while read -r result ; do
            echo ${result}
            jobid=${result%_output.root*}  # retain the part before the end
            jobid=${jobid##*_}  # retain the part after the last _
            se_output_download.py --verify-md5 --keep-se-ok --keep-local-ok  --no-mark-dl --ignore-mark-dl --no-mark-fail --keep-se-fail \
              -J id:${jobid} \
              -o ${d}/output ${d}/grid-control_config.conf &> /dev/null
        done
      fi
    else
      n=$(tail -n 1 ${d}/merg*.log | grep 'done' | wc -l)
      if [ ! $n -eq "1" ] ; then
        failed=1
        echo "   "${d}/merg*.log "... ERRORED merge might be interupted";
      else
        echo "   "${d}/merg*.log "... MERGED OK";
      fi
    fi
  fi
  # merge if there were errors and it is allowd
  if [[ $failed -eq 1 && $redo -gt 0 ]]
  then
      ((redo = redo - 1))
      artusMergeOutputs.py -n $CORES  ${d}/ &> ${d}/merge.log
      check_merge $redo
  fi
}
