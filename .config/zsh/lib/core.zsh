# $XDG_CONFIG_HOME/zsh/lib/core.zsh
# Core zsh settings and directory sanity checks
# HomeLab Dotfiles - Refactored 2026-01-18

# --- Directory Sanity Check ---
# Ensure critical XDG and Zsh directories exist
# We do this here so it only runs in interactive shells
local dirs=(
    "${XDG_CONFIG_HOME}/zsh/lib"
    "${XDG_CONFIG_HOME}/zsh/modules"
    "${XDG_CONFIG_HOME}/zsh/functions"
    "${XDG_CONFIG_HOME}/zsh/local"
    "${XDG_STATE_HOME}/zsh"
    "${XDG_CACHE_HOME}/zsh"
    "${XDG_DATA_HOME}/zsh/plugins"
    "${XDG_DATA_HOME}/zsh/site-functions"
)

for dir in $dirs; do
    [[ -d "$dir" ]] || mkdir -p "$dir"
done

# --- Basic Zsh Options ---
setopt AUTO_CD              # Change directory without cd
setopt EXTENDED_GLOB        # Extended globbing
setopt PROMPT_SUBST         # Enable substitution in prompt
setopt COMPLETE_IN_WORD     # Complete from both ends of a word
setopt ALWAYS_TO_END        # Move cursor to end of word on full completion
setopt PATH_DIRS            # Perform path search even on command names with slashes
setopt AUTO_MENU            # Show completion menu on tab press
setopt AUTO_LIST            # List choices on ambiguous completion
setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash
setopt NO_FLOW_CONTROL      # Disable start/stop characters in shell editor

# --- Directory Stack ---
setopt AUTO_PUSHD           # Push directories to stack
setopt PUSHD_IGNORE_DUPS    # Don't store duplicates in stack
setopt PUSHD_SILENT         # Don't print directory stack
setopt PUSHD_TO_HOME        # pushd with no arguments goes to home

# --- Job Control ---
setopt LONG_LIST_JOBS       # List jobs in the long format
setopt AUTO_RESUME          # Attempt to resume existing job before creating a new process
setopt NOTIFY               # Report status of background jobs immediately
