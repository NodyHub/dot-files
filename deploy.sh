#!/bin/bash

DOT_FILE=dot-file.zip
EXTRACT_CMD="cd ~ ; [ -d .zsh ] && rm -rf .zsh ; unzip -o $DOT_FILE ; rm $DOT_FILE"

echo [+] Fetch ZSH plugins
git submodule init
git submodule update

echo [+] Prepare zipfile `pwd`/$DOT_FILE
if [ -f $DOT_FILE ]
then
	rm $DOT_FILE
fi
/usr/bin/zip -r $DOT_FILE . -x@exclude.lst

if [ -f remote-hosts ]
then
    echo [+] Iterate over destinations
    
    declare -a arr=(`cat remote-hosts`)
    
    for i in "${arr[@]}"
    do
       echo [+] Deploy on $i
       home_dir=`ssh $i pwd`
       scp $DOT_FILE $i:$home_dir/$DOT_FILE
       echo [+] dot-files transfered
       ssh $i $EXTRACT_CMD
       echo [+] data extractat at $i:$home_dir
    done
else
    echo [!] No 'remote-hosts' found, Skip!
fi

echo [+] Deploy local
prev_dir=`pwd`
cp $DOT_FILE ~/$DOT_FILE
eval $EXTRACT_CMD
# cd $prev_dir

echo [+] Finished
exit 0


