#!/bin/bash
# til 23 30
# renice -n 19 -u `whoami`

set -e
(
for i in 1 2 3 4 5
do
  pgrep -c -P$$
until [ $(pgrep -c -P$$) -lt 2 ]
      do
       echo "... wait while $(pgrep -c -P$$) < 2"
       sleep 1
      done #2> /dev/null
  ( sleep 5 ) &
done )

while true
do
  N=$CORES
  waiting_time=4
  # double breckets supress printing pid for each process
  (
    until [ $(ps -C flock | wc -l) -lt 2 ] # not 1 - because of ps table header
    do
      ((w=$(ps -C flock | wc -l) * ${waiting_time})) ; echo $w
      echo "wait for flock $(ps -C flock | wc -l) == 0 before starting purging anew ($w sec)"
      sleep ${waiting_time}
    done
    for i in $(glite-ce-job-list --endpoint grid-ce.physik.rwth-aachen.de:8443)
    do
      # ((nn=nn%N)); ((nn++==0)) && echo "... wait for $(pgrep -c -P$$)" && wait  # this is not to kill the machine with all the grepping
      # until [ $(pgrep -c -P$$) -lt $CORES ]
      # until [ $(ps -C glite-ce-job-status | wc -l) -lt $CORES ]
      # do
      #  echo "... wait while $(pgrep -c -P$$) < $CORES"
      #  sleep 1
      # done 2> /dev/null
      until [ $(ps -C flock | wc -l) -lt 101 ]
      do
        echo "wait for flock $(ps -C flock | wc -l) < 100"
        sleep ${waiting_time}
      done
      # double breckets supress printing pid for each process
      ( \
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
        printf "${Yellow}$i${NC}\n $(glite-ce-job-status ${i}  | grep 'Status') \n        ${RED}... skipping${NC}\n"
      ) &
    done
  )
  send "purging finished"
  til 23 30 # sleep till almost the end of the day to purge old jobs (so the past day jobs will stick agound for a day)
  # sleep 172800  # 48h
done
