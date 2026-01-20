# $XDG_CONFIG_HOME/zsh/lib/terminal.zsh
# Terminal-specific settings and window titles
# HomeLab Dotfiles - Refactored 2026-01-18

# Function to set window title
function set_window_title() {
    local title_prefix=""
    [[ -n "$SSH_CLIENT" ]] && title_prefix="%m: "
    print -Pn "\e]0;${title_prefix}%~: $1\a"
}

# Hooks for title updates
autoload -Uz add-zsh-hook
add-zsh-hook precmd  () { set_window_title "zsh" }
add-zsh-hook preexec () { set_window_title "$1" }

# Terminal-specific fixes
case "$TERM" in
    xterm*|alacritty|kitty|foot)
        # Enable bracketed paste mode for modern terminals
        printf "\e[?2004h"
        ;;
    linux)
        # Disable cursor blinking on the actual TTY console
        printf "\e[?1c"
        ;;
esac

# Ensure terminal is in a sane state on exit
ttyctl -f
