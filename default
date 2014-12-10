#!/bin/bash

BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#general paths
if [ -d /cvmfs/sft.cern.ch ] && [ -d /cvmfs/cms.cern.ch ]; then
    export ROOTSYS=/cvmfs/sft.cern.ch/lcg/app/releases/ROOT/5.34.13/x86_64-slc5-gcc46-opt/root/
    export GCCLIBS=/cvmfs/sft.cern.ch/lcg/external/gcc/4.7.2/x86_64-slc5/lib64/
    export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch/
else
    [ "$TERM" != "dumb" ] && [ ! -z $ISLOGIN ] && echo "cvmfs not available!"
fi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ROOTSYS/lib:$ROOTSYS/lib/root:$GCCLIBS:
export PATH=$PATH:$ROOTSYS/bin
export PYTHONPATH=$PYTHONPATH:$ROOTSYS/lib:$ROOTSYS/lib/root
export X509_USER_PROXY=$HOME/.globus/proxy.grid

# TERMINAL COLORS
export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
function parse_git_branch_and_add_brackets {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}
if [ $HOSTNAME = "ekpcms6" ]; then
    export PS1HOSTCOLOR="1;33"
elif [ $HOSTNAME = "nafhh-cms01" ]; then
    export PS1HOSTCOLOR="1;36"
elif [[ $HOSTNAME == *cms03* ]]; then
    export PS1HOSTCOLOR="1;35"
else
    export PS1HOSTCOLOR="0;32"
fi
export PS1='\[\e[${PS1HOSTCOLOR}m\][$(date +%H:%M)]<\h>\[\e[m\] \[\e[1;34m\]\w\[\e[m\]$(parse_git_branch_and_add_brackets) \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'

# Set terminal title depending on host
if [[ $HOSTNAME == *ekpcms5* ]]; then
        STR="[5]"
elif [[ $HOSTNAME == *ekpcms6* ]]; then
        STR="[6]"
else
        STR=""
fi
export PROMPT_COMMAND='echo -ne "\033]0;${STR}${PWD/$HOME/~}\007"'


[ -f $BASHRCDIR/.git-completion.bash ] && source $BASHRCDIR/.git-completion.bash

alias mensa='curl http://mensa.akk.uni-karlsruhe.de/?DATUM=heute -s | w3m -dump -T text/html| head -n 56 | tail -n 49 | less -p 'Linie''
alias pdgid='curl http://www.physics.ox.ac.uk/CDF/Mphys/old/notes/pythia_codeListing.html -s | w3m -dump -T text/html | head -n 60 | tail -n 55| less'


export GREP_OPTIONS='--color=auto'


# bash rc stuff
[ -f ~/.bashrc_ekp ] && source ~/.bashrc_ekp
[ -f ~/.bashrc_naf ] && source ~/.bashrc_naf
[ -f ~/.bashrc_${USER} ] && source ~/.bashrc_${USER}


myqstat()
{
echo -e "\n   User     Jobs     r   %\n------------------------------------------------------------"; qstat -u "*" -s prs | tail -n+3 | cut -c28-40 | sort | uniq -c | awk ' { t = $1; $1 = $2; $2 = t; print; } ' > /tmp/alljobs.txt && qstat -u "*" -s r | tail -n+3 | cut -c28-40 | sort | uniq -c | awk ' { t = $1; $1 = $2; $2 = t; print; } ' > /tmp/rjobs.txt && awk 'NR==FNR{a[$1]=$2;k[$1];next}{b[$1]=$2;k[$1]}END{for(x in k)printf"%s %d %d\n",x,a[x],b[x]}'  /tmp/alljobs.txt /tmp/rjobs.txt  | sort -k2 -n -r | awk -v len=$((`tput cols`-29)) '!max{max=$2;}{r="";i=s=len*($2-$3)/max;while(i-->0)r=r"\033[1;33m#\033[0m";q="";i=s=len*$3/max;while(i-->0)q=q"\033[0;32m#\033[0m";printf "%10s %5d %5d %3d%s %s%s%s",$1,$2,$3,($3/$2*100),"%",q,r,"\n";}' | grep -E "${USER}|$" 
}




