# $XDG_CONFIG_HOME/zsh/lib/key-bindings.zsh
# Key bindings and Vi-mode configuration
# HomeLab Dotfiles - Refactored 2026-01-18

# Enable Vi-mode
bindkey -v
export KEYTIMEOUT=1

# --- Cursor Shape Logic ---
# 2 = Block (Normal), 6 = Beam (Insert)
function cursor_mode() {
    case $KEYMAP in
        vicmd)      echo -ne "\e[2 q" ;; # Block
        viins|main) echo -ne "\e[6 q" ;; # Beam
    esac
}

# Initialize cursor and hooks
zle -N zle-keymap-select
zle-keymap-select() { cursor_mode; zle reset-prompt }

zle -N zle-line-init
zle-line-init() { cursor_mode }

# Reset cursor to beam on exit
zshexit_reset_cursor() {
    echo -ne "\e[5 q"
}

autoload -Uz add-zsh-hook
add-zsh-hook zshexit zshexit_reset_cursor

# --- Standard Key Fixes ---
# Ensure common keys work regardless of terminfo quirks
bindkey '^[[H'  beginning-of-line      # Home
bindkey '^[[F'  end-of-line            # End
bindkey '^[[3~' delete-char            # Delete
bindkey '^?'    backward-delete-char   # Backspace
bindkey '^[[A'  up-line-or-history     # Up
bindkey '^[[B'  down-line-or-history   # Down

# --- Vi-Mode Enhancements ---
# Better searching in history
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'j' down-line-or-history
bindkey '^R' history-incremental-pattern-search-backward

# Edit command line in $EDITOR with 'v' in normal mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Allow backspace to work past the start of insert mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
