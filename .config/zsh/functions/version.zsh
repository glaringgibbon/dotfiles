


function version_update() {
    local current_version=$(python3 --version | sed 's/Python //')
    local major_minor=$(echo "$current_version" | cut -d. -f1-2)
    local state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
    local state_file="$state_dir/provider_state.json"
    
    # Read current state
    local stored_version=""
    if [[ -f "$state_file" ]]; then
        stored_version=$(jq -r '.python.version // empty' "$state_file")
    fi
    
    if [[ "$current_version" != "$stored_version" ]]; then
        echo "Python version changed from $stored_version to $current_version"
        
        # Update providers
        echo "Updating Python providers..."
        pipx reinstall-all
        
        cd ~/projects/neovim
        poetry env use python3
        poetry update
        
        # Update state file and environment variables
        local provider_path="$HOME/projects/venvs/poetry/neovim-GkWJIk93-py${major_minor}/bin/python"
        mkdir -p "$state_dir"
        
        # Update state file
        jq -n \
            --arg version "$current_version" \
            --arg provider "$provider_path" \
            '{"python":{"version":$version,"provider_path":$provider}}' > "$state_file"
            
        # Export environment variables
        export SYSTEM_PYTHON_VERSION="$current_version"
        export NVIM_PYTHON_PROVIDER="$provider_path"
        
        # Update environment.zsh with new values
        local env_file="${ZDOTDIR}/lib/environment.zsh"
        sed -i "s/^export SYSTEM_PYTHON_VERSION=.*/export SYSTEM_PYTHON_VERSION=\"$current_version\"/" "$env_file"
        sed -i "s|^export NVIM_PYTHON_PROVIDER=.*|export NVIM_PYTHON_PROVIDER=\"$provider_path\"|" "$env_file"
        
        echo "Provider updates complete"
    fi
}
