# Core ZSH configuration

# Set basic options
setopt autocd
setopt promptsubst
setopt completealiases

# Load colors
autoload -U colors && colors

# Terminal title for xterm
case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;%n@%m: %~\a"}
        ;;
esac
