# $XDG_CONFIG_HOME/zsh/.zshrc
# Main zsh configuration file
# HomeLab Dotfiles - Created 2025-05-05

# Performance profiling (uncomment to enable)
zmodload zsh/zprof

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

# Performance profiling output (uncomment to enable)
zprof
