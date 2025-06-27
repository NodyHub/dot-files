# ZSH History configuration

export HISTSIZE=10000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

# History options
setopt hist_ignore_all_dups    # No duplicate entries
setopt append_history          # Append rather than overwrite
setopt inc_append_history      # Add history immediately after typing a command
unsetopt hist_save_by_copy     # Don't save a duplicate of the previous event
