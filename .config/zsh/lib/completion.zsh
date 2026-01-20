# $XDG_CONFIG_HOME/zsh/lib/completion.zsh
# Completion system configuration
# HomeLab Dotfiles - Refactored 2026-01-18

# --- Initialize Completion ---
# Load compinit and use a cache file for speed
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"

# --- General Completion Styles ---
# Use a menu for selection
zstyle ':completion:*' menu select

# Case-insensitive (all), then partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group results by category
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-dirs-first true

# Descriptions for groups
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# Colors for files and directories (uses $LS_COLORS)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# --- Specific Tool Tweaks ---
# Don't complete parent directory (..)
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Kill command: better process list
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# SSH/SCP: use known_hosts and config for completion
[[ -r ~/.ssh/config ]] && _ssh_config_hosts=(${${(f)"$(grep -i '^Host' ~/.ssh/config | grep -v '*')"}#Host }) || _ssh_config_hosts=()
[[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${(f)"$(cat ~/.ssh/known_hosts)"}%%[ , ]*}#\[}) || _ssh_hosts=()
zstyle ':completion:*:hosts' hosts $_ssh_config_hosts $_ssh_hosts

# --- Caching ---
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"
