# modules/direnv.zsh

if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# Smart venv activation - walks up directory tree to find .venv
_activate_venv() {
  local dir="$PWD"
  
  # Walk up the directory tree looking for .venv
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.venv" ]]; then
      # Found a venv - activate it if not already active
      if [[ "$VIRTUAL_ENV" != "$dir/.venv" ]]; then
        export VIRTUAL_ENV="$dir/.venv"
        export PATH="$VIRTUAL_ENV/bin:$PATH"
      fi
      return 0
    fi
    dir="${dir:h}"  # Go up one directory
  done
  
  # No venv found - deactivate if one was active
  if [[ -n "$VIRTUAL_ENV" ]]; then
    export PATH="${PATH//$VIRTUAL_ENV\/bin:/}"
    unset VIRTUAL_ENV
  fi
}

# Hook into directory changes
autoload -U add-zsh-hook
add-zsh-hook chpwd _activate_venv

# Run once on shell startup
_activate_venv
