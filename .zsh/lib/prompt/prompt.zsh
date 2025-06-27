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

# Path formatter for prompt
function foo() {
  if [[ $(pwd) == $HOME* ]]; then
    echo -n "~"
  fi
  echo -n "/"
}

# Pre hostname function for prompt
function pre_hostname() {
  gbn=$(git_branch_name)
  bgc=$(bg_count)
  res="${gbn}${bgc}"
  if [ ! -z "$res" ]; then
    echo -n "$res "
  fi
}

# Set prompt
RPROMPT=''
# Use direct % character for prompt end to avoid variable expansion issues
PS1='$(pre_hostname)$hostname%(4~|$(foo).../%2~|%~)%# '
