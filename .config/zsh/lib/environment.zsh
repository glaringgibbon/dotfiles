# $XDG_CONFIG_HOME/zsh/lib/environment.zsh
# Environment variable settings
# HomeLab Dotfiles - Created 2025-05-05

# Editor settings
export EDITOR="nvim"
export VISUAL="nvim"

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

# Python Poetry path
export PATH="$HOME/.local/share/pypoetry/venv/bin:$PATH"

# Podman/container configuration
export CONTAINER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
export DOCKER_HOST="$CONTAINER_HOST"

# Set default permissions for new files
umask 022

# Set project directory
export PROJECTS_DIR="$HOME/projects"
export VENVS_DIR="$PROJECTS_DIR/venvs"

# Optional direnv integration
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

# Add rust binaries to path if they exist
[[ -d "$CARGO_HOME/bin" ]] && export PATH="$CARGO_HOME/bin:$PATH"

# Add go binaries to path if they exist
[[ -d "$GOPATH/bin" ]] && export PATH="$GOPATH/bin:$PATH"

# Configure zoxide if available
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Configure fzf if installed
[[ -f "${XDG_CONFIG_HOME}/fzf/fzf.zsh" ]] && source "${XDG_CONFIG_HOME}/fzf/fzf.zsh"
