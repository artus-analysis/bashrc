#!/bin/bash

BASHRCDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#general paths
if [ -d /cvmfs/sft.cern.ch ] && [ -d /cvmfs/cms.cern.ch ]; then
    #export ROOTSYS=/cvmfs/sft.cern.ch/lcg/app/releases/ROOT/5.34.13/x86_64-slc5-gcc46-opt/root/
    export ROOTSYS=/cvmfs/sft.cern.ch/lcg/app/releases/ROOT/5.34.13/x86_64-slc6-gcc48-opt/root/
    export GCCLIBS=/cvmfs/sft.cern.ch/lcg/external/gcc/4.7.2/x86_64-slc5/lib64/
    export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch/
else
    [ "$TERM" != "dumb" ] && [ ! -z $ISLOGIN ] && echo "cvmfs not available!"
fi

export PATH=$BASHRCDIR/scripts:$PATH

#-------------------------------------------------------------
# Terminal colors
#-------------------------------------------------------------
[ -f "$BASHRCDIR/dir_colors" ] && eval `dircolors $BASHRCDIR/dir_colors` || eval `dircolors -b`

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -h --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    alias ls='ls -h'
fi

#-------------------------------------------------------------
# The 'ls/ll' family (use a recent GNU ls).
#-------------------------------------------------------------
alias la='ls -A'           #  Show (a)ll hidden files
alias l='ls -CF'           #  Column output + indicator
alias lx='ls -lXB'         #  Sort by e(x)tension.
alias lk='ls -lSr'         #  Sort by size (biggest last)
alias lt='ls -ltr'         #  Sort by (t)ime (date, most recent last).
alias lc='ls -ltcr'        #  Sort by (c)hange (most recent last)
alias lu='ls -ltur'        #  Sort by (u)sage/access (most recent last).
# ll: directories first, with alphanumeric sorting:
alias ll="ls -lv --group-directories-first"
alias lm='ll |more'        #  Pipe through '(m)ore'
alias lr='ll -R'           #  (R)ecursive ll.
alias lla='ll -A'          #  Show (a)ll hidden files.
alias tree='tree -Csuh'    #  Alternative to 'recursive ls' ...

#-------------------------------------------------------------
# 'cd'
# Each point after .. adds an additional level.
#-------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'

#-------------------------------------------------------------
# Grep
#-------------------------------------------------------------
# The following 3 are defined by default
# alias rgrep='grep -r'    # (r)ecursive grep
# alias fgrep='grep -F'    # (F)ixed string list
# alias egrep='grep -E'    # (E)xtended Regex
alias igrep='grep -i'      # case (i)nsensitive
export GREP_OPTIONS='--color=auto'

#-------------------------------------------------------------
# Convert unix-time to human readable format
#-------------------------------------------------------------
function utime(){
    if [ -n $1 ]; then
        printf '%(%F %T)T\n' "$1"
    fi
}

#-------------------------------------------------------------
# history
#-------------------------------------------------------------
export HISTFILE=$HOME/.bash_history
export HISTFILESIZE=1000000
export HISTSIZE=100000
export HISTCONTROL=ignoreboth
shopt -s histappend
shopt -s checkwinsize
alias h='history'

#-------------------------------------------------------------
# file system usage
#-------------------------------------------------------------
alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'

#-------------------------------------------------------------
# Hostname colors
#-------------------------------------------------------------
if [ $HOSTNAME = "ekpcms6" ]; then
    export PS1HOSTCOLOR="1;33"
elif [[ $HOSTNAME = "ekpcondorcentral" ]]; then
    export PS1HOSTCOLOR="1;31"
elif [ $HOSTNAME = "nafhh-cms01" ]; then
    export PS1HOSTCOLOR="1;36"
else
    export PS1HOSTCOLOR="0;32"
fi

#-------------------------------------------------------------
# Git
#-------------------------------------------------------------
function parse_git_branch_and_add_brackets {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
}
[ -f $BASHRCDIR/git-completion.bash ] && source $BASHRCDIR/git-completion.bash

export PS1='\[\e[${PS1HOSTCOLOR}m\][$(date +%H:%M)] \h:\[\e[m\]\[\e[1;34m\]\w\[\e[m\]$(parse_git_branch_and_add_brackets) \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]\[\033[00m\]'

#-------------------------------------------------------------
# Terminal titles (depending on host)
#-------------------------------------------------------------
if [[ $HOSTNAME == *ekpcms5* ]]; then
        STR="[5]"
elif [[ $HOSTNAME == *ekpcms6* ]]; then
        STR="[6]"
elif [[ $HOSTNAME == *naf* ]]; then
        STR="[NAF]"
elif [[ $HOSTNAME == *ekpsg01* ]]; then
        STR="[SG1]"
elif [[ $HOSTNAME == *lxplus* ]]; then
        STR="[LX]"
else
        STR=""
fi
export PROMPT_COMMAND='echo -ne "\033]0;${STR}${PWD/$HOME/~}\007"'

#-------------------------------------------------------------
# mensa plan and list of PDG-IDs
#-------------------------------------------------------------
alias mensa='curl http://mensa.akk.uni-karlsruhe.de/ -d DATUM=heute -d uni=1 -d schnell=1 -s | w3m -dump -T text/html| head -n 25 | tail -n 18'
alias pdgid='curl https://twiki.cern.ch/twiki/bin/view/Main/PdgId -Bs | w3m -dump -s -no-graph -T text/html | head -n 7 | tail -n 45| less'

#-------------------------------------------------------------
# version of meld which is able to run in a CMSSW environment
#-------------------------------------------------------------
alias mld='PATH=/opt/ogs/bin/linux-x64:/wlcg/sw/git/current/bin:/usr/local/bin:/usr/local/bin/X11:/usr/bin:/bin:/usr/bin/X11:/cern/pro/bin:/usr/kerberos/bin LD_LIBRARY_PATH=/opt/ogs/lib/linux-x64 PYTHONPATH="" meld'

#-------------------------------------------------------------
# Not all tools (*cough* Inkscape *cough*) have good CMYK support
# use gostscript to convert an existing pdf->CMYK
#-------------------------------------------------------------
function cmyk(){
    if [ -f $1 ]; then
        file=$1
        # build output string: replace .pdf with _cmyk.pdf
        outfile="${file: 0:(( ${#file} - 4 ))}_cmyk${file: -4}"

        gs -dSAFER -dBATCH \
        -dNOPAUSE -dNOCACHE -sDEVICE=pdfwrite \
        -sColorConversionStrategy=CMYK \
        -dProcessColorModel=/DeviceCMYK \
        -sOutputFile="$outfile" \
        $1
    fi
}


#-------------------------------------------------------------
# qstat-like script with job summary for all users
#-------------------------------------------------------------
myqstat()
{
echo -e "\n   User     Jobs     r   %\n------------------------------------------------------------"; qstat -u "*" -s prs | tail -n+3 | cut -c28-40 | sort | uniq -c | awk ' { t = $1; $1 = $2; $2 = t; print; } ' > /tmp/alljobs_${USER}.txt && qstat -u "*" -s r | tail -n+3 | cut -c28-40 | sort | uniq -c | awk ' { t = $1; $1 = $2; $2 = t; print; } ' > /tmp/rjobs_${USER}.txt && awk 'NR==FNR{a[$1]=$2;k[$1];next}{b[$1]=$2;k[$1]}END{for(x in k)printf"%s %d %d\n",x,a[x],b[x]}'  /tmp/alljobs_${USER}.txt /tmp/rjobs_${USER}.txt  | sort -k2 -n -r | awk -v len=$((`tput cols`-30)) '!max{max=$2;}{r="";i=s=len*($2-$3)/max;while(i-->0)r=r"\033[1;33m#\033[0m";q="";i=s=len*$3/max;while(i-->0)q=q"\033[0;32m#\033[0m";printf "%11s %5d %5d %3d%s %s%s%s",$1,$2,$3,($3/$2*100),"%",q,r,"\n";}' | grep -E "${USER}|$"
}

listwarnings()
{
  grep -E "(hxx|cc|h|cpp):[0-9]+:[0-9]+: (warning|error):" $1 | sort | uniq -c | \
  sed -E 's/(.*[0-9]+) (.*(h|hxx|cc|cpp)):([0-9]+):[0-9]+: ((warning|error):.*) (\[-W.*\])/\1 +\4 \2 \5 \7/g' | \
  grep -E "warning|error|\[-W.*\]"
}

#-------------------------------------------------------------
# special files for ekp, naf, user
#-------------------------------------------------------------
if [[ $HOSTNAME == *ekpcms* ]]; then
    [ -f $BASHRCDIR/ekp.sh ] && source $BASHRCDIR/ekp.sh
    # check for SLC5/6:
    if [[ `lsb_release -ds` == *6* ]]; then
        ekpini sge
    elif [[ `lsb_release -ds` == *5* ]]; then
        ekpini sgeold
    fi
elif [[ $HOSTNAME == *naf* ]]; then
    [ -f $BASHRCDIR/naf.sh ] && source $BASHRCDIR/naf.sh
fi
[ -f $BASHRCDIR/users/$USER.sh ] && source $BASHRCDIR/users/$USER.sh
