# Plugin caching system for faster ZSH startup

# Cache directory
PLUGIN_CACHE_DIR="${ZSH:-$HOME/.zsh}/cache"
[[ -d "$PLUGIN_CACHE_DIR" ]] || mkdir -p "$PLUGIN_CACHE_DIR"

# Cache file for all sourced plugins
PLUGIN_CACHE_FILE="$PLUGIN_CACHE_DIR/plugin_cache.zsh"

# Special handling for plugins that require specific directory structure
# Set to false to disable caching and use direct sourcing for problematic plugins
ZSH_CACHE_ALL_PLUGINS=false

# List of plugins that should be loaded directly and not cached
# Common plugins that have issues with caching
PLUGINS_TO_LOAD_DIRECTLY=(
  "zsh-syntax-highlighting"
  "zsh-autosuggestions"
  "zsh-z"
)

# Function to generate plugin cache
generate_plugin_cache() {
  local cache_content=""
  
  # Start with header
  cache_content+="# ZSH plugin cache generated on $(date)\n\n"
  cache_content+="# Define plugin paths to handle relative sourcing\n"
  
  # Process plugins
  for plugin in "${ZSH:-$HOME/.zsh}"/plugins/*(N); do
    if [[ -d "$plugin" ]]; then
      plugin_name=$(basename "$plugin")
      plugin_file="${plugin}/${plugin_name}.plugin.zsh"
      
      # Skip plugins that should be loaded directly
      if (( ${PLUGINS_TO_LOAD_DIRECTLY[(I)$plugin_name]} )) && [[ "$ZSH_CACHE_ALL_PLUGINS" = false ]]; then
        cache_content+="# --- SKIPPING ${plugin_name} for direct loading ---\n"
        continue
      fi
      
      # Add plugin path definition to handle relative paths
      cache_content+="_${plugin_name}_plugin_path=\"${plugin}\"\n"
      
      if [[ -f "$plugin_file" ]]; then
        cache_content+="# --- START ${plugin_name} ---\n"
        cache_content+="# Source: ${plugin_file}\n"
        
        # Get plugin content
        local plugin_content="$(cat "$plugin_file")"
        
        # Special handling for known plugins
        if [[ "$plugin_name" = "zsh-syntax-highlighting" ]]; then
          cache_content+="# Using direct source to avoid path issues\n"
          cache_content+="source \"${plugin}/zsh-syntax-highlighting.zsh\"\n"
          continue
        elif [[ "$plugin_name" = "zsh-autosuggestions" ]]; then
          cache_content+="# Using direct source to avoid path issues\n"
          cache_content+="source \"${plugin}/zsh-autosuggestions.zsh\"\n"
          continue
        else
          # Replace any relative source commands with absolute paths
          # This handles common patterns in zsh plugins
          plugin_content="${plugin_content//source \"\$\{0:A:h\}/source \"\$_${plugin_name}_plugin_path}"
          plugin_content="${plugin_content//source \"\$ZSH_CUSTOM\/plugins\/${plugin_name}/source \"\$_${plugin_name}_plugin_path}"
          plugin_content="${plugin_content//source \"\$\{0\%\/*\}/source \"\$_${plugin_name}_plugin_path}"
          plugin_content="${plugin_content//source \"\$\(dirname \"\$0\"\)/source \"\$_${plugin_name}_plugin_path}"
          
          # Add modified content
          cache_content+="$plugin_content\n"
        fi
        
        cache_content+="# --- END ${plugin_name} ---\n\n"
      fi
    fi
  done
  
  # Write to cache file
  echo -e "$cache_content" > "$PLUGIN_CACHE_FILE"
}

# Function to check if plugins have changed
should_update_cache() {
  # If cache doesn't exist, generate it
  if [[ ! -f "$PLUGIN_CACHE_FILE" ]]; then
    return 0 # true, should update
  fi
  
  local cache_mtime=$(stat -f %m "$PLUGIN_CACHE_FILE" 2>/dev/null || stat -c %Y "$PLUGIN_CACHE_FILE" 2>/dev/null)
  
  # Check if any plugin is newer than cache
  for plugin in "${ZSH:-$HOME/.zsh}"/plugins/*(N); do
    if [[ -d "$plugin" ]]; then
      plugin_name=$(basename "$plugin")
      plugin_file="${plugin}/${plugin_name}.plugin.zsh"
      
      if [[ -f "$plugin_file" ]]; then
        local plugin_mtime=$(stat -f %m "$plugin_file" 2>/dev/null || stat -c %Y "$plugin_file" 2>/dev/null)
        if (( plugin_mtime > cache_mtime )); then
          return 0 # true, should update
        fi
      fi
    fi
  done
  
  # Check if .zshrc has been modified (could have added/removed plugins)
  local zshrc_mtime=$(stat -f %m "${ZDOTDIR:-$HOME}/.zshrc" 2>/dev/null || stat -c %Y "${ZDOTDIR:-$HOME}/.zshrc" 2>/dev/null)
  if (( zshrc_mtime > cache_mtime )); then
    return 0 # true, should update
  fi
  
  return 1 # false, no need to update
}

# Function to force regenerate the plugin cache
zsh_regenerate_plugin_cache() {
  echo "Forcing plugin cache regeneration..."
  rm -f "$PLUGIN_CACHE_FILE"
  generate_plugin_cache
  echo "Plugin cache regenerated at: $PLUGIN_CACHE_FILE"
}

# Main function to load plugins
load_cached_plugins() {
  local start_time=$(($(print -P %D{%s%6.}) / 1000))
  local use_cache=true
  
  # Check if we need to update the cache
  if should_update_cache; then
    generate_plugin_cache
    echo "Plugin cache regenerated."
  fi
  
  # Source the cache file
  if [[ -f "$PLUGIN_CACHE_FILE" ]]; then
    # Try using the cache, but fallback to individual loading if it fails
    if [[ -n "$ZSH_DEBUG" ]]; then
      echo "Loading plugins from cache: $PLUGIN_CACHE_FILE"
    fi
    
    if ! source "$PLUGIN_CACHE_FILE" 2>/dev/null; then
      echo "Error loading plugin cache. Falling back to individual loading."
      # Force regeneration on next startup
      rm -f "$PLUGIN_CACHE_FILE"
      use_cache=false
    fi
  else
    use_cache=false
  fi
  
  # Load direct plugins regardless of cache status
  for plugin in "${ZSH:-$HOME/.zsh}"/plugins/*(N); do
    if [[ -d "$plugin" ]]; then
      plugin_name=$(basename "$plugin")
      
      # Load plugins that should be loaded directly
      if (( ${PLUGINS_TO_LOAD_DIRECTLY[(I)$plugin_name]} )) && [[ "$ZSH_CACHE_ALL_PLUGINS" = false ]]; then
        if [[ -n "$ZSH_DEBUG" ]]; then
          echo "Direct loading plugin: $plugin_name"
        fi
        
        # Handle special plugins
        if [[ "$plugin_name" = "zsh-syntax-highlighting" ]] && [[ -f "$plugin/zsh-syntax-highlighting.zsh" ]]; then
          source "$plugin/zsh-syntax-highlighting.zsh"
        elif [[ "$plugin_name" = "zsh-autosuggestions" ]] && [[ -f "$plugin/zsh-autosuggestions.zsh" ]]; then
          source "$plugin/zsh-autosuggestions.zsh"
        else
          # Default to standard plugin file
          plugin_file="${plugin}/${plugin_name}.plugin.zsh"
          if [[ -f "$plugin_file" ]]; then
            source "$plugin_file"
          fi
        fi
      fi
    fi
  done
  
  # Fallback to loading plugins individually if cache failed
  if [[ "$use_cache" = false ]]; then
    if [[ -n "$ZSH_DEBUG" ]]; then
      echo "Loading remaining plugins individually"
    fi
    
    for plugin in "${ZSH:-$HOME/.zsh}"/plugins/*(N); do
      if [[ -d "$plugin" ]]; then
        plugin_name=$(basename "$plugin")
        
        # Skip plugins that were already loaded directly
        if (( ${PLUGINS_TO_LOAD_DIRECTLY[(I)$plugin_name]} )); then
          continue
        fi
        
        plugin_file="${plugin}/${plugin_name}.plugin.zsh"
        
        if [[ -f "$plugin_file" ]]; then
          if [[ -n "$ZSH_DEBUG" ]]; then
            echo "Loading plugin: $plugin_name"
          fi
          source "$plugin_file"
        fi
      fi
    done
  fi
  
  local end_time=$(($(print -P %D{%s%6.}) / 1000))
  local elapsed=$((end_time - start_time))
  
  # Only show timing in interactive shells if debug is enabled
  if [[ -n "$ZSH_DEBUG" && -o interactive ]]; then
    echo "Loaded plugins in ${elapsed}ms using $([ "$use_cache" = "true" ] && echo "cache" || echo "individual loading")"
  fi
}
