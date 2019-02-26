echo " * --> export hlushchenko_common.sh"
#-------------------------------------------------------------
# System exports and variables
#-------------------------------------------------------------
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'
export PS1="\[\033[104m\]\h : \w \$\[\033[00m\] "
export LANG=en_US.UTF-8

CORES=`grep -c ^processor /proc/cpuinfo`
export CORES

if [ -z "$BASHRCDIR" ]
then
    BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}s" )/.." && pwd )
fi

[[ ":$PYTHONPATH:" != *"$BASHRCDIR:"* ]] && PYTHONPATH="$BASHRCDIR:${PYTHONPATH}"
export PYTHONPATH


#-------------------------------------------------------------
# Bash Functions
#-------------------------------------------------------------


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
    tar -zcvf $1.tar.gz $1;
    rm -r $1;
}

targz() {
    tar -zcvf $1.tar.gz $1;
}

untargzrm() {
    tar -zxvf $1;
    rm -r $1;
}
untargz() {
    tar -zxvf $1;
}

numfiles() {
    N="$(ls $1 | wc -l)";
    echo "$N files in $1";
}
alias count=numfiles
# https://jef.works/blog/2017/08/13/5-useful-bash-aliases-and-functions/

# SSH
transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX )
    curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
    cat $tmpfile | pbcopy; # Only for OS X
    cat $tmpfile;

    rm -f $tmpfile;
}

changeHistfile()
{
    history -w
    unset HISTFILE
    history -c
    HISTFILE=${DIR_BASHHISTORY}/$1
    touch -a $HISTFILE
    export HISTFILE
    echo "TODO: fix the first-time-use error"
}

# https://unix.stackexchange.com/questions/37313/how-do-i-grep-for-multiple-patterns-with-pattern-having-a-pipe-character
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
        tree -d  -L 1 .
    elif ! [[ $1 =~ $re ]] ; then
        tree -d "${@}"
    else
        tree -d  -L "${@}"
    fi
}


#-------------------------------------------------------------
# Bash aliases
#-------------------------------------------------------------
alias grep='grep -I'
alias hgrep='history | grep'
alias hist='history'
alias ltr='ls -ltr'
alias ltrd='ls -ltrd */'
alias tr='mytree'
# alias grep="grep -c `processor /proc/cpuinfo`"
alias myrsync='rsync -avSzh --progress'
alias myhtop='htop -u $USER'
alias screen='screen2'


#-------------------------------------------------------------
# Git
#-------------------------------------------------------------
alias pull='git pull'
alias push='git push'
alias gitpull='git pull'
alias gitfetch='git fetch origin'
alias gitfo='git fetch origin'
alias gitd='git diff'
alias gitss='git status'
alias gits='git status .'
alias gits.='git status .'
alias gitl='git log'
alias gitln='git log -n'
alias gitdw='git diff --ignore-all-space'
alias gitdeol='git diff --ignore-space-at-eol'
alias gitdc='git diff --ignore-all-space --ignore-blank-lines'
alias gitdstore='touch "gitd_at_$(date +%F_%R).txt"; git diff >>  "gitd_at_$(date +%F_%R).txt"'
alias gitdcstore='touch "gitdc_at_$(date +%F_%R).txt"; gitdc >>  "gitdc_at_$(date +%F_%R).txt"'
alias gitstoreall='gitdstore; gitdcstore'
alias gitds='git diff --cached'

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
