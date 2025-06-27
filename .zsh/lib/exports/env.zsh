# Environment variables and exports

export EDITOR="vim"
export GPG_TTY=$(tty)
export LESSCHARSET=UTF-8

# Set up path for Go if installed
if [[ -x $(which go 2> /dev/null) ]]; then
   export GOPATH="$HOME/go"
   export PATH="$PATH:$HOME/go/bin"
fi

# macOS specific settings
if [[ $(uname) = "Darwin" ]]; then
  export CLICOLOR=1
  export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
  if [[ -e /opt/homebrew/bin/brew ]]; then 
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  eval `dircolors -b ~/.dir_colors`
fi
