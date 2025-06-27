# ZSH Aliases

## Modified commands ## 
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias dmesg='dmesg -HL'
alias meh='echo "¯\_(ツ)_/¯"'
alias xopen='xdg-open'

## New commands ##
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep'         # requires an argument
alias openports='ss --all --numeric --processes --ipv4 --ipv6'
alias pgg='ps -Af | grep'           # requires an argument
alias ..='cd ..'

## ls ##
alias ls='ls -hF --color=auto'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'

## Safety features ##
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -v'
alias ln='ln -i'
alias chown='chown --preserve-root'
if [[ $(uname) != "Darwin" ]]; then 
  alias chmod='chmod --preserve-root'
  alias chgrp='chgrp --preserve-root'
fi
alias cls=' echo -ne "\033c"'       # clear screen for real (it does not work in Terminology)

## Make Bash error tolerant ##
alias :q=' exit'
alias :Q=' exit'
alias :x=' exit'
alias cd..='cd ..'
