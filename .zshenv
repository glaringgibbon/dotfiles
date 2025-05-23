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

# Language-specific base paths
# I have moved these paths here instead of in environment.zsh
# This file is for setting env vars, I figure the earlier the better
# This python version will included major, minor and patch
# See my note about this issue in environment.zsh
# Python - always needed as it's a system requirement
export SYSTEM_PYTHON_VERSION=$(python3 --version | cut -d " " -f2)

# Go - conditional setup
if command -v go >/dev/null 2>&1; then
    export GOPATH="${HOME}/go"
    export GOBIN="${GOPATH}/bin"
    export PATH="${GOBIN}:${PATH}"
fi

# Rust - conditional setup
if command -v rustc >/dev/null 2>&1; then
    export CARGO_HOME="${XDG_DATA_HOME}/cargo"
    export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
    export PATH="${CARGO_HOME}/bin:${PATH}"
fi

# Node.js - conditional setup
if command -v node >/dev/null 2>&1; then
    # Default npm cache directory
    export NPM_CONFIG_CACHE="${HOME}/.npm"
    # Global installations directory (for -g flag)
    export NPM_CONFIG_PREFIX="${HOME}/.npm-global"
    # Add global bin to PATH
    export PATH="${NPM_CONFIG_PREFIX}/bin:${PATH}"
fi

# Source the main zsh config only for interactive shells
# This prevents sourcing .zshrc for non-interactive shells, improving performance
if [[ -o interactive ]]; then
  [[ -f "$ZDOTDIR/zshrc" ]] && source "$ZDOTDIR/zshrc"
fi
