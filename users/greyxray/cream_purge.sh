#!/bin/bash
# til 23 30 && cream_purge
# renice -n 19 -u `whoami`

set -e

all=0
all=$1

while true
do
  # N=$CORES
  waiting_time=4
  # double breckets supress printing pid for each process
  # (
    until [ $(ps -C flock | wc -l) -lt 2 ] # not 1 - because of ps table header
    do
      ((w=$(ps -C flock | wc -l) * ${waiting_time})) ; echo $w
      echo "wait for flock $(ps -C flock | wc -l) == 0 before starting purging anew ($w sec)"
      sleep ${waiting_time}
    done

    for i in $(glite-ce-job-list --endpoint grid-ce.physik.rwth-aachen.de:8443)
    do
      # echo $i $N
      # ((nn=nn%N))
      # echo $nn
      #  ((nn++==0)) && echo "... wait for $(pgrep -c -P$$)" && wait  # this is not to kill the machine with all the grepping
      # until [ $(pgrep -c -P$$) -lt $CORES ]
      # until [ $(ps -C glite-ce-job-status | wc -l) -le $CORES ]

      until [ $(ps -C glite-ce-job-status | wc -l) -le 30 ]
      do
       echo "... wait while $(pgrep -c -P$$) < $CORES"
       sleep 1
      done #2> /dev/null
      until [ $(ps -C flock | wc -l) -lt 101 ]
      do
        ( echo "wait ${waiting_time}s for flock $(ps -C flock | wc -l) < 100. njobs: $(glite-ce-job-list --endpoint grid-ce.physik.rwth-aachen.de:8443 | wc -l)" & )
        sleep ${waiting_time}
      done
      # double breckets supress printing pid for each process
      # ( glite-ce-job-status ${i} | grep 'connection error' | wc -l ) || ( send "ALLERT: connection error in js $i" ; sleep 3600 )
      until [ $(glite-ce-job-status ${i} | grep 'connection error' | wc -l) -eq 0 ]
      do
        send "ALLERT: connection error detected in js $i"
        sleep 1800
      done
      ( \
        if [[ $all -eq "1" ]] ; then
          if [[ $(glite-ce-job-status ${i}  | grep 'Status        = \[REALLY-RUNNING\]' | wc -l ) == 1 ]] ; then
            flock ~/.purge_lock -c "printf \"${Yellow}$i${NC}\n $(glite-ce-job-status ${i}  | grep 'Status') \n        ${Blue}... cancel REALLY-RUNNING${NC}\n\" ; glite-ce-job-cancel --noint ${i} && sleep ${waiting_time}" &
          fi
          flock ~/.purge_lock -c "printf \"${Yellow}$i${NC}\n $(glite-ce-job-status ${i}  | grep 'Status') \n        ${Blue}... purge ALL ${NC}\n\" ; glite-ce-job-purge --noint ${i} && sleep ${waiting_time}" &
          continue
        fi
        if [[ $(glite-ce-job-status -L 2 ${i}  | grep -e "Status         = \[DONE-OK\] - \[$(date '+%a %d %b %Y')"   | wc -l ) > 0 ]] ; then
          printf "${Yellow}$i${NC}\n $(glite-ce-job-status ${i}  | grep 'Status') \n        ${RED}... skipping (today)${NC}\n"
          continue
        fi
        if [[ $(glite-ce-job-status ${i}  | grep 'Status        = \[DONE-OK\]' | wc -l ) == 1 ]] ; then
          flock ~/.purge_lock -c "printf \"${Yellow}$i${NC}\n $(glite-ce-job-status ${i}  | grep 'Status') \n        ${Blue}... purge DONE-OK${NC}\n\" ; glite-ce-job-purge --noint ${i} && sleep ${waiting_time}" &
          continue
        fi
        if [[ $(glite-ce-job-status ${i}  | grep 'Status        = \[DONE-FAILED\]' | wc -l ) == 1 ]] ; then
          flock ~/.purge_lock -c "printf \"${Yellow}$i${NC}\n $(glite-ce-job-status ${i}  | grep 'Status') \n        ${Blue}... purge DONE-FAILED${NC}\n\" ; glite-ce-job-purge --noint ${i} && sleep ${waiting_time}" &
          continue
        fi
        if [[ $(glite-ce-job-status ${i}  | grep 'Status        = \[CANCELLED\]' | wc -l ) == 1 ]] ; then
          flock ~/.purge_lock -c "printf \"${Yellow}$i${NC}\n $(glite-ce-job-status ${i}  | grep 'Status') \n        ${Blue}... purge CANCELLED${NC}\n\" ; glite-ce-job-purge --noint ${i} && sleep ${waiting_time}" &
          continue
        fi
        if [[ $(glite-ce-job-status ${i}  | grep 'Status        = \[ABORTED\]' | wc -l ) == 1 ]] ; then
          flock ~/.purge_lock -c "printf \"${Yellow}$i${NC}\n $(glite-ce-job-status ${i}  | grep 'Status') \n        ${Blue}... purge ABORTED${NC}\n\" ; glite-ce-job-purge --noint ${i} && sleep ${waiting_time}" &
          continue
        fi
        # if [[ $(glite-ce-job-status ${i}  | grep 'Status        = \[IDLE\]' | wc -l ) == 1 ]] ; then
        #   flock ~/.purge_lock -c "printf \"${Yellow}$i${NC}\n $(glite-ce-job-status ${i}  | grep 'Status') \n        ${Blue}... purge IDLE${NC}\n\" ; glite-ce-job-purge --noint ${i} && sleep ${waiting_time}" &
        #   continue
        # fi
        printf "${Yellow}$i${NC}\n $(glite-ce-job-status ${i}  | grep 'Status') \n        ${RED}... skipping${NC}\n"
      ) &
    done
  # )
  send "purging finished"
  if [[ $all -eq "1" ]] ; then
    echo "single round of purging finished"
    break
  else
    echo "sleep till 23:30" && til 23 30 # sleep till almost the end of the day to purge old jobs (so the past day jobs will stick agound for a day)
  fi

  # sleep 172800  # 48h
done


