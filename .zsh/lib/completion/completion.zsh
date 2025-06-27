# ZSH Completion configuration

# Basic completion setup
autoload -U compinit promptinit
compinit
promptinit

# Command completion
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' special-dirs true
zstyle ":completion:*:commands" rehash 1

# Load additional completions
autoload -U +X bashcompinit && bashcompinit

# External tool completions
if [[ -x $(which kubectl 2> /dev/null) ]]; then
   source <(kubectl completion zsh)
fi

if [[ -x $(which minikube 2> /dev/null) ]]; then
   source <(minikube completion zsh)
fi

if [[ -x $(which consul 2> /dev/null) ]]; then
   complete -o nospace -C $(which consul) consul
fi

if [[ -x $(which nomad 2> /dev/null) ]]; then
   complete -o nospace -C $(which nomad) nomad
fi

if [[ -x $(which terraform 2> /dev/null) ]]; then
   complete -o nospace -C $(which terraform) terraform
fi

if [[ -x $(which waypoint 2> /dev/null) ]]; then
   complete -o nospace -C $(which waypoint) waypoint
fi

# Tab completion for 'z' if available
compdef _zshz ${ZSHZ_CMD:-${_Z_CMD:-z}} 2>/dev/null || true
