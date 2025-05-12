# $XDG_CONFIG_HOME/zsh/lib/xdg.zsh
# XDG Base Directory specification compliance
# HomeLab Dotfiles - Created 2025-05-05

# Ensure XDG directories exist
mkdir -p "${XDG_CONFIG_HOME}" "${XDG_CACHE_HOME}" "${XDG_DATA_HOME}" "${XDG_STATE_HOME}"

# Move dotfiles to XDG directories
# ----- ZSH -----
# History (already handled in history.zsh)
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

# ----- General Tools -----
# Less
export LESSKEY="${XDG_CONFIG_HOME}/less/lesskey"
export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
mkdir -p "$(dirname "$LESSHISTFILE")"

# Wget
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"
[[ -d "$(dirname "$WGETRC")" ]] || mkdir -p "$(dirname "$WGETRC")"
[[ -f "$WGETRC" ]] || touch "$WGETRC"

# ----- Languages & Development -----
# Python
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc.py"
mkdir -p "$(dirname "$PYTHONSTARTUP")"
# Ensure pip uses XDG directories
export PIP_CONFIG_FILE="${XDG_CONFIG_HOME}/pip/pip.conf"
export PIP_LOG_FILE="${XDG_DATA_HOME}/pip/log"
mkdir -p "$(dirname "$PIP_CONFIG_FILE")" "$(dirname "$PIP_LOG_FILE")"

# Node.js
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node/repl_history"
mkdir -p "$(dirname "$NPM_CONFIG_USERCONFIG")" "$(dirname "$NODE_REPL_HISTORY")"

# Go
export GOPATH="${XDG_DATA_HOME}/go"
mkdir -p "$GOPATH"

# Rust
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
mkdir -p "$RUSTUP_HOME" "$CARGO_HOME"
[[ -f "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"

# ----- Applications -----
# SSH
export SSH_CONFIG_HOME="${XDG_CONFIG_HOME}/ssh"
if [[ ! -d "$SSH_CONFIG_HOME" && -d "$HOME/.ssh" ]]; then
  # Don't move existing SSH config, just make note
  echo "Note: Consider moving ~/.ssh to $SSH_CONFIG_HOME"
fi

# GnuPG
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
mkdir -p "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

# Docker
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
mkdir -p "$DOCKER_CONFIG"

# AWS CLI
export AWS_SHARED_CREDENTIALS_FILE="${XDG_CONFIG_HOME}/aws/credentials"
export AWS_CONFIG_FILE="${XDG_CONFIG_HOME}/aws/config"
mkdir -p "$(dirname "$AWS_CONFIG_FILE")"

# kubectl
export KUBECONFIG="${XDG_CONFIG_HOME}/kube/config"
mkdir -p "$(dirname "$KUBECONFIG")"

# Git - partial XDG support
if [[ ! -f "$HOME/.gitconfig" && -f "${XDG_CONFIG_HOME}/git/config" ]]; then
  export GIT_CONFIG_GLOBAL="${XDG_CONFIG_HOME}/git/config"
fi
