# Variables
CORES=`grep -c ^processor /proc/cpuinfo`

# create .tar.gz 
targzrm() {
	tar -zcvf $1.tar.gz $1;
	rm -r $1;
}
targz() {
        tar -zcvf $1.tar.gz $1;
}
# extra .tar.gz
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
# https://jef.works/blog/2017/08/13/5-useful-bash-aliases-and-functions/

# SSH
transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX )
    curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
#    cat $tmpfile | pbcopy; # Only for OS X
    cat $tmpfile;

    rm -f $tmpfile;
}

# GREP
# https://unix.stackexchange.com/questions/37313/how-do-i-grep-for-multiple-patterns-with-pattern-having-a-pipe-character
grepcc() {
	grep -rn $1 | grep  -e "\.cc" -e "\.h" | grep $1
}
greppy() {
        grep -rn $1 | grep  -e "\.py" | grep $1
}
grepj() {
        grep -rn $1 | grep  -e "\.json" | grep $1
}

# Bash aliases
alias hgrep='history | grep'
alias ltr='ls -ltr'
# alias grep="grep -c `processor /proc/cpuinfo`"

# Git aliases
alias pull='git pull'
alias push='git push'
alias gitpull='git pull'
alias gitfetch='git fetch origin'
alias gdiff='git diff'
alias gitd='git diff'
alias gits='git status'
alias gitl='git log'
alias gitln='git log -n'
alias gitdw='git diff --ignore-all-space'
alias gitdeol='git diff --ignore-space-at-eol'
alias gitdc='git diff --ignore-all-space --ignore-blank-lines'
alias gitdstore='touch "gitd_at_$(date +%F_%R).txt"; git diff >>  "gitd_at_$(date +%F_%R).txt"'
alias gitdcstore='touch "gitdc_at_$(date +%F_%R).txt"; gitdc >>  "gitdc_at_$(date +%F_%R).txt"'

