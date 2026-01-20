# $XDG_CONFIG_HOME/zsh/tools/update.zsh
# System and Dotfiles update utility
# HomeLab Dotfiles - Refactored 2026-01-18

function dotfiles_update() {
    echo "--- Updating Zsh Plugins ---"
    # This calls the function we defined in modules/plugins.zsh
    local plugins=(
        "zsh-users/zsh-completions"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
    )
    for p in $plugins; do
        plugin_install "$p"
    done

    echo "\n--- Updating System Packages ---"
    sudo dnf upgrade --refresh

    echo "\n--- Updating Neovim (Lazy) ---"
    nvim --headless "+Lazy! sync" +qa

    echo "\n--- Cleaning Cache ---"
    rm -f "${XDG_CACHE_HOME}/zsh/zcompdump-"*
    
    echo "\nUpdate Complete."
}

# If script is run directly, execute the update
if [[ "${ZSH_EVAL_CONTEXT}" == "toplevel" ]]; then
    dotfiles_update
fi
