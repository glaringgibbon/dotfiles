# $XDG_CONFIG_HOME/zsh/local/after.zsh
# Local machine configuration that runs AFTER main config loads
# HomeLab Dotfiles - Created 2025-05-05

# This file is loaded after all other configuration scripts
# Use it to override settings, add machine-specific functions, or load 
# additional tools specific to this machine
# This file is included in .gitignore and should not be committed

# ==== EXAMPLES (uncomment and modify as needed) ====

# == Override aliases set in the main configuration ==
# alias ls="ls --color=auto -F"  # Override the ls alias

# == Load machine-specific plugins ==
# plugin "zsh-users/zsh-autosuggestions"
# plugin "zsh-users/zsh-syntax-highlighting"

# == Add machine-specific completions ==
# if [ -d "$HOME/path/to/completions" ]; then
#   fpath=("$HOME/path/to/completions" $fpath)
#   compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"
# fi

# == Custom welcome message ==
# echo "Welcome back to $(hostname)!"

# == Machine-specific functions ==
# function project() {
#   cd "$HOME/projects/$1" || return
# }

# == Load conda environment ==
# if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
#   source "$HOME/miniconda3/etc/profile.d/conda.sh"
# fi

# == Load custom dircolors ==
# if [ -f "$XDG_CONFIG_HOME/dircolors/dircolors" ]; then
#   eval "$(dircolors -b "$XDG_CONFIG_HOME/dircolors/dircolors")"
# fi

# == Machine-specific keyboard settings ==
# if command -v setxkbmap > /dev/null; then
#   setxkbmap -option caps:escape
# fi

# == Load work-specific configurations ==
# if [ -f "$XDG_CONFIG_HOME/zsh/local/work.zsh" ]; then
#   source "$XDG_CONFIG_HOME/zsh/local/work.zsh"
# fi

# == Load project-specific environment variables ==
# if [ -f "$HOME/projects/main/.env" ]; then
#   source "$HOME/projects/main/.env"
# fi

# === End of examples ===

# Add your machine-specific configuration below
