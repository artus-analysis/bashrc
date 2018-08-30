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

alias hgrep='history | grep'
alias ltr='ls -ltr'
# https://jef.works/blog/2017/08/13/5-useful-bash-aliases-and-functions/

# alias grep="grep -c `processor /proc/cpuinfo`"

transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX )
    curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
#    cat $tmpfile | pbcopy; # Only for OS X
    cat $tmpfile;

    rm -f $tmpfile;
}


# Git aliases
alias pull='git pull'
alias push='git push'
alias gitpull='git pull'
alias gitfetch='git fetch origin'
