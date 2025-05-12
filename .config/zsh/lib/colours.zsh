# $XDG_CONFIG_HOME/zsh/lib/colours.zsh
# Colour definitions and terminal color support
# HomeLab Dotfiles - Created 2025-05-05

# Enable colour support
autoload -U colors && colors

# Terminal colour capabilities
if [[ -n $DISPLAY ]]; then
  export TERM=${TERM:-xterm-256color}
else
  export TERM=${TERM:-xterm}
fi

# Define standard colour codes if not using the autoloaded ones
typeset -Ag FX FG BG

FX=(
  reset     "%{[00m%}"
  bold      "%{[01m%}" no-bold      "%{[22m%}"
  italic    "%{[03m%}" no-italic    "%{[23m%}"
  underline "%{[04m%}" no-underline "%{[24m%}"
  blink     "%{[05m%}" no-blink     "%{[25m%}"
  reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

# Foreground colours
FG=(
  black   "%{[30m%}"
  red     "%{[31m%}"
  green   "%{[32m%}"
  yellow  "%{[33m%}"
  blue    "%{[34m%}"
  magenta "%{[35m%}"
  cyan    "%{[36m%}"
  white   "%{[37m%}"
  default "%{[39m%}"
)

# Background colours
BG=(
  black   "%{[40m%}"
  red     "%{[41m%}"
  green   "%{[42m%}"
  yellow  "%{[43m%}"
  blue    "%{[44m%}"
  magenta "%{[45m%}"
  cyan    "%{[46m%}"
  white   "%{[47m%}"
  default "%{[49m%}"
)

# Export LS_COLORS for directory listing colours
if command -v dircolors &>/dev/null; then
  if [[ -f "$XDG_CONFIG_HOME/dircolors/dircolors" ]]; then
    eval "$(dircolors -b "$XDG_CONFIG_HOME/dircolors/dircolors")"
  else
    eval "$(dircolors -b)"
  fi
fi

# Configure bat theme if available
if command -v bat &>/dev/null; then
  export BAT_THEME="Monokai Extended"
fi

# Configure lsd theme if applicable
if command -v lsd &>/dev/null; then
  export LSD_THEME="default"
fi

# Color man pages
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
