# $XDG_CONFIG_HOME/zsh/lib/prompt.zsh
# ZSH prompt configuration with git and vi-mode awareness
# HomeLab Dotfiles - Refactored 2026-01-18

# --- Initialize Modules ---
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
setopt PROMPT_SUBST

# --- Git Configuration ---
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{green}●%f"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}●%f"
zstyle ':vcs_info:git:*' formats " %F{blue}(%f%F{magenta}%b%f%c%u%F{blue})%f"
zstyle ':vcs_info:git:*' actionformats " %F{blue}(%f%F{magenta}%b%f|%F{red}%a%f%c%u%F{blue})%f"

# --- Prompt Components ---

# Vi-Mode Indicator
vi_mode_indicator() {
    case $KEYMAP in
        vicmd)      echo "%F{yellow}[NORMAL]%f " ;;
        viins|main) echo "%F{cyan}[INSERT]%f "  ;;
    esac
}

# SSH Indicator
ssh_info() {
    [[ -n $SSH_CONNECTION ]] && echo "%F{red}(SSH:%m)%f "
}

# Python VirtualEnv
venv_info() {
    [[ -n "$VIRTUAL_ENV" ]] && echo "%F{blue}($(basename "$VIRTUAL_ENV"))%f "
}

# Command Execution Timer (Right Prompt)
preexec() {
    timer=${timer:-$SECONDS}
}

# --- Main Prompt Hook ---
prompt_precmd() {
    vcs_info

    # Calculate timer for RPROMPT
    if [[ -n ${timer:-} ]]; then
        local timer_show=$(( SECONDS - timer ))
        if (( timer_show > 1 )); then
            RPROMPT="%F{yellow}${timer_show}s%f"
        else
            RPROMPT=""
        fi
        unset timer
    fi
}

# Register precmd hook
add-zsh-hook precmd prompt_precmd

# --- Final Prompt Definition ---
# Format: [MODE] (SSH) (venv) ➜ directory (git) »
PROMPT='$(vi_mode_indicator)$(ssh_info)$(venv_info)%(?:%F{green}➜:%F{red}➜)%f %F{blue}%~%f${vcs_info_msg_0_} %F{white}»%f '

# Root user override
if [[ $UID -eq 0 ]]; then
    PROMPT='%F{red}[ROOT]%f $(ssh_info)%F{blue}%~%f${vcs_info_msg_0_} %F{red}#%f '
fi
