# ZSH Completion configuration - Optimized for performance

# Setup completion cache directory
[[ -d ~/.zsh/cache ]] || mkdir -p ~/.zsh/cache

# Define dump file location with host-specific name to avoid conflicts
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zsh/cache/zcompdump-${HOST}-${ZSH_VERSION}"

# Only load compinit once
if [[ "$_COMPINIT_LOADED" != "true" ]]; then
  # Load with caching - only rebuild cache once per day
  autoload -Uz compinit
  
  # Check if dump is older than 24 hours
  if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
    compinit -d "$ZSH_COMPDUMP"
  else
    # Use cached completion without checking all files (-C flag)
    compinit -C -d "$ZSH_COMPDUMP"
  fi
  
  export _COMPINIT_LOADED="true"
fi

# Load promptinit only once
if [[ "$_PROMPTINIT_LOADED" != "true" ]]; then
  autoload -U promptinit
  promptinit
  export _PROMPTINIT_LOADED="true"
fi

# Command completion style settings - these are fast
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' special-dirs true
zstyle ":completion:*:commands" rehash 1

# Load bash completions only if needed and only once
if [[ "$_BASH_COMPLETION_LOADED" != "true" ]]; then
  autoload -U +X bashcompinit && bashcompinit
  export _BASH_COMPLETION_LOADED="true"
fi

# External tool completions - lazy loaded to improve startup time
function _load_tool_completion() {
  local tool=$1
  local completion_command=$2
  
  if [[ ! -f ~/.zsh/cache/${tool}_completion_loaded ]] && [[ -x $(which ${tool} 2> /dev/null) ]]; then
    eval "${completion_command}"
    touch ~/.zsh/cache/${tool}_completion_loaded
  fi
}

# Lazy-load tool completions when the tool is first used
function kubectl() {
  _load_tool_completion kubectl "source <(kubectl completion zsh)"
  unfunction kubectl
  kubectl "$@"
}

function minikube() {
  _load_tool_completion minikube "source <(minikube completion zsh)"
  unfunction minikube
  minikube "$@"
}

function terraform() {
  _load_tool_completion terraform "complete -o nospace -C $(which terraform) terraform"
  unfunction terraform
  terraform "$@"
}

# Git completion - lazy loaded
function git() {
  if [[ ! -f ~/.zsh/cache/git_completion_loaded ]]; then
    # Git completion is usually pre-installed with zsh but we'll check
    if [[ -f /usr/share/git/completion/git-completion.zsh ]]; then
      source /usr/share/git/completion/git-completion.zsh
    elif [[ -f /usr/local/share/zsh/site-functions/_git ]]; then
      # macOS with homebrew git
      fpath=(/usr/local/share/zsh/site-functions $fpath)
      autoload -Uz _git
    elif [[ -f /opt/homebrew/share/zsh/site-functions/_git ]]; then
      # macOS with homebrew on Apple Silicon
      fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
      autoload -Uz _git
    elif [[ -f ~/.zsh/completions/_git ]]; then
      # Try custom location
      fpath=(~/.zsh/completions $fpath)
      autoload -Uz _git
    fi
    touch ~/.zsh/cache/git_completion_loaded
  fi
  unfunction git
  git "$@"
}

# Wget completion - lazy loaded
function wget() {
  _load_tool_completion wget "autoload -Uz _wget && compdef _wget wget"
  unfunction wget
  wget "$@"
}

# Curl completion - lazy loaded
function curl() {
  _load_tool_completion curl "autoload -Uz _curl && compdef _curl curl"
  unfunction curl
  curl "$@"
}

# Additional tool completions can be added in the same pattern

# Create a custom file to handle z completion after compinit is done
if [[ -d "${ZSH:-$HOME/.zsh}/plugins/zsh-z" && ! -f "${ZSH:-$HOME/.zsh}/custom/z-completion.zsh" ]]; then
  mkdir -p "${ZSH:-$HOME/.zsh}/custom"
  cat > "${ZSH:-$HOME/.zsh}/custom/z-completion.zsh" <<EOT
# z completion setup - automatically generated
# This file runs after compinit to ensure completions work correctly

# Add plugin directory to fpath if not already there
if [[ -d "\${ZSH:-\$HOME/.zsh}/plugins/zsh-z" ]]; then
  fpath=("\${ZSH:-\$HOME/.zsh}/plugins/zsh-z" \$fpath)
fi

# Load the completion function
autoload -Uz _zshz 2>/dev/null || true

# Register the completion with compdef
(( \$+functions[compdef] )) && compdef _zshz \${ZSHZ_CMD:-\${_Z_CMD:-z}} 2>/dev/null || true
EOT
fi