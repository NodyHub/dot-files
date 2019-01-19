export EDITOR="vim"
#
# command autocompletion
autoload -U compinit promptinit
compinit
promptinit
setopt completealiases

# additional cmds
setopt promptsubst

# Ensure Prompt Coloring
TERM=xterm-256color 

# arrow keys navi
zstyle ':completion:*' menu select

# zsh coloring & styling
autoload -U colors && colors

local curdir="%d"
local hostname="%M"
local username="%n"
local bold="%B"
local unbold="%b"
local standout="%S"
local unstandout="%s"
local colorfg="%F"
local uncolorfg="%f"
local colorbg="%K"
local uncolorbg="%k"
local mytime="%*"
local mydate="%D"
local line_tty="%y"
local rootorwhat="%#"
local return_status="%?"


function preexec() {
  timer=${timer:-$SECONDS}
}

# function precmd() {
#   if [ $timer ]; then
#     timer_show=$(($SECONDS - $timer))
#     export RPROMPT="%F{yellow}[%F{cyan}${timer_show}s%F{yellow}]%{$reset_color%}"
#     unset timer
#   fi
# }
# Usage: smartcompress <file> (<type>)
# Description: compresses files or a directory.  Defaults to tar.gz
function compress() {
    if [[ -e $1 ]]; then
        if [ $2 ]; then
            case $2 in
                tgz | tar.gz)   tar -zcvf$1.$2 $1                  ;;
                tbz2 | tar.bz2) tar -jcvf$1.$2 $1                  ;;
                tar.Z)          tar -Zcvf$1.$2 $1                  ;;
                tar)            tar -cvf$1.$2  $1                  ;;
                zip)            zip -r $1.$2   $1                  ;;
                gz | gzip)      gzip           $1                  ;;
                bz2 | bzip2)    bzip2          $1                  ;;
                gpg)            gpg -e --default-recipient-self $1 ;;
                *)
                echo "Error: $2 is not a valid compression type"
                ;;
            esac
        else
            compress $1 tar.gz
        fi
    else
        echo "File ('$1') does not exist!"
    fi
}

# view archive without unpack
show-archive() {
    if [[ -f $1 ]]; then
        case $1 in
            *.tar.gz)      gunzip -c $1 | tar -tf - -- ;;
            *.tar)         tar -tf $1 ;;
            *.tgz)         tar -ztf $1 ;;
            *.zip)         unzip -l $1 ;;
            *.bz2)         bzless $1 ;;
            *)             echo "'$1' Error. Please go away" ;;
        esac
    else
        echo "'$1' is not a valid archive"
    fi
}

function extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Find Fuinction
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }


# check if connection is from remote
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh                                                                                                         
# many other tests omitted
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
    *) SESSION_TYPE=local;;
  esac
fi


if [ `whoami` = 'root' ]; then
   local user_color=$colorfg{red}
else
   local user_color=$colorfg{green}
fi

if [ "$SESSION_TYPE" = "local" ]
then
   PS1="$bold$user_color${str}[$uncolorfg%(4~|../%3~|%~)$user_color${str}]$rootorwhat $uncolorfg$unbold"
else
   PS1="$bold$hostname $user_color${str}[$uncolorfg%(4~|../%3~|%~)$user_color${str}]$rootorwhat $uncolorfg$unbold"
fi


## Modified commands ## {{{
alias diff='colordiff'              # requires colordiff package
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias dmesg='dmesg -HL'
# }}}

alias xopen='xdg-open'

## New commands ## {{{
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep'         # requires an argument
alias openports='ss --all --numeric --processes --ipv4 --ipv6'
alias pgg='ps -Af | grep'           # requires an argument
alias ..='cd ..'
# }}}


## ls ## {{{
alias ls='ls -hF --color=auto'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'
# }}}

## Safety features ## {{{
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file
# safer alternative w/ timeout, not stored in history
alias rm=' timeout 3 rm -Iv --one-file-system'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias cls=' echo -ne "\033c"'       # clear screen for real (it does not work in Terminology)
# }}}

## Make Bash error tolerant ## {{{
alias :q=' exit'
alias :Q=' exit'
alias :x=' exit'
alias cd..='cd ..'
# }}}


# key bindings!!
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

bindkey "^R" history-incremental-search-backward
key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
# [[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
# [[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Up]}"      ]]  && bindkey   "${key[Up]}"       up-line-or-beginning-search
[[ -n "${key[Down]}"    ]]  && bindkey   "${key[Down]}"    down-line-or-beginning-search
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# ARROW KEY NAV
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word

# set history
export HISTSIZE=9999999
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups

# auto cd
setopt autocd

# dir colors
eval `dircolors -b ~/.dir_colors`


# reverse search with up-arrow
autoload up-line-or-beginning-search
autoload down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^A" beginning-of-line
bindkey "^E" end-of-line



# comand completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' special-dirs true
zstyle ":completion:*:commands" rehash 1


# manpage colors
man() {
   env \
      LESS_TERMCAP_mb=$(printf "\e[1;31m") \
      LESS_TERMCAP_md=$(printf "\e[1;31m") \
      LESS_TERMCAP_me=$(printf "\e[0m") \
      LESS_TERMCAP_se=$(printf "\e[0m") \
      LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
      LESS_TERMCAP_ue=$(printf "\e[0m") \
      LESS_TERMCAP_us=$(printf "\e[1;32m") \
         man "$@"
}

LESSCHARSET=UTF-8

# SDL_VIDEO_FULLSCREEN_HEAD=1

# Extend path
export PATH=`echo ~`/bin:/sbin:$PATH


case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;%n@%m: %~\a"}
        ;;
esac
