#!/bin/bash
THIS_SCRIP_PATH="`dirname \"$0\"`" 
GITHUB_NAME=`git config user.github`
export CONFIGS=$THIS_SCRIP_PATH/$GITHUB_NAME/$USER
echo $CONFIGS
ls $CONFIGS
#[ ! -d ~/.ssh ] && mkdir ~/.ssh
#ln -si $CONFIGS/ssh/config ~/.ssh/

