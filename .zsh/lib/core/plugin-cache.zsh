# Plugin caching system for faster ZSH startup

# Debug flag (set ZSH_DEBUG=1 to enable debug output)
[[ -z "$ZSH_DEBUG" && -n "$ZSH_PLUGIN_DEBUG" ]] && ZSH_DEBUG="$ZSH_PLUGIN_DEBUG"

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
  
  # Get cache modification time using our helper function
  local cache_mtime=$(get_file_mtime "$PLUGIN_CACHE_FILE")
  
  if [[ -n "$ZSH_DEBUG" ]]; then
    echo "Cache file mtime: $cache_mtime"
  fi
  
  # Check if any plugin is newer than cache
  for plugin in "${ZSH:-$HOME/.zsh}"/plugins/*(N); do
    if [[ -d "$plugin" ]]; then
      plugin_name=$(basename "$plugin")
      plugin_file="${plugin}/${plugin_name}.plugin.zsh"
      
      if [[ -f "$plugin_file" ]]; then
        local plugin_mtime=$(get_file_mtime "$plugin_file")
        
        if [[ -n "$ZSH_DEBUG" ]]; then
          echo "Plugin $plugin_name mtime: $plugin_mtime"
        fi
        
        # Safe comparison using numeric test
        if (( plugin_mtime > cache_mtime )); then
          if [[ -n "$ZSH_DEBUG" ]]; then
            echo "Plugin $plugin_name is newer than cache"
          fi
          return 0 # true, should update
        fi
      fi
    fi
  done
  
  # Check if .zshrc has been modified (could have added/removed plugins)
  local zshrc_file="${ZDOTDIR:-$HOME}/.zshrc"
  local zshrc_mtime=$(get_file_mtime "$zshrc_file")
  
  if [[ -n "$ZSH_DEBUG" ]]; then
    echo ".zshrc mtime: $zshrc_mtime"
  fi
  
  # Safe comparison using numeric test
  if (( zshrc_mtime > cache_mtime )); then
    if [[ -n "$ZSH_DEBUG" ]]; then
      echo ".zshrc is newer than cache"
    fi
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

# Make functions available without export -f (which is Bash-specific)
# These functions are already globally available in ZSH

# Function to safely get file modification time across different Unix systems
get_file_mtime() {
  local file="$1"
  local mtime=0
  
  if [[ -f "$file" ]]; then
    # Try macOS format first, then Linux format
    mtime=$(stat -f %m "$file" 2>/dev/null || stat -c %Y "$file" 2>/dev/null)
    
    # Verify we got a number
    if [[ ! "$mtime" =~ ^[0-9]+$ ]]; then
      # If we got a non-numeric value, fall back to a default
      if [[ -n "$ZSH_DEBUG" ]]; then
        echo "Warning: Could not get valid mtime for $file (got: $mtime)"
      fi
      mtime=0
    fi
  fi
  
  echo $mtime
}

# Function to debug stat command behavior across platforms
debug_stat_command() {
  echo "Debugging stat command for file: $1"
  local file="$1"
  
  echo "File exists: $(test -f "$file" && echo "Yes" || echo "No")"
  
  # Try macOS format
  echo "macOS stat attempt:"
  stat -f %m "$file" 2>&1
  
  # Try Linux format
  echo "Linux stat attempt:"
  stat -c %Y "$file" 2>&1
  
  # Try our helper
  echo "get_file_mtime result: $(get_file_mtime "$file")"
  
  # Show file info
  echo "ls -la output:"
  ls -la "$file" 2>&1
}

# Export a debugging function that can be called from command line
debug_plugin_cache() {
  echo "Plugin cache debug info:"
  echo "ZSH: ${ZSH:-$HOME/.zsh}"
  echo "Plugin cache dir: $PLUGIN_CACHE_DIR"
  echo "Plugin cache file: $PLUGIN_CACHE_FILE"
  echo "Cache file exists: $(test -f "$PLUGIN_CACHE_FILE" && echo "Yes" || echo "No")"
  
  # Debug stat command
  debug_stat_command "$PLUGIN_CACHE_FILE"
  
  # Check for plugin files
  echo "\nChecking plugin files:"
  for plugin in "${ZSH:-$HOME/.zsh}"/plugins/*(N); do
    if [[ -d "$plugin" ]]; then
      plugin_name=$(basename "$plugin")
      plugin_file="${plugin}/${plugin_name}.plugin.zsh"
      echo "Plugin $plugin_name file exists: $(test -f "$plugin_file" && echo "Yes" || echo "No")"
      if [[ -f "$plugin_file" ]]; then
        debug_stat_command "$plugin_file"
      fi
    fi
  done
  
  # Check for zshrc
  echo "\nChecking .zshrc:"
  local zshrc_file="${ZDOTDIR:-$HOME}/.zshrc"
  debug_stat_command "$zshrc_file"
}

# Main function to load plugins
load_cached_plugins() {
  # Get millisecond timestamp in a cross-platform way
  local start_time
  if command -v python3 >/dev/null 2>&1; then
    start_time=$(python3 -c 'import time; print(int(time.time() * 1000))')
  elif command -v python >/dev/null 2>&1; then
    start_time=$(python -c 'import time; print(int(time.time() * 1000))')
  else
    start_time=$(date +%s000) # Fallback, second precision only
  fi
  
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
  
  # Get end time in milliseconds
  local end_time
  if command -v python3 >/dev/null 2>&1; then
    end_time=$(python3 -c 'import time; print(int(time.time() * 1000))')
  elif command -v python >/dev/null 2>&1; then
    end_time=$(python -c 'import time; print(int(time.time() * 1000))')
  else
    end_time=$(date +%s000) # Fallback, second precision only
  fi
  
  # Calculate elapsed time safely
  local elapsed=0
  if [[ -n "$end_time" && -n "$start_time" ]]; then
    elapsed=$((end_time - start_time))
  fi
  
  # Only show timing in interactive shells if debug is enabled
  if [[ -n "$ZSH_DEBUG" && -o interactive ]]; then
    echo "Loaded plugins in ${elapsed}ms using $([ "$use_cache" = "true" ] && echo "cache" || echo "individual loading")"
  fi
}
