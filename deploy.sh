#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOT_FILE=dfiles.tar.gz
EXTRACT_CMD="cd ~ ; [ -d .zsh ] && rm -rf .zsh ; tar xvzf $DOT_FILE -C . ; rm $DOT_FILE"

echo [+] Fetch ZSH and VIM plugins
git submodule init
git submodule update

echo [+] Prepare zipfile $BASEDIR/$DOT_FILE
if [ -f $BASEDIR/$DOT_FILE ]
then
	rm $BASEDIR/$DOT_FILE
fi
tar -c --exclude-from exclude.lst  -zvf $BASEDIR/$DOT_FILE .

if [ -f remote-hosts ]
then
    echo [+] Iterate over destinations

    declare -a arr=(`cat $BASEDIR/remote-hosts`)

    for i in "${arr[@]}"
    do
       echo [+] Deploy on $i
       home_dir=`ssh $i pwd`
       scp $BASEDIR/$DOT_FILE $i:$home_dir/$DOT_FILE
       echo [+] dot-files transfered
       ssh $i $EXTRACT_CMD
       echo [+] data extractat at $i:$home_dir
    done
else
    echo [!] No 'remote-hosts' found, Skip!
fi

echo [+] Deploy local
prev_dir=`pwd`
cp $BASEDIR/$DOT_FILE ~/$DOT_FILE
eval $EXTRACT_CMD
rm $BASEDIR/$DOT_FILE

echo [+] Finished
exit 0
