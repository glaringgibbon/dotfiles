#!/usr/bin/env zsh

# Manual language version check and update utility
# Use when automatic updates fail or manual intervention needed

function manual_python_update() {
    local version=${1:-$SYSTEM_PYTHON_VERSION}
    cd "${PROJECTS_DIR}/neovim" || return 1
    
    echo "Manually updating Python environment for version ${version}..."
    poetry env use "python${version}"
    poetry update
    
    echo "Updating Python providers..."
    pipx reinstall-all
    
    # Force state update
    check_python_env
}

function manual_node_update() {
    echo "Manually updating Node.js providers..."
    npm install -g neovim
    
    # Force state update
    check_node_env
}

function manual_update_all() {
    manual_python_update
    manual_node_update
    check_go_env
    check_rust_env
}

# Parse command line arguments
case "$1" in
    python)
        manual_python_update "$2"
        ;;
    node)
        manual_node_update
        ;;
    all)
        manual_update_all
        ;;
    *)
        echo "Usage: update.zsh [python|node|all] [python-version]"
        echo "Examples:"
        echo "  update.zsh python 3.13    # Update to specific Python version"
        echo "  update.zsh python         # Update using SYSTEM_PYTHON_VERSION"
        echo "  update.zsh node           # Update Node.js providers"
        echo "  update.zsh all            # Update all languages"
        ;;
esac
