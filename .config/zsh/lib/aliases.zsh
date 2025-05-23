# $XDG_CONFIG_HOME/zsh/lib/aliases.zsh
# Common aliases with modern alternatives
# HomeLab Dotfiles - Created 2025-05-05

# Navigation (use zoxide when available)
if command -v z &>/dev/null; then
  # Defer to zoxide's z command
  :
else
  # Standard directory navigation
  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'
  alias .....='cd ../../../..'
fi

# Use lsd instead of ls when available
if command -v lsd &>/dev/null; then
  alias ls='lsd'
  alias ll='lsd -l'
  alias la='lsd -la'
  alias lt='lsd --tree'
  alias l='lsd -F'
else
  # Fallback to standard ls with colors
  alias ls='ls --color=auto'
  alias ll='ls -lh'
  alias la='ls -lha'
  alias l='ls -CF'
fi

# Use bat instead of cat when available
if command -v bat &>/dev/null; then
  alias cat='bat --style=plain'
  alias catf='bat'  # Full bat with all features
else
  # Fallback (add colors to cat if possible with pygmentize)
  command -v pygmentize &>/dev/null && alias ccat='pygmentize -g'
fi

# Use bpytop/btop instead of top when available
if command -v bpytop &>/dev/null; then
  alias top='bpytop'
elif command -v btop &>/dev/null; then
  alias top='btop'
fi

# Modern alternatives for disk usage
if command -v duf &>/dev/null; then
  alias df='duf'
else
  alias df='df -h'
fi

if command -v dust &>/dev/null; then
  alias du='dust'
else
  alias du='du -h'
fi

# Use tldr for command help when available
if command -v tldr &>/dev/null; then
  alias help='tldr'
fi

# Use prettyping for ping when available
if command -v prettyping &>/dev/null; then
  alias ping='prettyping --nolegend'
fi

# Use fd instead of find when available
command -v fd &>/dev/null && alias find='fd'

# Git shortcuts
alias g='git'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gs='git status'
alias gl='git log --oneline --graph --decorate'

# Use lazygit when available
command -v lazygit &>/dev/null && alias lg='lazygit'

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Directory operations
alias md='mkdir -p'
alias rd='rmdir'

# Editor
alias v='$EDITOR'
alias vi='$EDITOR'
alias vim='$EDITOR'

# Python
alias py='python'
alias ipy='ipython'
alias pipup='pip list --outdated --format=columns | tail -n +3 | cut -d" " -f1 | xargs -n1 pip install -U'

# Poetry
#alias poetry-shell='poetry shell'
alias pn='poetry_new'
alias pi='poetry_init'
alias pv='poetry_venv'
alias pa='poetry add'
alias pad='poetry add --dev'
alias pr='poetry remove'
alias pu='poetry update'
alias ps='poetry shell'
alias prun='poetry run'
alias pi='poetry install'

# Additional useful aliases
alias pshow='poetry show'           # Show all packages
alias pout='poetry show --outdated' # Show outdated packages
alias pcheck='poetry check'         # Validate pyproject.toml
alias penv='poetry env info'        # Show virtual environment info
alias plock='poetry lock'           # Lock dependencies without installing
alias pexport='poetry export'       # Export dependencies to requirements.txt

# Package management - smart detection
# For Fedora/RHEL/CentOS
if command -v dnf &>/dev/null; then
  alias pkgi='sudo dnf install'
  alias pkgs='dnf search'
  alias pkgr='sudo dnf remove'
  alias pkgu='sudo dnf update'
# For Debian/Ubuntu
elif command -v apt &>/dev/null; then
  alias pkgi='sudo apt install'
  alias pkgs='apt search'
  alias pkgr='sudo apt remove'
  alias pkgu='sudo apt update && sudo apt upgrade'
fi

# Podman (Docker API compatible)
alias docker='podman'
alias dk='podman'
alias dkps='podman ps'
alias dkst='podman stats'
alias dki='podman images'

# Network
alias ports='ss -tulanp'
alias myip='curl ifconfig.me'

# System
alias free='free -h'
alias meminfo='free -h'
alias cpuinfo='lscpu'

# Utilities
alias src='source ${ZDOTDIR}/.zshrc'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias today='date +"%Y-%m-%d"'

# Safety measures
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# Project directory quick access
alias cdp='cd $PROJECTS_DIR'
alias cdv='cd $VENVS_DIR'

# Quick edit common config files
alias zshrc='$EDITOR $ZDOTDIR/zshrc'
alias zshenv='$EDITOR $HOME/.zshenv'
alias aliases='$EDITOR $ZDOTDIR/lib/aliases.zsh'
