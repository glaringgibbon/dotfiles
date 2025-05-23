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
    
    local major_minor=$(echo "${SYSTEM_PYTHON_VERSION}" | cut -d. -f1-2)
    local stored_version=$(jq -r '.python.version // ""' "${LANG_STATE_FILE}")
    
    if [[ "${SYSTEM_PYTHON_VERSION}" != "${stored_version}" ]]; then
        echo "Python version changed: ${stored_version} -> ${SYSTEM_PYTHON_VERSION}"
        
        # Update providers
        echo "Updating Python virtualenvs..."
        pipx reinstall-all
        
        # Update Poetry
        poetry self update
        
        # Get provider path
        local provider_path="${POETRY_VIRTUALENVS_PATH}/neovim-*/py${major_minor}/bin/python"
        if [[ ! -f ${provider_path} ]]; then
            echo "Failed to find Python provider path"
            return 1
        fi
        
        # Update state
        _update_state "python" "${SYSTEM_PYTHON_VERSION}" "${provider_path}"
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
        
        # Update Go tools if needed
        if [[ -d "${GOPATH}" ]]; then
            echo "Updating Go tools..."
            cd "${GOPATH}" || return
            go get -u all
        fi
        
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
        
        # Update Rust tools if needed
        if [[ -d "${CARGO_HOME}" ]]; then
            echo "Updating Rust tools..."
            cd "${CARGO_HOME}" || return
            cargo update
        fi
        
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
        npm update -g neovim
        
        # Update state with provider path
        local provider_path="${HOME}/.npm-global/bin/neovim-node-host"
        if [[ ! -f ${provider_path} ]]; then
            echo "Failed to find Node provider path"
            return 1
        fi
        
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
