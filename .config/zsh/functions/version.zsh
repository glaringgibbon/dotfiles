# $XDG_CONFIG_HOME/zsh/functions/version.zsh

# State file location
LANG_STATE_FILE="${XDG_STATE_HOME}/nvim/lang_state.json"

# Ensure state directory exists
mkdir -p "${XDG_STATE_HOME}/nvim"

# Initialize/read state file
function _init_state_file() {
    if [[ ! -f "${LANG_STATE_FILE}" ]]; then
        echo '{"python":{},"go":{},"rust":{},"node":{}}' > "${LANG_STATE_FILE}"
    fi
}

# Update state file
function _update_state() {
    local lang=$1
    local version=$2
    local provider_path=$3
    
    local temp_file=$(mktemp)
    jq --arg lang "$lang" \
       --arg ver "$version" \
       --arg path "$provider_path" \
       '.[$lang] = {"version": $ver, "provider_path": $path}' \
       "${LANG_STATE_FILE}" > "$temp_file" && mv "$temp_file" "${LANG_STATE_FILE}"
}

# Check Python environment
function check_python_env() {
    _init_state_file
    # Does this gets major, minor and path numbers, Poetry only uses major and minor
    # Refer to original function which only gets major and minor which is what Poetry uses
    local current_version=$(python3 --version | cut -d' ' -f2)
    local stored_version=$(jq -r '.python.version // ""' "${LANG_STATE_FILE}")
    
    if [[ "${current_version}" != "${stored_version}" ]]; then
        echo "Python version changed: ${stored_version} -> ${current_version}"
        
        # Update providers
        # You missed this out - If pipx not updated poetry won't run
        echo "Updating Python virtualenvs..."
        pipx reinstall-all
        
        # Update Poetry and create new Neovim environment
        poetry self update
        poetry config virtualenvs.in-project false
        poetry config virtualenvs.path "${POETRY_VIRTUALENVS_PATH}"
        
        # Create new Neovim environment
        # Why? Poetry should create a new venv using new python version in name 
        # Why? Poetry project not located here, this location is for lua config files
        # Why? Neovim config files are being symlinked here from ~/projects/dotfiles/
        cd "${XDG_CONFIG_HOME}/nvim" || return
        poetry install
        
        # Get new provider path
        local provider_path=$(poetry env info -p)/bin/python
        
        # Update state
        _update_state "python" "${current_version}" "${provider_path}"
    fi
}

# Check Go environment
function check_go_env() {
    if ! command -v go >/dev/null 2>&1; then
        return
    fi
    
    _init_state_file
    
    local current_version=$(go version | cut -d' ' -f3 | sed 's/go//')
    local stored_version=$(jq -r '.go.version // ""' "${LANG_STATE_FILE}")
    
    if [[ "${current_version}" != "${stored_version}" ]]; then
        echo "Go version changed: ${stored_version} -> ${current_version}"
        # Update state - Go doesn't need provider path
        _update_state "go" "${current_version}" ""
    fi
}

# Check Rust environment
function check_rust_env() {
    if ! command -v rustc >/dev/null 2>&1; then
        return
    fi
    
    _init_state_file
    
    local current_version=$(rustc --version | cut -d' ' -f2)
    local stored_version=$(jq -r '.rust.version // ""' "${LANG_STATE_FILE}")
    
    if [[ "${current_version}" != "${stored_version}" ]]; then
        echo "Rust version changed: ${stored_version} -> ${current_version}"
        # Update state - Rust doesn't need provider path
        _update_state "rust" "${current_version}" ""
    fi
}

# Check Node environment
function check_node_env() {
    if ! command -v node >/dev/null 2>&1; then
        return
    fi
    
    _init_state_file
    
    local current_version=$(node --version | sed 's/v//')
    local stored_version=$(jq -r '.node.version // ""' "${LANG_STATE_FILE}")
    
    if [[ "${current_version}" != "${stored_version}" ]]; then
        echo "Node version changed: ${stored_version} -> ${current_version}"
        # Install/Update neovim package globally
        npm install -g neovim
        
        # Update state with provider path
        local provider_path="${NPM_CONFIG_PREFIX}/bin/neovim-node-host"
        _update_state "node" "${current_version}" "${provider_path}"
    fi
}

# Main check function
function check_lang_versions() {
    check_python_env
    check_go_env
    check_rust_env
    check_node_env
}
# Original version left here for you to consider and compare
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
