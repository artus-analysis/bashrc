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
alias scrambdebug='scram b -j 8 USER_CXXFLAGS="-g"'
alias scramblong='scram b -j `grep -c ^processor /proc/cpuinfo`; echo $?'
alias scrambl='scramblong'
alias scrambs='scrambshort'
alias scramb='scramblong'

alias setcrab='setcrab3'


# ARTUS
# -2 - minimum printout
# -1 for just check
# 0 no artus merge
# 1 artus merge if no merge.log or errors
check_download_merge() {
    failed=0
    d=""
    down=1 # by default - allow re-downloading the failed jobs
    if [[ $# -eq 0 ]] ; then
        echo "no workdir was passed"
        return 1
    elif [[ $# -eq 1 ]] ; then
        d=$1
        redo=0
    elif [[ $# -eq 2 ]] ; then
        d=$1
        redo=$2
    else
        d=$1
        redo=$2
        down=$3
    fi
    #
    # if test -f ${d}/merg*.log ; then
    #     i="${d}"
    #     #echo "   "$i
    # fi
    # if [ -n "$(ls ${d}/*/output 2> /dev/null)" ]  ; then
    #     if ! test -f ${d}/merg*.log ; then
    #       i="${d}"
    #     fi
    #     #echo "   "$i
    # fi
    #
    if ! test -f "${d}/merge.log"
    then
        if [[ $redo -gt 0 ]] ; then
            echo "   "${d}" ... merge.log not found"
            ((redo = redo - 1))
            echo "merging.."
            artusMergeOutputs.py -n $CORES  ${d} &> ${d}/merge.log
            check_download_merge $d $redo $down
            echo "merged.."
        else
            echo "   "${d}" ... merge.log not found but merge not allowed"
            return
        fi
    fi
    if  test -f "${d}/merge.log"
    then
        n=$(($(cat ${d}/merg*.log | grep -i 'fail' | wc -l) + $(cat ${d}/merg*.log | grep -i 'Erro' | wc -l) + $(cat ${d}/merg*.log | grep -i 'err' | wc -l) + $(cat ${d}/merg*.log | grep -i 'command not found' | wc -l) ))
        if [ ! $n -eq "0" ] ; then
            echo 'there were hadd errors in previous merge'
            failed=1
            if [[ $redo -lt -1 ]] ; then
                echo "   "${d}/merg*.log "... ERRORED in " $n
            elif [[ $redo -eq -1 ]] ; then
                cat ${d}/merg*.log | grep -i 'hadd exiting due to error in'
            else
                cat ${d}/merg*.log | grep -i 'hadd exiting due to error in' | while read -r result ; do
                    echo ${result}
                    # echo "Downloading jobid: ${jobid}"
                    jobid=${result%_output.root*}  # retain the part before the end
                    jobid=${jobid##*_}  # retain the part after the last _
                    if [[ $down -gt 0 ]] ; then
                        echo "Downloading jobid: ${jobid}"
                        se_output_download.py \
                            --verify-md5 --keep-se-ok --keep-local-ok  \
                            --no-mark-dl --ignore-mark-dl --no-mark-fail \
                            --keep-se-fail \
                            -J id:${jobid} \
                            -o ${d}/output ${d}/grid-control_config.conf #&> /dev/null
                        echo "...downloaded"
                    fi
                done
                # ((down = down - 1))
            fi
        else
            echo 'there were NO hadd errors in previous merge'
            n=$(tail -n 1 ${d}/merg*.log | grep 'done' | wc -l)
            if [ ! $n -eq "1" ] ; then
                failed=1
                echo "   "${d}/merg*.log "... ERRORED merge might be interupted1";
            else
                l=$( tail -c 5 ${d}/merg*.log )
                if [[ $l = 'done^D' || $l = 'done' ]]
                then
                    echo "   "${d}/merg*.log "... MERGED OK"
                else
                    echo "   "${d}/merg*.log "... ERRORED merge might be interupted2"
                fi
            fi
        fi
        # merge if there were errors and it is allowd
        if [[ $failed -eq 1 && $redo -gt 0 ]] ; then
            echo "merging"
            ((redo = redo - 1))
            rm ${d}/merge.log
            artusMergeOutputs.py -n $CORES  ${d} &> ${d}/merge.log
            echo "merged"
            check_download_merge $d $redo $down
        fi
    fi
}

# Pass as entry merged dir to check all files can be read
check_valid_merge() {
    if [[ $# -eq 0 ]] ; then
        d=$(pwd)
    else
        d=${1}
    fi
    N=$CORES
    (
        setharry
        # d=/pnfs/desy.de/cms/tier2/store/user/ohlushch/MSSM/merged/2017
        for i in ${d}/*
        do
           nick=$(basename $i)
           ((nn=nn%N)); ((nn++==0)) && wait
            get_entries.py ${d}/${nick}/${nick}.root &> /dev/null && echo "${nick} ok" || echo "${nick} <----------------- bad" &
        done
    )
}

# Check number of downloaded outputs is equal to number of finished jobs
check_jobs_number() {
    if [[ $# -eq 0 ]] ; then
        echo "no workdir was passed"
        return 1
    fi
    wd=$1
    echo $wd
    sum=0
    for i in ${wd}/output/*
    do
        s1=$(ls $i | wc -l)
        ((sum = sum + s1))
    done
    echo "SUM:                                                               " $sum
    # echo "SUCCESS:"
    # report.py ${wd}/grid-control_config.conf -J state:SUCCESS
    echo "TOTAL:"
    report.py ${wd}/grid-control_config.conf
}
# echo /net/scratch_cms3b/hlushchenko/artus//MSSM_Legacy_mva_v0/delme/MSSM_2017/data_nominal/f40/analysis_2019-10-18_17-53/
# echo "sum-success:" $( echo "1973 - 1973 " | bc )
# echo "tot-success:" $( echo "1973  - 1973 " | bc )
# echo ""
