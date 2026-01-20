# $XDG_CONFIG_HOME/zsh/modules/multiplexer.zsh
# Safe tmux autostart logic
# HomeLab Dotfiles - Refactored 2026-01-18

function ensure_tmux() {
    # Exit if already in tmux, or if not an interactive TTY
    [[ -n "$TMUX" ]] && return
    [[ ! -t 0 ]] && return
    
    # Exit if in a restricted environment
    [[ "$TERM" == "dumb" ]] && return
    [[ -n "$VIM" || -n "$NVIM" ]] && return
    
    # Only autostart if tmux is installed
    if command -v tmux &>/dev/null; then
        # Attach to 'main' session or create it
        exec tmux new-session -A -s main
    fi
}

# Controlled by env var (default to no for safety during refactor)
if [[ "${AUTO_TMUX:-no}" == "yes" ]]; then
    ensure_tmux
fi
