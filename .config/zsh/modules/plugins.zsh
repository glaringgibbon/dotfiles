# $XDG_CONFIG_HOME/zsh/modules/plugins.zsh
# Lightweight plugin loader with system package priority
# HomeLab Dotfiles - Refactored 2026-01-18

PLUGIN_DIR="${XDG_DATA_HOME}/zsh/plugins"
[[ -d "$PLUGIN_DIR" ]] || mkdir -p "$PLUGIN_DIR"

# Map of GitHub repos to system package names
declare -A PLUGIN_SYSTEM_MAP=(
    ["zsh-users/zsh-syntax-highlighting"]="zsh-syntax-highlighting"
    ["zsh-users/zsh-autosuggestions"]="zsh-autosuggestions"
    ["zsh-users/zsh-completions"]="zsh-completions"
)

# Internal function to load a plugin file
function _plugin_load_file() {
    [[ -f "$1" ]] && source "$1" && return 0
    return 1
}

# Main plugin loader
function plugin() {
    local repo="$1"
    local name="${repo#*/}"
    local sys_pkg="${PLUGIN_SYSTEM_MAP[$repo]}"
    
    # 1. Try System Package Path (Fedora/RHEL/Debian common paths)
    local sys_paths=(
        "/usr/share/zsh/plugins/$name/$name.plugin.zsh"
        "/usr/share/zsh/plugins/$name/$name.zsh"
        "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    )
    
    for p in $sys_paths; do
        _plugin_load_file "$p" && return 0
    done

    # 2. Try Local Git Clone
    local git_dir="${PLUGIN_DIR}/${name}"
    if [[ -d "$git_dir" ]]; then
        _plugin_load_file "$git_dir/$name.plugin.zsh" || \
        _plugin_load_file "$git_dir/$name.zsh" || \
        _plugin_load_file "$git_dir/init.zsh"
        return 0
    fi

    # 3. If not found, do nothing (don't stall startup)
    # Use 'plugin_install' manually to fetch missing plugins
    return 1
}

# Manual helper to install/update plugins
function plugin_install() {
    local repo="$1"
    local name="${repo#*/}"
    local git_dir="${PLUGIN_DIR}/${name}"
    
    if [[ -d "$git_dir" ]]; then
        echo "Updating $name..."
        (cd "$git_dir" && git pull)
    else
        echo "Installing $name..."
        git clone --depth 1 "https://github.com/${repo}.git" "$git_dir"
    fi
}

# --- Load Plugins ---
plugin "zsh-users/zsh-completions"
plugin "zsh-users/zsh-autosuggestions"
plugin "zsh-users/zsh-syntax-highlighting"
