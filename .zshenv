#
# $HOME/.zshenv
#
# Master environment configuration (XDG, PATH, Locale)
# HomeLab Dotfiles - Refactored 2026-01-18
#

# --- XDG Base Directory Specification ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# --- Zsh Bootstrap ---
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# --- Python Startup ---
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/pythonrc.py"
export IPYTHONDIR="${XDG_CONFIG_HOME:-$HOME/.config}/ipython"

# --- Core Editor & Pager ---
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R --ignore-case --tilde"

# --- Locale ---
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

# --- Path Construction ---
# Start with a clean slate and add high-priority paths
typeset -U path  # Ensure path only contains unique entries
path=(
    $HOME/.local/bin
    $XDG_DATA_HOME/cargo/bin
    $XDG_DATA_HOME/npm/bin
    $path
)

# --- Language Specific Homes (XDG Compliant) ---
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export GOPATH="${XDG_DATA_HOME}/go"
export GOBIN="${GOPATH}/bin"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"

# --- Tool Specific XDG Overrides ---
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc.py"

# Note: We do NOT source .zshrc here. Zsh handles this automatically for interactive shells.
