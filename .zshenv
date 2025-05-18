# $HOME/.zshenv
# Minimal bootstrap for XDG compliance

# Set XDG Base Directory paths
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Set ZDOTDIR to prevent zsh setup wizard
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Prevent double-sourcing in subshells
if [[ ! -v ZDOTDIR_INITIALIZED ]]; then
    export ZDOTDIR_INITIALIZED=1
    
    # Source profile for login shells
    if [[ -o login ]]; then
        [[ -f "$ZDOTDIR/.zprofile" ]] && source "$ZDOTDIR/.zprofile"
    fi
    
    # Source zshrc for interactive shells
    if [[ -o interactive ]]; then
        [[ -f "$ZDOTDIR/.zshrc" ]] && source "$ZDOTDIR/.zshrc"
    fi
fi
