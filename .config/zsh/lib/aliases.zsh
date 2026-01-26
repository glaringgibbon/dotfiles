# $XDG_CONFIG_HOME/zsh/lib/aliases.zsh
# General and tool-specific aliases
# HomeLab Dotfiles - Refactored 2026-01-18

# --- Safety First ---
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# --- Navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# --- Standard Tool Enhancements ---
alias ls='ls --color=auto -F'
alias ll='ls -lh'
alias la='ls -lAh'
alias l='ls -CF'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

alias df='df -h'
alias du='du -h'
alias free='free -m'

# --- Modern Tool Replacements ---
# Only alias if the tool is actually installed
command -v nvim  &>/dev/null && alias vim='nvim' && alias v='nvim'
command -v bat   &>/dev/null && alias cat='bat'
command -v eza   &>/dev/null && alias ls='eza --icons --group-directories-first' && alias ll='eza -lh --icons'
command -v fd    &>/dev/null && alias find='fd'
command -v dust  &>/dev/null && alias du='dust'
command -v procs &>/dev/null && alias ps='procs'
# Don't use this any more, rg is rg and grep s grep, it fucks up zsh if you do
# rg and grep have different regex engines and grep is used by the system itself
##command -v rg    &>/dev/null && alias grep='rg'

# --- Zsh Specific ---
alias zconf='nvim "${ZDOTDIR}/.zshrc"'
alias history='fc -li'

# --- Development & Helpers ---
alias py='python3'
alias ipy='ipython'
alias ip='ip -color=auto'

# GNU Stow helpers
alias stowd='cd ~/projects/dotfiles'

# kitty
alias icat='kitten icat'

# TUIs
alias lg='lazygit'
alias fm='yazi'
