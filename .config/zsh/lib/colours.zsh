# $XDG_CONFIG_HOME/zsh/lib/colours.zsh
# Terminal color configuration
# HomeLab Dotfiles - Refactored 2026-01-18

# Load zsh color support
autoload -Uz colors && colors

# Enable ls colors
if command -v dircolors &>/dev/null; then
    # Use custom dircolors if they exist, otherwise use default
    if [[ -f "${XDG_CONFIG_HOME}/dircolors/dircolors" ]]; then
        eval "$(dircolors -b "${XDG_CONFIG_HOME}/dircolors/dircolors")"
    else
        eval "$(dircolors -b)"
    fi
fi

# Standardize LS_COLORS for BSD/macOS compatibility if needed
export CLICOLOR=1
export LS_COLORS="${LS_COLORS:-'di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;42'}"

# Set colors for less and man pages
export LESS_TERMCAP_mb=$'\E[01;31m'      # begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'      # begin bold
export LESS_TERMCAP_me=$'\E[0m'          # end mode
export LESS_TERMCAP_se=$'\E[0m'          # end standout-mode
export LESS_TERMCAP_so=$'\E[01;44;33m'   # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'          # end underline
export LESS_TERMCAP_us=$'\E[01;32m'      # begin underline
