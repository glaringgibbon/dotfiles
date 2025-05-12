#
# $HOME/.zshenv
#
# Minimal bootstrap file for XDG compliance
# HomeLab Dotfiles - Created 2025-05-05#
#
# Set XDG Base Directory paths if not already defined
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Set zsh-specific XDG paths
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Source the main zsh config only for interactive shells
# This prevents sourcing .zshrc for non-interactive shells, improving performance
if [[ -o interactive ]]; then
  [[ -f "$ZDOTDIR/zshrc" ]] && source "$ZDOTDIR/zshrc"
fi
