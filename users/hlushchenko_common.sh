
echo " * --> export hlushchenko_common.sh"
source ~/.ssh/app-env
#-------------------------------------------------------------
# System exports and variables
#-------------------------------------------------------------
export red=$'\e[1;31m'
export grn=$'\e[1;32m'
export yel=$'\e[1;33m'
export blu=$'\e[1;34m'
export mag=$'\e[1;35m'
export cyn=$'\e[1;36m'
export end=$'\e[0m'
export RED='\033[0;31m'
export ORANGE='\033[0;33m'
export Black='\033[0;30m'
export Dark_Gray='\033[1;30m'
export Light_Red='\033[1;31m'
export Green='\033[0;32m'
export Light_Green='\033[1;32m'
export Yellow='\033[1;33m'
export Blue='\033[0;34m'
export Light_Blue='\033[1;34m'
export Purple='\033[0;35m'
export Light_Purple='\033[1;35m'
export Cyan='\033[0;36m'
export Light_Cyan='\033[1;36m'
export Light_Gray='\033[0;37m'
export White='\033[1;37m'
export NC='\033[0m' # No Color
export PS1="\[\033[104m\]\h : \w \$\[\033[00m\] "
export LANG=en_US.UTF-8

CORES=`grep -c ^processor /proc/cpuinfo`
export CORES


# TODO: expand on OSX
# https://stackoverflow.com/questions/16989598/bash-comparing-version-numbers
function version_gteq() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" -o "$2" == "$1" ; }
function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" ; }

# if version_gt $first_version $second_version; then ...
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    export OSNAME=$NAME
    export OSVER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    export OSNAME=$(lsb_release -si)
    export OSVER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    export OSNAME=$DISTRIB_ID
    export OSVER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    export OSNAME=Debian
    export OSVER=$(cat /etc/debian_version)
# elif [ -f /etc/SuSe-release ]; then
#     # Older SuSE/etc.
#     ...
# elif [ -f /etc/redhat-release ]; then
#     # Older Red Hat, CentOS, etc.
#     ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    export OSNAME=$(uname -s)
    export OSVER=$(uname -r)
fi
# function tt()
# {
#     echo $1 $2
#     if test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1" ; then
#         echo 1:1
#     else
#         echo 1:0
#     fi
#     if test "$2" == "$1" ; then
#         echo 2:1
#     else
#         echo 2:0
#     fi
# }
# if tt $OSVER '7' ; then echo 1; else echo 0; fi

if [ -z "$BASHRCDIR" ]
then
    BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

[[ ":$PYTHONPATH:" != *"$BASHRCDIR:"* ]] && PYTHONPATH="$BASHRCDIR:${PYTHONPATH}"
export PYTHONPATH


#-------------------------------------------------------------
# Screen Functions
#-------------------------------------------------------------

alias screen=' screen2 '
alias sR='screen -R'
srm() {
    screen -XS $1 quit
}
screen2() {
    # To save the real arguments
    arguments=""
    command='screen'
    # Check for "-a"
    for arg in $*
    do
        case $arg in
        -l)
            # TODO: Call your "foo" script"
            screen -list
            return
            ;;
        *)
            arguments="$arguments $arg"
            ;;
        esac
    done
    # Now call the actual command
    $command $arguments
}
# alias s='screen'
screensub() {
    tfile=$(mktemp /tmp/XXXXXXXXX)
    if  [[ $# -eq 1 ]] ; then
        echo "cahnging file to $1"
        tfile=$1
        touch $tfile
    fi
    vim -c 'startinsert' $tfile
    echo "launching screenrc: $tfile"
    screen -S $(basename $tfile) -c $tfile
}
# ssubd(){
#     tfile=$(mktemp /tmp/XXXXXXXXX)
#     if  [[ $# -eq 1 ]] ; then
#         echo "cahnging file to $1"
#         tfile=$1
#         touch $tfile
#     fi
#     vim -c 'startinsert' $tfile
#     echo "launching screenrc: $tfile"
#     screen -d -S $(basename $tfile) -c $tfile
# }
ssubr() {
    if [ $# -eq 1 ] && [ -f "$1" ] ; then
      rm $1
    fi
    screensub $@
}
# ssubrd() {
#     if [ $# -eq 1 ] && [ -f "$1"] ; then
#       rm $1
#     fi
#     ssubd $@
# }
alias ssub='screensub'
sq() {
    screen -XS $1 quit
}
alias screenkill='sq'
alias sr='screen -rd'
alias sl='screen -l'

#-------------------------------------------------------------
# Bash Functions
#-------------------------------------------------------------
# filelist - recursive
# find -type f /pnfs/desy.de/cms/tier2/store/user/jbechtel/higgs-kit/skimming/gc_DYAutumn18/GC_SKIM/190521_111141/DYJetsToLLM50_RunIIAutumn18MiniAOD_102X_13TeV_MINIAOD_madgraph-pythia8_v1/

# Find & Replace
# find /path/to/files -type f -exec sed -i 's/oldstring/new string/g' {} \;
# grep -rl 'windows' ./ | xargs sed -i 's/windows/linux/g'

# Find & Replace
# find . -type f -exec sed -i 's/deepcp/deepcopy/g' {} \;
# grep -rl 'deepcp' ./ | xargs sed -i 's/deepcp/deepcopy/g'


# time(/afs/desy.de/user/g/glusheno/RWTH/MVAtraining/CMSSW_10_4_0_pre3/bin/slc6_amd64_gcc700/trainTauIdMVA /nfs/dust/cms/user/glusheno/TauIDMVATraining2018/Autum2018tauId_v1/tauId_dR05_old_v1/train_test.py &> delme)
# mytime() {
#     START=$(date +%s.%N)
#     # /afs/desy.de/user/g/glusheno/RWTH/MVAtraining/CMSSW_10_4_0_pre3/bin/slc6_amd64_gcc700/trainTauIdMVA /nfs/dust/cms/user/glusheno/TauIDMVATraining2018/Autum2018tauId_v1/tauId_dR05_old_v1/train_test.py &> delme
#     END=$(date +%s.%N)
#     DIFF=$(echo "$END - $START" | bc)
#     echo $DIFF
# }

savelog() {  # TODO: make it function with & in a separate pipe
    logfile="savelog.log"
    command=""

    if [[ $# -eq 0 ]] ; then
        echo "Nothing to log"
        return

    elif [[ $# -eq 1 ]] ; then
        command=$1

    elif [[  $# -eq 2 ]] ; then
        logfile="savelog_$(date +%F_%R).log"

        if [[ "$1" == "-r" ]]; then
            command=$2
        elif [[ "$2" == "-r" ]]; then
            command=$1
        else
            echo "Wrong parameters when -r option expected"
            return
        fi

    elif [[ $# -eq 3 ]] ; then

        override=false
        if [[ "$1" == "-N" ]] || [[ "$2" == "-N" ]] ; then
            override=true
        fi

        if [[ $1 == "-n" ]] || [[ $1 == "-N" ]]; then
            logfile=$2
            command=$3
        elif [[ $2 == "-n" ]] || [[ $2 == "-N" ]]; then
            logfile=$3
            command=$1
        else
            echo "Wrong parameters when -n/-N expects to get the log filename"
            return
        fi

        if [[ -f $logfile ]] && [[ "$override" = false ]] ; then
            echo "Will not override existing log"
            return
        fi

    elif [[ $# -gt 3 ]] ; then
        echo "Wrong number of parameters"
        return
    fi

    echo "command:" $command
    echo "logfile:" $logfile
    $command &> $logfile
}


com(){
    tfile=$(mktemp /tmp/foo.XXXXXXXXX)
    mv $tfile $tfile.sh
    touch $tfile.OUT
    vim -c 'startinsert' $tfile.sh

    # add '#!\/usr\/bin\/env bash' to the header of file
    if [ "$(uname)" == "Darwin" ]; then
        # Do something under Mac OS X platform
        # http://abhi.sanoujam.com/posts/sed-newline-mac/
        # sed -i '' '1s/^/#!\/bin\/bash\'$'\n/' $tfile.sh
        sed -i '' '1s/^/#!\/usr\/bin\/env bash\'$'\n/' $tfile.sh
        sed -i '' '2s/^/FAIL=0'$'\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Do something under GNU/Linux platform
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        # Do something under 32 bits Windows NT platform
        echo 'not for 32 bits Windows NT platform'
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
        # Do something under 64 bits Windows NT platform
        echo 'not for 32 bits Windows NT platform'
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    fi

    cat ${DIR_BASH}/users/greyxray/templ_wait.sh >> $tfile.sh

    chmod +x $tfile.sh
    ( source $tfile.sh &> $tfile.OUT; send "com $tfile.sh finished with status "$?". Output stream: $tfile.OUT . hostname:"$( hostname )) &
    echo "executing file: " $tfile.sh
}

comcat(){
    tfile=$(mktemp /tmp/foo.XXXXXXXXX)
    mv $tfile $tfile.sh
    touch $tfile.OUT
    vim -c 'startinsert' $tfile.sh

    # add '#!\/usr\/bin\/env bash' to the header of file
    if [ "$(uname)" == "Darwin" ]; then
        # Do something under Mac OS X platform
        # http://abhi.sanoujam.com/posts/sed-newline-mac/
        # sed -i '' '1s/^/#!\/bin\/bash\'$'\n/' $tfile.sh
        sed -i '' '1s/^/#!\/usr\/bin\/env bash\'$'\n/' $tfile.sh
        sed -i '' '2s/^/FAIL=0'$'\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Do something under GNU/Linux platform
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        # Do something under 32 bits Windows NT platform
        echo 'not for 32 bits Windows NT platform'
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
        # Do something under 64 bits Windows NT platform
        echo 'not for 32 bits Windows NT platform'
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    fi

    cat ${DIR_BASH}/users/greyxray/templ_wait.sh >> $tfile.sh

    chmod +x $tfile.sh
    ( source $tfile.sh &> $tfile.OUT; send "com $tfile.sh finished with status "$?". Output stream: $tfile.OUT . hostname:"$( hostname ) ; cat $tfile.OUT) &
    echo "executing file: " $tfile.sh
}

docat() {
    tfile=$(mktemp /tmp/foo.XXXXXXXXX)
    mv $tfile $tfile.sh
    touch $tfile.OUT
    vim -c 'startinsert' $tfile.sh

    # add '#!\/usr\/bin\/env bash' to the header of file
    if [ "$(uname)" == "Darwin" ]; then
        # Do something under Mac OS X platform
        # http://abhi.sanoujam.com/posts/sed-newline-mac/
        # sed -i '' '1s/^/#!\/bin\/bash\'$'\n/' $tfile.sh
        sed -i '' '1s/^/#!\/usr\/bin\/env bash\'$'\n/' $tfile.sh
        sed -i '' '2s/^/FAIL=0'$'\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Do something under GNU/Linux platform
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        # Do something under 32 bits Windows NT platform
        echo 'not for 32 bits Windows NT platform'
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
        # Do something under 64 bits Windows NT platform
        echo 'not for 32 bits Windows NT platform'
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    fi

    cat ${DIR_BASH}/users/greyxray/templ_wait.sh >> $tfile.sh

    chmod +x $tfile.sh
    ( source $tfile.sh &> $tfile.OUT; cat $tfile.OUT) &
    echo "executing file: " $tfile.sh
}
alias nocom='docat'

doprint() {
    tfile=$(mktemp /tmp/foo.XXXXXXXXX)
    mv $tfile $tfile.sh
    touch $tfile.OUT
    vim -c 'startinsert' $tfile.sh

    # add '#!\/usr\/bin\/env bash' to the header of file
    if [ "$(uname)" == "Darwin" ]; then
        # Do something under Mac OS X platform
        # http://abhi.sanoujam.com/posts/sed-newline-mac/
        # sed -i '' '1s/^/#!\/bin\/bash\'$'\n/' $tfile.sh
        sed -i '' '1s/^/#!\/usr\/bin\/env bash\'$'\n/' $tfile.sh
        sed -i '' '2s/^/FAIL=0'$'\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Do something under GNU/Linux platform
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        # Do something under 32 bits Windows NT platform
        echo 'not for 32 bits Windows NT platform'
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
        # Do something under 64 bits Windows NT platform
        echo 'not for 32 bits Windows NT platform'
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\n/' $tfile.sh
    fi

    cat ${DIR_BASH}/users/greyxray/templ_wait.sh >> $tfile.sh

    chmod +x $tfile.sh
    ( source $tfile.sh ) &
    echo "executing file: " $tfile.sh
}


open_sem(){
    mkfifo pipe-$$
    exec 3<>pipe-$$
    rm pipe-$$
    local i=$1
    for((;i>0;i--)); do
        printf %s 000 >&3
    done
}
run_with_lock(){
    local x
    read -u 3 -n 3 x && ((0==x)) || exit $x
    (
     ( "$@"; )
    printf '%.3d' $? >&3
    )&
}
doparralel() {
    tfile=$(mktemp /tmp/foo.XXXXXXXXX)
    mv $tfile $tfile.sh
    touch $tfile.OUT
    vim -c 'startinsert' $tfile.sh

    # add '#!\/usr\/bin\/env bash' to the header of file
    if [ "$(uname)" == "Darwin" ]; then
        # Do something under Mac OS X platform
        # http://abhi.sanoujam.com/posts/sed-newline-mac/
        # sed -i '' '1s/^/#!\/bin\/bash\'$'\n/' $tfile.sh
        sed -i '' '1s/^/#!\/usr\/bin\/env bash\'$'\n/' $tfile.sh
        sed -i '' '2s/^/FAIL=0'$'\n/' $tfile.sh
        sed -i '' '3s/^/open_sem \$CORES'$'\n/' $tfile.sh
        sed -i '' '4s/^/trap '$'\'run_with_lock'$'\' DEBUG'$'\n/' $tfile.sh

    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Do something under GNU/Linux platform
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\nopen_sem \$CORES\ntrap '$'\'run_with_lock'$'\' DEBUG\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
        # Do something under 32 bits Windows NT platform
        echo 'not for 32 bits Windows NT platform'
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\nopen_sem \$CORES\ntrap '$'\'run_with_lock'$'\' DEBUG\n/' $tfile.sh
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
        # Do something under 64 bits Windows NT platform
        echo 'not for 32 bits Windows NT platform'
        sed -i  '1s/^/#!\/bin\/bash\nFAIL=0\nopen_sem \$CORES\ntrap '$'\'run_with_lock'$'\' DEBUG\n/' $tfile.sh
    fi

    cat ${DIR_BASH}/users/greyxray/templ_wait.sh >> $tfile.sh

    chmod +x $tfile.sh
    cat $tfile.sh
    (. $tfile.sh) &
    # open_sem $CORES
    # for thing in {a..g}; do
    #     run_with_lock $tfile.sh
    # done
    # trap run_with_lock DEBUG
    # 'echo -e "\e]0;$BASH_COMMAND\007"'
    echo "executing file: " $tfile.sh
}

# echo 30
# sleep 30
# echo 28
# sleep 28
# echo 26
# sleep 26
# echo 24
# sleep 24
# echo 23
# sleep 23
# echo 15
# sleep 15
# echo 13
# sleep 13

alias sR='screen -R'
srm() {
    screen -XS $1 quit
}
screen2() {
    # To save the real arguments
    arguments=""
    command='screen'
    # Check for "-a"
    for arg in $*
    do
        case $arg in
        -l)
            # TODO: Call your "foo" script"
            screen -list
            return
            ;;
        *)
            arguments="$arguments $arg"
            ;;
        esac
    done
    # Now call the actual command
    $command $arguments
}


targzrm() {
    tar -zcvf $1.tar.gz $1 && rm -r $1;
}

targz() {
    tar -zcvf $1.tar.gz $1;
}

untargzrm() {
    tar -zxvf $1 && rm -r $1;
}
untargz() {
    tar -zxvf $1;
}
untarxzrm() {
    tar -xvf $1 && rm -r $1;
}
untarxz() {
    tar -xvf $1
}

# count
numfiles() {
    N="$(ls $1 | wc -l)";
    echo "$N files in $1";
}
count() {
    wc -l $a
}
# https://jef.works/blog/2017/08/13/5-useful-bash-aliases-and-functions/

# SSH

send() {
    message="Done"
    echo $#
    if [[ $# -eq 1 ]] ; then
        message="$1"
    elif ! [[ $# -eq 0 ]] ; then
        echo "Unknown extra parametes ignored"
    fi
    curl -s \
        -X POST \
        https://api.telegram.org/bot$apiToken/sendMessage \
        -d text="$message" \
        -d chat_id=$chatId
}
# send $'my message\n ok\n'
# curl -X POST -d text=$'my message\n ok\n' -d chat_id=$chatId https://api.telegram.org/bot$apiToken/sendMessage

sendstdin() {
    local input
    while IFS= read line; do
        input="${input}"$'\n'"${line}"
    done

    local message="$input"
    [ -z "$message" ] && message="Done"

    curl -s \
        -X POST \
        "https://api.telegram.org/bot${apiToken}/sendMessage" \
        -d text="${message}" \
        -d chat_id="${chatId}"
}
# sendjq='(LCG_GFAL_INFOSYS=egee-bdii.cnaf.infn.it:2170 lcg-infosites --vo cms ce -f rwth-aachen | while send x ; do sleep 600 ; done ) &'
#alias sendjq='( while true ; do LCG_GFAL_INFOSYS=egee-bdii.cnaf.infn.it:2170 lcg-infosites --vo cms ce -f rwth-aachen | sendstdin ; sleep 60 ; done ) & '
alias sendjq='( apiToken=$apiRWTHgridToken; chatId=$chatIdRWTHgrid ; while true ; do LCG_GFAL_INFOSYS=egee-bdii.cnaf.infn.it:2170 lcg-infosites --vo cms ce -f rwth-aachen | sendstdin ; sleep 60 ; done ) & '

transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX )
    curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
    cat $tmpfile | pbcopy; # Only for OS X
    cat $tmpfile;

    rm -f $tmpfile;
    echo
}

changeHistfile()
{
    filename=${DIR_BASHHISTORY}/$1
    if [ ! -f $filename ]; then
        echo 'The history file wasnt present and will be recreated'
        touch $filename
    fi
    history -w
    unset HISTFILE
    history -c
    HISTFILE=$filename
    # touch -a $HISTFILE
    export HISTFILE
    echo "TODO: fix the first-time-use error!"
}

# https://unix.stackexchange.com/questions/37313/how-do-i-grep-for-multiple-patterns-with-pattern-having-a-pipe-character
# alias grep='grep -rI'
alias gr="grep -rn "
grepcc() {
    grep -rnI $1 | grep  -e "\.cc" -e "\.h" | grep $1
}
greppy() {
    grep -rnI $1 | grep  -e "\.py" | grep $1
}
grepj() {
    grep -rnI $1 | grep  -e "\.json" | grep $1
}

dus() {
    if [[ $# -eq 0 ]] ; then
        echo 'no argument given'
        du -sh * | sort -hr
        return
    fi

    du -sh $1/* | sort -hr
}

function countdown(){
   date1=$((`date +%s` + $1));
   while [ "$date1" -ge `date +%s` ]; do
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
}
function stopwatch(){
  date1=`date +%s`;
   while true; do
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
    sleep 0.1
   done
}

mytree(){
    re='^[0-9]+$'
    if [[ $# -eq 0 ]] ; then
        tree  -L 1 .
    elif ! [[ $1 =~ $re ]] ; then
        tree "${@}"
    else
        tree  -L "${@}"
    fi
}

mydtree(){
    re='^[0-9]+$'
    if [[ $# -eq 0 ]] ; then
        tree -d  -L 1 .
    elif ! [[ $1 =~ $re ]] ; then
        tree -d "${@}"
    else
        tree -d  -L "${@}"
    fi
}

monitore_pid(){
    (while ps -p "${@}" &> /dev/null ; do sleep 5; done ; send "${@} is done") &
}

#-------------------------------------------------------------
# Bash aliases
#-------------------------------------------------------------
alias reniceme='renice -n 19 -u `whoami`'
alias hgrep=' history | grep '
alias hist=' history '
alias ltr=' ls -ltr '
alias ltrd=' ls -ltrd */ '
alias tr=' mytree '
alias trd=' mydtree '
# alias grep="grep -c `processor /proc/cpuinfo`"
alias myrsync='rsync -avSzh --progress '
alias myhtop=' htop -u $USER '

alias ps=' ps -o pid,pcpu,pri,args '
alias pscmn=' ps -f | cat'
alias psall=' ps -U $(whoami)'
alias psAll=' pscmn'
alias psALL=' ps  -f --user ohlushch | cat'



#-------------------------------------------------------------
# Git
#-------------------------------------------------------------
# https://www.atlassian.com/git/tutorials/git-log
alias pull='git pull'
alias push='git push'
alias gitpull='git pull'
alias gitfetch='git fetch origin'
alias gitfo='git fetch origin'
alias gitd='git diff'
# alias gitss='git status .'
alias gits='git status'
alias gitsh='gitswno'
alias gitshf='gitswno $@ ; git show $@ '
alias gitSh='gitswno $@ ; git show $@ '
alias gitl='gitls'
alias gitls='git log --format="%ar: %C(auto,red)(%s) %C(auto,green)[%aN] %C(auto,blue) %H"'
alias gitln='gitl -n'
alias gitL='git log'
alias gitLn='git log -n'
alias gitdw='git diff --ignore-all-space'
alias gitdeol='git diff --ignore-space-at-eol'
alias gitdc='git diff --ignore-all-space --ignore-blank-lines'
alias gitdstore='touch "gitd_at_$(date +%F_%R).txt"; git diff >>  "gitd_at_$(date +%F_%R).txt"'
alias gitdcstore='touch "gitdc_at_$(date +%F_%R).txt"; gitdc >>  "gitdc_at_$(date +%F_%R).txt"'
alias gitstoreall='gitdstore; gitdcstore'
alias gitds='git diff --cached'
alias gitcp='git cherry-pick -x --signoff' # To include A just type git cherry-pick A^..B
alias gitss='git stash save'
alias gitdisc='git checkout --'
# alias gitcm='git commit -m'

gitcm() {
    git commit -m $1
    gits
}

# https://stackoverflow.com/questions/424071/how-to-list-all-the-files-in-a-commit
gitswno(){
    echo "Patched files:"
    for i in $(git show --name-only --format="" $@ )
    do
        echo -e "\e[36m $i \e[0m"
    done
    echo
}

gitlt(){
    # sort by time
    git ls-tree -r --name-only HEAD  $@ | while read filename; do
        printf "\033[0;32m$(git log -1 --format='[%ar]: ' -- $filename)"
        printf "\033[0;34m$(git log -1 --format='%s ' -- $filename)"
        printf "\033[0;31m$(git log -1 --format='%aN ' -- $filename)"
        printf "\033[0m$filename\n"
    done
}

gitignore(){
    # https://medium.com/@igloude/git-skip-worktree-and-how-i-used-to-hate-config-files-e84a44a8c859
    if [[ $# -eq 0 ]] ; then
        echo "Give explicit dir to ignore"
        #gitignore_path=`pwd`
        return
    fi
    for gitignorepath in "$@" ; do
        for x in `git ls-files $gitignorepath`  ; do
            git update-index --skip-worktree $x
        done
    done
}

gitadd() {
    git diff -U0  --ignore-all-space --ignore-blank-lines --no-color $1 | git apply --cached --ignore-whitespace --unidiff-zero -
}
# Git config aliases
git config --global alias.addnw "\!sh -c 'git diff -U0 -w --no-color \"$@\" | git apply --cached --ignore-whitespace --unidiff-zero -'"

gitmkdcpatch() {
    touch "patch_$(date +%F_%H-%M-%S)"
    git diff -U0  --ignore-all-space --ignore-blank-lines --no-color $1 >> "patch_$(date +%F_%H-%M-%S)"
}

# Style : requires available source ${DIR_BASH}/git-prompt.sh
# PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
export PROMPT_COMMAND='__git_ps1 "[\[\$(date +%D\ %H:%M)\]]\n\[\033[104m\]\h : \w \[\033[00m\]" " \[\033[104m\]\\\$\[\033[00m\] "'
# read: http://qaru.site/questions/763543/how-to-show-git-status-info-on-the-right-side-of-the-terminal
# Select git info displayed, see /usr/lib/git-core/git-sh-prompt for more
export GIT_PS1_SHOWCOLORHINTS=1           # Make pretty colours inside $PS1
export GIT_PS1_SHOWDIRTYSTATE=1           # '*'=unstaged, '+'=staged
export GIT_PS1_SHOWSTASHSTATE=1           # '$'=stashed
export GIT_PS1_SHOWUNTRACKEDFILES=1       # '%'=untracked
export GIT_PS1_SHOWUPSTREAM="verbose"     # 'u='=no difference, 'u+1'=ahead by 1 commit
# export GIT_PS1_STATESEPARATOR=' '          # No space between branch and index status
export GIT_PS1_DESCRIBE_STYLE="describe"  # Detached HEAD style:
#  describe      relative to older annotated tag (v1.6.3.1-13-gdd42c2f)
#  contains      relative to newer annotated tag (v1.6.3.2~35)
#  branch        relative to newer tag or branch (master~4)
#  default       exactly eatching tag


setgitcolors()
{
    git config color.branch auto
    git config color.diff auto
    git config color.interactive auto
    git config color.status auto
    git config color.ui auto
}

