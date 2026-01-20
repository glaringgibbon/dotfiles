# $XDG_CONFIG_HOME/zsh/lib/environment.zsh
# Interactive environment settings
# HomeLab Dotfiles - Refactored 2026-01-18

# --- Tmux Integration ---
export TMUX_CONFIG_DIR="${XDG_CONFIG_HOME}/tmux"
export TMUX_PLUGIN_MANAGER_PATH="${XDG_DATA_HOME}/tmux/plugins"

# --- Pager/Man Settings ---
# Using less with color support (Variables defined in colours.zsh will apply here)
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# --- Project Management ---
export PROJECTS_DIR="$HOME/projects"
export DOTFILES_DIR="$PROJECTS_DIR/dotfiles"

# --- Container Configuration ---
# DOCKER_HOST is required for many tools to talk to Podman
if command -v podman &>/dev/null; then
    export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
fi

# --- Default Permissions ---
umask 022

# --- Tool Initializations ---
# Note: zoxide and direnv are now handled in their respective modules
# or at the end of .zshrc to ensure they don't slow down the core load.
