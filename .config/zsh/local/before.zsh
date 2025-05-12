# $XDG_CONFIG_HOME/zsh/local/before.zsh
# Local machine configuration that runs BEFORE main config loads
# HomeLab Dotfiles - Created 2025-05-05

# This file is loaded before any other configuration scripts
# Use it for machine-specific environment variables, paths, and settings
# This file is included in .gitignore and should not be committed

# ==== EXAMPLES (uncomment and modify as needed) ====

# == Machine-specific PATH additions ==
# export PATH="$HOME/local/bin:$PATH"

# == Machine-specific environment variables ==
# export CUSTOM_VAR="value"

# == Override system defaults ==
# export EDITOR="nano"  # Override default editor
# export VISUAL="code"  # Override default visual editor

# == Node.js version manager ==
# export NVM_DIR="$XDG_DATA_HOME/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# == Ruby version manager ==
# export RBENV_ROOT="$XDG_DATA_HOME/rbenv"
# if [ -d "$RBENV_ROOT" ]; then
#   export PATH="$RBENV_ROOT/bin:$PATH"
#   eval "$(rbenv init -)"
# fi

# == Python environment ==
# export PYTHONPATH="$HOME/projects/python:$PYTHONPATH"
# export VIRTUAL_ENV_DISABLE_PROMPT=1

# == Java configuration ==
# export JAVA_HOME="/usr/lib/jvm/default-java"
# export PATH="$JAVA_HOME/bin:$PATH"

# == Docker configuration ==
# export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
# export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"

# == Machine-specific proxy settings ==
# export http_proxy="http://proxy.example.com:8080"
# export https_proxy="http://proxy.example.com:8080"
# export no_proxy="localhost,127.0.0.1"

# == Machine-specific aliases ==
# alias proj="cd ~/projects/main"
# alias vpn="sudo openvpn --config $HOME/.config/vpn/config.ovpn"

# === End of examples ===

# Add your machine-specific configuration below
