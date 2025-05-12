# $XDG_CONFIG_HOME/zsh/lib/prompt.zsh
# ZSH prompt configuration with git awareness
# HomeLab Dotfiles - Created 2025-05-05

# Load required modules
autoload -Uz vcs_info
autoload -Uz colors && colors

# Configure vcs_info for git
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{green}●%f"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}●%f"
zstyle ':vcs_info:git:*' formats " %F{blue}(%f%F{magenta}%b%f%c%u%F{blue})%f"
zstyle ':vcs_info:git:*' actionformats " %F{blue}(%f%F{magenta}%b%f|%F{red}%a%f%c%u%F{blue})%f"

# Function to display the current Python virtual environment
function virtualenv_info {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "%F{cyan}($(basename $VIRTUAL_ENV))%f "
    fi
}

# Function to show execution time of last command
function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  # Execute vcs_info before each prompt
  vcs_info
  
  # Calculate command execution time
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    if [ $timer_show -gt 1 ]; then
      export RPROMPT="%F{cyan}${timer_show}s%f"
    else
      export RPROMPT=""
    fi
    unset timer
  fi
}

# Function to show SSH indicator
function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%F{red}(SSH)%f "
  fi
}

# Function to show return status of last command
function return_status() {
  echo "%(?:%F{green}➜:%F{red}➜)%f "
}

# Function to show current directory with home directory as ~
function current_dir() {
  echo "%F{blue}%~%f"
}

# Set the prompt
setopt PROMPT_SUBST
PROMPT='$(ssh_connection)$(virtualenv_info)$(return_status)$(current_dir)${vcs_info_msg_0_} %F{white}»%f '

# Show hostname in prompt when in SSH session
if [[ -n $SSH_CONNECTION ]]; then
  PROMPT='%F{yellow}%m%f:$(return_status)$(current_dir)${vcs_info_msg_0_} %F{white}»%f '
fi

# Root user gets a different prompt color
if [[ $UID -eq 0 ]]; then
  PROMPT='%F{red}%n%f@%F{yellow}%m%f:$(return_status)$(current_dir)${vcs_info_msg_0_} %F{red}#%f '
fi

# Function to update terminal title
function set_terminal_title() {
  print -Pn "\e]0;%n@%m: %~\a"
}

# Add hook to update terminal title before displaying prompt
precmd_functions+=(set_terminal_title)
