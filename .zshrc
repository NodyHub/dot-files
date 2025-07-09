# Main ZSH configuration file
# This file loads all modular configuration files

# Set ZSH configuration path
export ZSH="$HOME/.zsh"

# Create directories if they don't exist
[[ -d "$ZSH" ]] || mkdir -p "$ZSH"
[[ -d "$ZSH/plugins" ]] || mkdir -p "$ZSH/plugins" 
[[ -d "$ZSH/custom" ]] || mkdir -p "$ZSH/custom"

# Load profiler first if enabled
if [[ -f "$ZSH/lib/core/profiler.zsh" ]]; then
  source "$ZSH/lib/core/profiler.zsh"
fi

# Load library files in a specific order to ensure dependencies are met
# Core should be loaded first
if [[ -f "$ZSH/lib/core/core.zsh" ]]; then
  [[ -n "$ZSH_PROFILE" ]] && zsh_profile_start "Loading core"
  source "$ZSH/lib/core/core.zsh"
  [[ -n "$ZSH_PROFILE" ]] && zsh_profile_end "Loading core"
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

# Load plugins with caching for better performance
if [[ -f "$ZSH/lib/core/plugin-cache.zsh" ]]; then
  [[ -n "$ZSH_PROFILE" ]] && zsh_profile_start "Loading plugins"
  source "$ZSH/lib/core/plugin-cache.zsh"
  load_cached_plugins
  [[ -n "$ZSH_PROFILE" ]] && zsh_profile_end "Loading plugins"
else
  # Fallback to standard loading if cache system isn't available
  [[ -n "$ZSH_PROFILE" ]] && zsh_profile_start "Loading plugins"
  for plugin in $ZSH/plugins/*(N); do
    if [[ -d "$plugin" ]]; then
      plugin_name=$(basename "$plugin")
      if [[ -f "$ZSH/plugins/$plugin_name/$plugin_name.plugin.zsh" ]]; then
        source "$ZSH/plugins/$plugin_name/$plugin_name.plugin.zsh"
      fi
    fi
  done
  [[ -n "$ZSH_PROFILE" ]] && zsh_profile_end "Loading plugins"
fi

# Final initialization and performance reporting
[[ -n "$ZSH_PROFILE" ]] && zsh_profile_startup_complete

# Debug options:
# export ZSH_DEBUG=1    # Enable plugin cache debugging
# export ZSH_PROFILE=1  # Enable startup profiling
# export ZSH_COMMAND_TIME=1  # Show execution time for slow commands
