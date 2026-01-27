# This file bootstraps .config/zsh.zshenv where the real action happens
# This is because .zshenv is not XDG compliant
# If both files aren't in place env vars are overridden and things will break
# Bootstrap ZDOTDIR
export ZDOTDIR="$HOME/.config/zsh"

# Load the actual environment from ZDOTDIR
if [[ -f "$ZDOTDIR/.zshenv" ]]; then
    . "$ZDOTDIR/.zshenv"
fi
