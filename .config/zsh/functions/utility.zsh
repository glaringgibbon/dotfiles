# $XDG_CONFIG_HOME/zsh/functions/utility.zsh
# Utility functions for everyday use
# HomeLab Dotfiles - Created 2025-05-05

# Function to create a directory and cd into it
function mkcd() {
  mkdir -p "$1" && cd "$1" || return
}

# Function to extract most archive formats
function extract() {
  if [ -z "$1" ]; then
    echo "Usage: extract <archive_file>"
    return 1
  fi
  
  if [ ! -f "$1" ]; then
    echo "'$1' is not a valid file"
    return 1
  fi
  
  case "$1" in
    *.tar.bz2)   tar xjf "$1"     ;;
    *.tar.gz)    tar xzf "$1"     ;;
    *.tar.xz)    tar xJf "$1"     ;;
    *.bz2)       bunzip2 "$1"     ;;
    *.rar)       unrar x "$1"     ;;
    *.gz)        gunzip "$1"      ;;
    *.tar)       tar xf "$1"      ;;
    *.tbz2)      tar xjf "$1"     ;;
    *.tgz)       tar xzf "$1"     ;;
    *.zip)       unzip "$1"       ;;
    *.Z)         uncompress "$1"  ;;
    *.7z)        7z x "$1"        ;;
    *.xz)        unxz "$1"        ;;
    *)           echo "'$1' cannot be extracted via extract()" ;;
  esac
}

# Function to show disk usage of directories in current location
function duh() {
  du -h --max-depth=1 "${1:-.}" | sort -hr
}

# Function to find files by name
function ff() {
  find . -type f -name "*$1*" 2>/dev/null
}

# Function to find directories by name
function fd() {
  find . -type d -name "*$1*" 2>/dev/null
}

# Function to search file contents
function ftext() {
  grep -r --color=auto "$1" .
}

# Function to display weather
function weather() {
  local city="${1:-}"
  curl -s "wttr.in/${city}"
}

# Function to show public IP address
function myip() {
  curl -s ifconfig.me
  echo
}

# Function to show system information
function sysinfo() {
  echo "CPU Information:"
  lscpu | grep "Model name" | sed 's/Model name:[[:space:]]*//'
  
  echo -e "\nMemory Information:"
  free -h | grep "Mem:" | awk '{print "Total: " $2 ", Used: " $3 ", Free: " $4}'
  
  echo -e "\nDisk Usage:"
  df -h / | awk 'NR==2 {print "Total: " $2 ", Used: " $3 ", Free: " $4 ", Use%: " $5}'
  
  echo -e "\nDistribution:"
  if command -v lsb_release &> /dev/null; then
    lsb_release -d | sed 's/Description:[[:space:]]*//'
  elif [ -f /etc/os-release ]; then
    grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g; s/"//g'
  fi
  
  echo -e "\nKernel Version:"
  uname -r
}

# Function to show directory size
function dirsize() {
  if [ -z "$1" ]; then
    du -sh .
  else
    du -sh "$1"
  fi
}

# Function to kill processes by name
function pskill() {
  local pids
  pids=$(pgrep -f "$1")
  if [ -n "$pids" ]; then
    echo "Killing processes: $pids"
    kill "$pids"
  else
    echo "No processes matching '$1' found"
  fi
}

# Function to start Python virtual environment
function pyvenv() {
  local venv_dir="${1:-venv}"
  
  if [ -d "$venv_dir" ]; then
    source "$venv_dir/bin/activate"
  else
    echo "Creating new Python virtual environment in $venv_dir..."
    python -m venv "$venv_dir"
    source "$venv_dir/bin/activate"
  fi
}

# Function to generate a random password
function genpass() {
  local length="${1:-16}"
  LC_ALL=C tr -dc 'A-Za-z0-9_!@#$%^&*()-+=' < /dev/urandom | head -c "$length"
  echo
}

# Function to create a backup of a file
function backup() {
  local filename="${1}"
  local filetime
  filetime=$(date +%Y%m%d_%H%M%S)
  cp -a "${filename}" "${filename}_${filetime}"
  echo "Backed up ${filename} to ${filename}_${filetime}"
}

# Quickly edit zsh config files
function zedit() {
  local file
  case "$1" in
    core)     file="${XDG_CONFIG_HOME}/zsh/lib/core.zsh" ;;
    env)      file="${XDG_CONFIG_HOME}/zsh/lib/environment.zsh" ;;
    alias)    file="${XDG_CONFIG_HOME}/zsh/lib/aliases.zsh" ;;
    prompt)   file="${XDG_CONFIG_HOME}/zsh/lib/prompt.zsh" ;;
    binding)  file="${XDG_CONFIG_HOME}/zsh/lib/key-bindings.zsh" ;;
    term)     file="${XDG_CONFIG_HOME}/zsh/lib/terminal.zsh" ;;
    comp)     file="${XDG_CONFIG_HOME}/zsh/lib/completion.zsh" ;;
    hist)     file="${XDG_CONFIG_HOME}/zsh/lib/history.zsh" ;;
    *)        file="${XDG_CONFIG_HOME}/zsh/.zshrc" ;;
  esac
  
  ${EDITOR:-vim} "$file"
}

# Function to reload the zsh configuration
function zreload() {
  source "${XDG_CONFIG_HOME}/zsh/zshrc"
  echo "ZSH configuration reloaded."
}
