# $XDG_CONFIG_HOME/zsh/lib/history.zsh
# History configuration settings
# HomeLab Dotfiles - Created 2025-05-05

# History file configuration
HISTFILE="${XDG_STATE_HOME}/zsh/history"  # XDG compliant history location
HISTSIZE=50000                            # Maximum events in internal history
SAVEHIST=50000                            # Maximum events in history file

# History command configuration
setopt EXTENDED_HISTORY       # Record timestamp of command in HISTFILE
setopt HIST_EXPIRE_DUPS_FIRST # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded again
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found
setopt HIST_IGNORE_SPACE      # Don't record commands starting with a space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry
setopt HIST_VERIFY            # Don't execute immediately upon history expansion
setopt HIST_BEEP              # Beep when accessing nonexistent history

# History navigation
bindkey '^[[A' up-line-or-search      # Up arrow for previous matching command
bindkey '^[[B' down-line-or-search    # Down arrow for next matching command

# Create a function to search history with pattern
function hist() {
  if [ -z "$1" ]; then
    history 1
  else
    history 1 | grep -i "$@"
  fi
}

# Create a more readable history command
function historystat() {
  history 0 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | \
  grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n25
}
