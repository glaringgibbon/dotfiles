#
# $HOME/.zshenv
#
# This file is bootstraped by ~/.zshenv and is where the real action happens
# This is because ~/.zshenv is not XDG compliant
# If both files aren't in place env vars are overridden and things will break
# Master environment configuration (XDG, PATH, Locale)
# HomeLab Dotfiles - Refactored 2026-01-18
#
# --- XDG Base Directory Specification ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# --- Language Specific Homes (XDG Compliant) ---
# Move these UP so they are set before any path logic
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export GOPATH="${XDG_DATA_HOME}/go"
export GOBIN="${GOPATH}/bin"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
export NPM_CONFIG_INIT_MODULE="${XDG_CONFIG_HOME}/npm/config/npm-init.js"

# --- Zsh Bootstrap ---
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# --- Python Startup ---
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc.py"
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"

# --- Core Editor & Pager ---
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-R --ignore-case --tilde"

# --- Locale ---
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

# --- Path Construction ---
typeset -U path
path=(
    "$HOME/.local/bin"
    "$XDG_DATA_HOME/cargo/bin"
    "$XDG_DATA_HOME/npm/bin"
    $path
)

# --- Tool Specific XDG Overrides ---
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"

