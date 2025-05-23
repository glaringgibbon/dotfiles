# $XDG_CONFIG_HOME/zsh/lib/environment.zsh
# Environment variable settings
# HomeLab Dotfiles - Created 2025-05-05
# NOTE: System python and Neovim provider env vars are set in functions/version.

# Editor settings
export EDITOR="nvim"
export VISUAL="nvim"

# I think this is a better place for Tmux integration
# Tmux XDG compliance
export TMUX_CONFIG_DIR="${XDG_CONFIG_HOME}/tmux"
export TMUX_PLUGIN_MANAGER_PATH="${XDG_CONFIG_HOME}/tmux/plugins"

# Set locale if not already set
export LANG="${LANG:-en_GB.UTF-8}"
export LC_ALL="${LC_ALL:-en_GB.UTF-8}"

# Pager/less settings
export PAGER="less"
export LESS="-R --ignore-case --tilde"

# Set man pager with colors
# Using less with color support
export MANPAGER="less -R --use-color -Dd+r -Du+b"
# Optional: Use neovim as manpager (commented out by default)
# export MANPAGER="nvim +Man!"

# Add user's local bin to PATH (high priority)
export PATH="$HOME/.local/bin:$PATH"

# This is only required where development undertaken
# Should this be in local config on per host basis?
# Set project directory
export PROJECTS_DIR="$HOME/projects"
export VENVS_DIR="$PROJECTS_DIR/venvs"

# Python Poetry path
# Poetry path not needed as pipx handles this for us
#export PATH="$HOME/.local/share/pypoetry/venv/bin:$PATH"
export POETRY_CONFIG_DIR="${XDG_CONFIG_HOME}/poetry"
export POETRY_CACHE_DIR="${XDG_CACHE_HOME}/poetry"
export POETRY_DATA_DIR="${XDG_DATA_HOME}/poetry"
# Your path here is not accurate, I have added the correct location underneath
#export POETRY_VIRTUALENVS_PATH="${XDG_DATA_HOME}/poetry/virtualenvs"
export POETRY_VIRTUALENVS_PATH="${VENVS_DIR}/poetry/"

# Podman/container configuration
# Originally the values for these two were the other way around
# Claude seems to think CONTAINER_HOST is redundant, that podman knows what to do already
# That's why it is commented out for now
# DOCKER_HOST is temporary, may or may not need it
#export CONTAINER_HOST="podman"
export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"

# Set default permissions for new files
umask 022

# Optional direnv integration
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

# Configure zoxide if available
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Configure fzf if installed
[[ -f "${XDG_CONFIG_HOME}/fzf/fzf.zsh" ]] && source "${XDG_CONFIG_HOME}/fzf/fzf.zsh"
