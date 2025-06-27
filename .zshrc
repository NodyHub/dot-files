# Main ZSH configuration file
# This file loads all modular configuration files

# Set ZSH configuration path
export ZSH="$HOME/.zsh"

# Create directories if they don't exist
[[ -d "$ZSH" ]] || mkdir -p "$ZSH"
[[ -d "$ZSH/plugins" ]] || mkdir -p "$ZSH/plugins" 
[[ -d "$ZSH/custom" ]] || mkdir -p "$ZSH/custom"

# Load library files in a specific order to ensure dependencies are met
# Core should be loaded first
if [[ -f "$ZSH/lib/core/core.zsh" ]]; then
  source "$ZSH/lib/core/core.zsh"
fi

# Then load exports (safely handling no matches)
for module in $ZSH/lib/exports/*.zsh(N); do
  source "$module"
done

# Then load all other modules
for dir in "$ZSH/lib/"*/(N); do
  dir_name=$(basename "$dir")
  if [[ "$dir_name" != "core" && "$dir_name" != "exports" ]]; then
    for file in "$dir"*.zsh(N); do
      if [[ -f "$file" ]]; then
        source "$file"
      fi
    done
  fi
done

# Load custom files if they exist (safely handling no matches)
for custom in $ZSH/custom/*.zsh(N); do
  if [[ -f "$custom" ]]; then
    source "$custom"
  fi
done

# Load plugins (safely handling no matches)
for plugin in $ZSH/plugins/*(N); do
  if [[ -d "$plugin" ]]; then
    plugin_name=$(basename "$plugin")
    if [[ -f "$ZSH/plugins/$plugin_name/$plugin_name.plugin.zsh" ]]; then
      source "$ZSH/plugins/$plugin_name/$plugin_name.plugin.zsh"
    fi
  fi
done

# Initialize completions
autoload -U compinit
compinit
