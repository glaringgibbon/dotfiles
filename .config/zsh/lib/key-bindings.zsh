# $XDG_CONFIG_HOME/zsh/lib/key-bindings.zsh
# Vi mode and key bindings configuration
# HomeLab Dotfiles - Created 2025-05-05

# Enable vi mode
bindkey -v

# Reduce escape key delay
export KEYTIMEOUT=1

# Allow up/down arrow for history navigation
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history

# Allow ctrl-p/ctrl-n for history navigation
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history

# History search with up/down in the middle of a line
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Use Ctrl-r for history search (even in vi mode)
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

# Home/End keys
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

# Delete key
bindkey '\e[3~' delete-char

# Edit command in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Insert sudo at beginning of line
function prepend_sudo() {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"
    CURSOR+=5
  fi
}
zle -N prepend_sudo
bindkey -M vicmd 's' prepend_sudo

# Ctrl-z to toggle background/foreground
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg

# Use backspace normally in vi mode
bindkey -v '^?' backward-delete-char

# Allow Shift+Tab to navigate backwards in menu
bindkey '^[[Z' reverse-menu-complete

# Substring history search (bind to arrow keys in vi mode)
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey -M vicmd 'k' history-beginning-search-backward-end
bindkey -M vicmd 'j' history-beginning-search-forward-end

# Navigate words with ctrl+left/right
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Add function to toggle vi-mode indicator in prompt
function zle-line-init zle-keymap-select {
  # Will be used in prompt.zsh for mode indicator
  VI_MODE="${${KEYMAP/vicmd/NORMAL}/(main|viins)/INSERT}"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Advanced vi mode bindings (commented out by default)
# Uncomment the ones you want to enable

# bindkey -M vicmd 'H' beginning-of-line      # H to go to start of line (like vim)
# bindkey -M vicmd 'L' end-of-line            # L to go to end of line (like vim)
# bindkey -M vicmd 'u' undo                   # u to undo
# bindkey -M vicmd '^r' redo                  # Ctrl-r to redo
# bindkey -M vicmd '/' history-incremental-search-backward  # / to search backwards
# bindkey -M vicmd 'n' history-search-forward              # n to continue search forward
# bindkey -M vicmd 'N' history-search-backward             # N to continue search backward
# bindkey -M vicmd 'yy' vi-yank-whole-line    # yy to yank whole line

# Custom text objects and motions could be added here
