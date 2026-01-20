#
# $XDG_CONFIG_HOME/zsh/.zshrc
#
# Main interactive shell orchestrator
# HomeLab Dotfiles - Refactored 2026-01-18
#

# --- 01. Performance Profiling ---
# Toggle with ZSH_PROFILE=1 zsh
[[ -f "${ZDOTDIR}/tools/profile.zsh" ]] && source "${ZDOTDIR}/tools/profile.zsh"

# --- 02. Local Pre-Configuration ---
[[ -f "${ZDOTDIR}/local/before.zsh" ]] && source "${ZDOTDIR}/local/before.zsh"

# --- 03. Core Library Loading ---
# Order is important: core settings first, then UI/UX
for lib_module in core colours terminal key-bindings history completion aliases prompt; do
    if [[ -f "${ZDOTDIR}/lib/${lib_module}.zsh" ]]; then
        source "${ZDOTDIR}/lib/${lib_module}.zsh"
    else
        echo "Warning: Library ${lib_module} not found"
    fi
done

# --- 04. Function Autoloading ---
# Instead of sourcing every function, we tell Zsh where to find them.
# This makes startup significantly faster.
fpath=("${ZDOTDIR}/functions" $fpath)
autoload -Uz mkcd extract duh ff fd ftext weather myip sysinfo dirsize pskill pyvenv genpass backup zedit zreload

# --- 05. Module Loading ---
# Plugins first, then integrations
[[ -f "${ZDOTDIR}/modules/plugins.zsh" ]] && source "${ZDOTDIR}/modules/plugins.zsh"

for mod in direnv fzf git gpg ssh multiplexer; do
    [[ -f "${ZDOTDIR}/modules/${mod}.zsh" ]] && source "${ZDOTDIR}/modules/${mod}.zsh"
done

# --- 06. Local Post-Configuration ---
[[ -f "${ZDOTDIR}/local/after.zsh" ]] && source "${ZDOTDIR}/local/after.zsh"

# --- 07. Final Interactive Tweaks ---
# Wayland clipboard fallback
if command -v wl-copy &> /dev/null; then  
    alias pbcopy='wl-copy'  
    alias pbpaste='wl-paste'  
fi

# Initialize tools that require shell hooks (if not already in modules)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
