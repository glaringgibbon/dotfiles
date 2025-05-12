# In conf.d/multiplexer.zsh
function ensure_tmux() {
    # Don't nest tmux sessions
    if [[ -n "$TMUX" ]]; then
        return
    fi

    # Don't start tmux in specific situations
    if [[ "$TERM" = "dumb" ]] || [[ -n "$EMACS" ]] || [[ -n "$VIM" ]]; then
        return
    fi

    # Start or attach to session
    if command -v tmux &> /dev/null; then
        if tmux has-session 2>/dev/null; then
            exec tmux attach
        else
            exec tmux new-session
        fi
    fi
}

# Can be controlled via environment variable
if [[ "${AUTO_TMUX:-yes}" = "yes" ]]; then
    ensure_tmux
fi
