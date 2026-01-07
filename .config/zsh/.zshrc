# $XDG_CONFIG_HOME/zsh/.zshrc
# Main zsh configuration file
# HomeLab Dotfiles - Created 2025-05-05

# Performance profiling - run ZSH_PROFILE=1 zsh in terminal
# This will start a new shell that is profiled for performance, load order etc to help debug zsh config.
# tools/profile.zsh is a toggle to facilitate profiling.
[[ -f "${ZDOTDIR}/tools/profile.zsh" ]] && source "${ZDOTDIR}/tools/profile.zsh"

# Check for local pre-configuration
[[ -f "${ZDOTDIR}/local/before.zsh" ]] && source "${ZDOTDIR}/local/before.zsh"

# Load core library files in specific order
for module in core xdg environment colours terminal key-bindings history completion aliases prompt; do
  if [[ -f "${ZDOTDIR}/lib/${module}.zsh" ]]; then
    source "${ZDOTDIR}/lib/${module}.zsh"
  else
    echo "Warning: ${ZDOTDIR}/lib/${module}.zsh not found"
  fi
done

# Load plugins module if available
[[ -f "${ZDOTDIR}/modules/plugins.zsh" ]] && source "${ZDOTDIR}/modules/plugins.zsh"

# Load other optional modules if they exist
for module in security multiplexer; do
  [[ -f "${ZDOTDIR}/modules/${module}.zsh" ]] && source "${ZDOTDIR}/modules/${module}.zsh"
done

# Load custom functions if directory exists
if [[ -d "${ZDOTDIR}/functions" ]]; then
  for func_file in "${ZDOTDIR}/functions/"*.zsh; do
    [[ -f "$func_file" ]] && source "$func_file"
  done
fi

# Load local machine-specific configuration last
[[ -f "${ZDOTDIR}/local/after.zsh" ]] && source "${ZDOTDIR}/local/after.zsh"

# Run language check and update function as late as possible after zsh config loaded
check_lang_versions()

i  
      
    # Wayland clipboard (wl-clipboard)  
    if command -v wl-copy &> /dev/null; then  
        alias pbcopy='wl-copy'  
        alias pbpaste='wl-paste'  
    fi  
fi  
