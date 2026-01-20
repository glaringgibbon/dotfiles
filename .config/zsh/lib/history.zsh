# $XDG_CONFIG_HOME/zsh/lib/history.zsh
# Command history configuration
# HomeLab Dotfiles - Refactored 2026-01-18

# --- File Location ---
# HISTFILE is already exported in .zshenv to $XDG_STATE_HOME/zsh/history
# Ensure the directory exists
[[ -d "$(dirname "$HISTFILE")" ]] || mkdir -p "$(dirname "$HISTFILE")"

# --- History Size ---
HISTSIZE=50000
SAVEHIST=50000

# --- History Options ---
setopt BANG_HIST              # Treat the '!' character specially during expansion
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY          # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks from each command line being added
setopt HIST_VERIFY            # Do not execute immediately upon history expansion
