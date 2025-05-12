# $XDG_CONFIG_HOME/zsh/modules/plugins.zsh
# Plugin management system that prioritizes system packages
# HomeLab Dotfiles - Updated 2025-05-06

# This plugin manager:
# 1. Checks if plugins are available as system packages first
# 2. Falls back to GitHub repositories if not available
# 3. Manages plugin installation, loading, and updates

# Ensure plugin directories exist
PLUGIN_DIR="${XDG_DATA_HOME}/zsh/plugins"
[[ -d "$PLUGIN_DIR" ]] || mkdir -p "$PLUGIN_DIR"

# Map of common plugins to their system package names (for Fedora/RHEL)
# Format: "github_user/repo_name:system_package_name"
declare -A PLUGIN_SYSTEM_MAP=(
  ["zsh-users/zsh-syntax-highlighting"]="zsh-syntax-highlighting"
  ["zsh-users/zsh-autosuggestions"]="zsh-autosuggestions"
  ["zdharma-continuum/fast-syntax-highlighting"]="zsh-fast-syntax-highlighting"
  ["zsh-users/zsh-completions"]="zsh-completions"
)

# Function to check if a system package is installed
function is_package_installed() {
  local package="$1"
  
  # Different package managers for different distros
  if command -v rpm &>/dev/null; then
    rpm -q "$package" &>/dev/null
    return $?
  elif command -v dpkg &>/dev/null; then
    dpkg -l "$package" &>/dev/null
    return $?
  else
    # Default to not installed if package manager unknown
    return 1
  fi
}

# Function to check if package is available in repositories
function is_package_available() {
  local package="$1"
  
  # Different package managers for different distros
  if command -v dnf &>/dev/null; then
    dnf list available "$package" &>/dev/null
    return $?
  elif command -v apt-cache &>/dev/null; then
    apt-cache show "$package" &>/dev/null
    return $?
  else
    # Default to not available if package manager unknown
    return 1
  fi
}

# Function to find system package path
function get_system_package_path() {
  local package="$1"
  local file_pattern="$2"
  
  # For Fedora/RHEL systems
  if command -v rpm &>/dev/null; then
    local files=($(rpm -ql "$package" | grep -E "$file_pattern"))
    if [[ ${#files[@]} -gt 0 ]]; then
      echo "${files[0]}"
      return 0
    fi
  # For Debian-based systems
  elif command -v dpkg &>/dev/null; then
    local files=($(dpkg -L "$package" | grep -E "$file_pattern"))
    if [[ ${#files[@]} -gt 0 ]]; then
      echo "${files[0]}"
      return 0
    fi
  fi
  
  return 1
}

# Function to install a system package
function install_system_package() {
  local package="$1"
  
  echo "Installing system package: $package"
  
  # Different package managers for different distros  
  if command -v dnf &>/dev/null; then
    sudo dnf install -y "$package"
    return $?
  elif command -v apt-get &>/dev/null; then
    sudo apt-get install -y "$package"
    return $?
  else
    echo "No supported package manager found"
    return 1
  fi
}

# Function to install/update plugins from git
function plugin_install() {
  local plugin_name plugin_url plugin_dir
  
  # Parse args: plugin_install "user/repo" [branch]
  if [[ "$1" =~ ^([^/]+)/(.+)$ ]]; then
    plugin_name="${1#*/}"
    plugin_url="https://github.com/$1.git"
  else
    echo "Invalid plugin format. Use: plugin_install user/repo [branch]"
    return 1
  fi
  
  plugin_dir="${PLUGIN_DIR}/${plugin_name}"
  local branch="${2:-master}"
  
  # Check if plugin directory exists
  if [[ -d "$plugin_dir" ]]; then
    echo "Updating plugin: $plugin_name"
    (cd "$plugin_dir" && git pull origin "$branch" --quiet)
  else
    echo "Installing plugin: $plugin_name from GitHub"
    git clone --quiet --depth 1 "$plugin_url" --branch "$branch" "$plugin_dir"
  fi
}

# Function to load a plugin from system package
function plugin_load_system() {
  local package="$1"
  local plugin_name="${2#*/}"
  
  # Common paths patterns for plugin main files
  local patterns=(
    "/usr/share/zsh/plugins/$plugin_name/$plugin_name.plugin.zsh"
    "/usr/share/zsh/plugins/$plugin_name/$plugin_name.zsh"
    "/usr/share/zsh/plugins/$plugin_name/init.zsh"
    "/usr/share/zsh/site-functions/$plugin_name.zsh"
    "/usr/share/zsh-*/$plugin_name.zsh"
  )
  
  # Try to find the plugin file
  local plugin_file=""
  for pattern in "${patterns[@]}"; do
    if [[ -f "$pattern" ]]; then
      plugin_file="$pattern"
      break
    fi
  done
  
  # If not found with patterns, try to query the package
  if [[ -z "$plugin_file" ]]; then
    plugin_file=$(get_system_package_path "$package" "\.zsh$")
  fi
  
  # Load the plugin if we found it
  if [[ -n "$plugin_file" ]] && [[ -f "$plugin_file" ]]; then
    source "$plugin_file"
    return 0
  else
    echo "Cannot find system plugin file for package: $package"
    return 1
  fi
}

# Function to load a plugin from git installation
function plugin_load_git() {
  local plugin_name plugin_dir plugin_file
  
  # Parse args: plugin_load_git "user/repo" [file]
  if [[ "$1" =~ ^([^/]+)/(.+)$ ]]; then
    plugin_name="${1#*/}"
  else
    plugin_name="$1"
  fi
  
  plugin_dir="${PLUGIN_DIR}/${plugin_name}"
  
  # Default plugin file is either plugin_name.plugin.zsh, 
  # plugin_name.zsh or init.zsh
  if [[ -z "$2" ]]; then
    if [[ -f "$plugin_dir/$plugin_name.plugin.zsh" ]]; then
      plugin_file="$plugin_dir/$plugin_name.plugin.zsh"
    elif [[ -f "$plugin_dir/$plugin_name.zsh" ]]; then
      plugin_file="$plugin_dir/$plugin_name.zsh"
    elif [[ -f "$plugin_dir/init.zsh" ]]; then
      plugin_file="$plugin_dir/init.zsh"
    else
      plugin_file="$plugin_dir/${plugin_name}.zsh"
    fi
  else
    plugin_file="$plugin_dir/$2"
  fi
  
  # Load the plugin if it exists
  if [[ -f "$plugin_file" ]]; then
    source "$plugin_file"
    return 0
  else
    echo "Cannot load plugin: $plugin_name. File not found: $plugin_file"
    return 1
  fi
}

# Main function to manage plugins with system package priority
function plugin() {
  local plugin_repo="$1"
  local custom_file="$2"
  local git_branch="${3:-master}"
  
  # Check if this plugin has a system package equivalent
  if [[ -n "${PLUGIN_SYSTEM_MAP[$plugin_repo]}" ]]; then
    local sys_package="${PLUGIN_SYSTEM_MAP[$plugin_repo]}"
    
    # Check if system package is already installed
    if is_package_installed "$sys_package"; then
      echo "Using system package for $plugin_repo: $sys_package"
      plugin_load_system "$sys_package" "$plugin_repo"
      return $?
    
    # Check if system package is available but not installed
    elif is_package_available "$sys_package"; then
      echo "System package for $plugin_repo is available but not installed"
      read -q "REPLY?Install system package $sys_package? (y/n) "
      echo
      
      if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        if install_system_package "$sys_package"; then
          plugin_load_system "$sys_package" "$plugin_repo"
          return $?
        else
          echo "Failed to install system package, falling back to GitHub"
        fi
      else
        echo "Skipping system package, using GitHub version"
      fi
    else
      echo "No system package found for $plugin_repo, using GitHub version"
    fi
  fi
  
  # Fall back to GitHub if no system package or user declined
  local plugin_name="${plugin_repo#*/}"
  local plugin_dir="${PLUGIN_DIR}/${plugin_name}"
  
  # Install/update the plugin if not exists
  if [[ ! -d "$plugin_dir" ]]; then
    plugin_install "$plugin_repo" "$git_branch"
  fi
  
  # Load the plugin
  plugin_load_git "$plugin_repo" "$custom_file"
}

# Function to update all git-based plugins
function plugin_update_all() {
  local plugin_dirs=("$PLUGIN_DIR"/*)
  
  if [[ ${#plugin_dirs[@]} -eq 0 ]]; then
    echo "No git-based plugins installed."
    return
  fi
  
  echo "Updating all git-based plugins..."
  for plugin_dir in "$PLUGIN_DIR"/*; do
    if [[ -d "$plugin_dir/.git" ]]; then
      plugin_name="${plugin_dir##*/}"
      echo "Updating $plugin_name..."
      (cd "$plugin_dir" && git pull --quiet)
    fi
  done
  echo "All git-based plugins updated."
}

# Function to list all installed plugins (both system and git)
function plugin_list() {
  local has_plugins=0
  
  # Check system plugins first
  echo "System package plugins:"
  local system_found=0
  for plugin_repo in "${!PLUGIN_SYSTEM_MAP[@]}"; do
    local sys_package="${PLUGIN_SYSTEM_MAP[$plugin_repo]}"
    if is_package_installed "$sys_package"; then
      echo "- $plugin_repo (via system package: $sys_package)"
      has_plugins=1
      system_found=1
    fi
  done
  
  if [[ $system_found -eq 0 ]]; then
    echo "- None installed"
  fi
  
  # Check git plugins
  echo "\nGit-based plugins:"
  local git_found=0
  if [[ -d "$PLUGIN_DIR" ]]; then
    for plugin_dir in "$PLUGIN_DIR"/*; do
      if [[ -d "$plugin_dir" ]]; then
        plugin_name="${plugin_dir##*/}"
        
        # Try to determine the original repo
        local repo_name=""
        if [[ -d "$plugin_dir/.git" ]]; then
          local remote_url=$(cd "$plugin_dir" && git remote get-url origin 2>/dev/null)
          if [[ "$remote_url" =~ github\.com[/:]([^/]+)/([^/.]+) ]]; then
            repo_name="${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
          else
            repo_name="unknown/$plugin_name"
          fi
        else
          repo_name="unknown/$plugin_name"
        fi
        
        echo "- $repo_name (via git)"
        has_plugins=1
        git_found=1
      fi
    done
  fi
  
  if [[ $git_found -eq 0 ]]; then
    echo "- None installed"
  fi
  
  if [[ $has_plugins -eq 0 ]]; then
    echo "No plugins installed."
  fi
}

# Example usage (uncomment as needed):
# # Load popular plugins with system package priority
# plugin "zsh-users/zsh-autosuggestions"
# plugin "zsh-users/zsh-syntax-highlighting"
