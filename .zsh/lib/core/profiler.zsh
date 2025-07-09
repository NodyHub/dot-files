# ZSH performance profiler

# Enable with: export ZSH_PROFILE=1

if [[ -n "$ZSH_PROFILE" ]]; then
  # Load zsh/datetime for high-resolution timestamps
  zmodload zsh/datetime
  
  # Profile variables
  typeset -A ZSH_PROFILE_TIMES
  typeset -A ZSH_PROFILE_RESULTS
  
  # Function to start timing a section
  function zsh_profile_start() {
    local section=$1
    ZSH_PROFILE_TIMES[$section]=$EPOCHREALTIME
  }
  
  # Function to end timing a section
  function zsh_profile_end() {
    local section=$1
    if [[ -n "$ZSH_PROFILE_TIMES[$section]" ]]; then
      local start=${ZSH_PROFILE_TIMES[$section]}
      local end=${EPOCHREALTIME}
      
      # Ensure we have valid numeric values
      if [[ "$start" =~ ^[0-9.]+$ && "$end" =~ ^[0-9.]+$ ]]; then
        # Use bc for floating point arithmetic if available
        if command -v bc >/dev/null 2>&1; then
          local duration=$(echo "($end - $start) * 1000" | bc)
        else
          # Fallback to zsh arithmetic, which may be less precise
          local duration=$(( (end - start) * 1000 ))
        fi
        ZSH_PROFILE_RESULTS[$section]=$duration
      else
        ZSH_PROFILE_RESULTS[$section]="NaN" # Not a number
      fi
    fi
  }
  
  # Function to report profile results
  function zsh_profile_report() {
    echo "ZSH Performance Profile:"
    echo "========================"
    local total=0
    
    # Use bc for floating point arithmetic if available
    local use_bc=0
    command -v bc >/dev/null 2>&1 && use_bc=1
    
    for section in ${(k)ZSH_PROFILE_RESULTS}; do
      local result=${ZSH_PROFILE_RESULTS[$section]}
      
      # Handle numeric results
      if [[ "$result" =~ ^[0-9.]+$ ]]; then
        printf "%-30s %8.2f ms\n" "$section:" "$result"
        
        # Add to total
        if (( use_bc )); then
          total=$(echo "$total + $result" | bc)
        else
          total=$(( total + result ))
        fi
      else
        printf "%-30s %8s\n" "$section:" "$result"
      fi
    done
    
    echo "------------------------"
    printf "%-30s %8.2f ms\n" "Total:" "$total"
    echo "\nEnable detailed command timing with: export ZSH_COMMAND_TIME=1"
  }
  
  # Track command execution time
  function preexec_profiler() {
    ZSH_COMMAND_START_TIME=$EPOCHREALTIME
  }
  
  function precmd_profiler() {
    if [[ -n "$ZSH_COMMAND_START_TIME" && -n "$ZSH_COMMAND_TIME" ]]; then
      local end=${EPOCHREALTIME}
      local start=${ZSH_COMMAND_START_TIME}
      
      # Ensure we have valid numeric values
      if [[ "$start" =~ ^[0-9.]+$ && "$end" =~ ^[0-9.]+$ ]]; then
        # Use bc for floating point arithmetic if available
        local duration
        if command -v bc >/dev/null 2>&1; then
          duration=$(echo "($end - $start) * 1000" | bc)
          # Check if we should show the duration
          if (( $(echo "$duration > 100" | bc) )); then
            printf "Command execution time: %.2f ms\n" "$duration"
          fi
        else
          # Fallback to zsh arithmetic
          duration=$(( (end - start) * 1000 ))
          if (( duration > 100 )); then
            printf "Command execution time: %.2f ms\n" "$duration"
          fi
        fi
      fi
      unset ZSH_COMMAND_START_TIME
    fi
  }
  
  # Set up hooks for command timing
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec preexec_profiler
  add-zsh-hook precmd precmd_profiler
  
  # Report on exit
  function zshexit_profiler() {
    zsh_profile_report
  }
  
  add-zsh-hook zshexit zshexit_profiler
  
  # Start timing overall ZSH startup
  zsh_profile_start "ZSH Startup"
  
  # Function to be called at the end of .zshrc
  function zsh_profile_startup_complete() {
    zsh_profile_end "ZSH Startup"
    local result="${ZSH_PROFILE_RESULTS["ZSH Startup"]}"
    
    if [[ "$result" =~ ^[0-9.]+$ ]]; then
      printf "ZSH startup completed in %.2f ms\n" "$result"
    else
      echo "ZSH startup completed (timing unavailable)"
    fi
  }
fi
