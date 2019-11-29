#!/bin/bash

# source ${DIR_PRIVATESETTINGS}/env_scripts/git-prompt.sh
# Path contains only pathes to the scripts
setprivatesettings(){
    declare -a modules=(
        $DIR_BASH/scripts
        $DIR_PRIVATESETTINGS/gc
        $DIR_PRIVATESETTINGS/btagging
        $DIR_PRIVATESETTINGS/playground
        $DIR_PRIVATESETTINGS/artus
        # $DIR_PRIVATESETTINGS/fes
        $DIR_PRIVATESETTINGS/plotting_scripts
        # $DIR_PRIVATESETTINGS/root_scripts
        $DIR_PRIVATESETTINGS/python_scripts
    )

    for i in "${modules[@]}"
    do
        if [ -d "$i" ]
        then
            chmod +x $i/*
            [[ ":$PATH:" != *"$i:"* ]] && PATH="$i:${PATH}"
        else
            echo "Couldn't find package: " $i
        fi
    done
    export PATH
}
setprivatesettings
