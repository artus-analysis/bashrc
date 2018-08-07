# create .tar.gz 
targz() { tar -zcvf $1.tar.gz $1; rm -r $1; }
# extra .tar.gz
untargz() { tar -zxvf $1; rm -r $1; }

numfiles() { 
    N="$(ls $1 | wc -l)"; 
    echo "$N files in $1";
}

alias hgrep='history | grep'

# https://jef.works/blog/2017/08/13/5-useful-bash-aliases-and-functions/


