# Prompt configuration and styling

# Prompt variables
# Prompt variables - defined globally so they work in PS1
curdir="%d"
hostname="%M"
username="%n"
bold="%B"
unbold="%b"
standout="%S"
unstandout="%s"
colorfg="%F"
uncolorfg="%f"
colorbg="%K"
uncolorbg="%k"
mytime="%*"
mydate="%D"
line_tty="%y"
rootorwhat="%#"
return_status="%?"

# Session type detection
if [ -f /.dockerenv ]; then
  SESSION_TYPE=docker
elif [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$SESSION_TYPE" ]; then
  SESSION_TYPE=remote/ssh                                                                                                         
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
    sudo) case $(ps -o comm= -p $(ps -o ppid= -p $(ps -o ppid= -p $PPID))) in
            sshd|*/sshd) SESSION_TYPE=ssh/sudo;;
            *) SESSION_TYPE=local;;
          esac ;;
    *) SESSION_TYPE=local;;
  esac
fi

# Set hostname display based on session type
if [ "$SESSION_TYPE" = "local" ]; then
  hostname=""
else
  hostname="$username@$hostname:"
fi

# User color based on privileges
# User color based on privileges
user_color=$colorfg{green}
if [ "$username" = 'root' ]; then
   user_color=$colorfg{red}
fi

# Host color based on session type
host_color=$colorfg{cyan}
if [ "$SESSION_TYPE" = "docker" ]; then
    host_color=$colorfg{magenta}
fi

# Path helpers - make them global
current_path=$(pwd)
path_start="/"
if [[ $current_path == $HOME* ]]; then
    path_start="~"
fi

get_path() {
  return "asd"
}

# Background jobs counter for prompt
function bg_count() {
  cnt=$(jobs | grep -v '(pwd now:' | wc -l | tr -d ' ')
  if [[ $cnt -gt 0 ]]; then 
    echo -n "[bg:$cnt]"
  fi
}

# Path formatter for prompt - optimized
function path_shortener() {
  # This is more efficient than calling pwd repeatedly
  if [[ $PWD == $HOME* ]]; then
    echo -n "~"
  fi
  echo -n "/"
}

# Pre-command to build prompt components - runs once before prompt is displayed
function build_prompt() {
  # Cache prompt components for efficiency
  PROMPT_GIT_INFO=$(git_branch_name)
  PROMPT_BG_JOBS=$(bg_count)
  
  # Build combined elements only once per prompt
  PROMPT_PREFIX=""
  if [[ -n "$PROMPT_GIT_INFO" || -n "$PROMPT_BG_JOBS" ]]; then
    PROMPT_PREFIX="${PROMPT_GIT_INFO}${PROMPT_BG_JOBS} "
  fi
}

# Add the hook to build prompt components
autoload -Uz add-zsh-hook
add-zsh-hook precmd build_prompt

# Set prompt - use cached variables instead of calling functions in PS1
RPROMPT=''
# Use more efficient form with pre-calculated components
PS1='$PROMPT_PREFIX$hostname%(4~|$(path_shortener).../%2~|%~)%# '
