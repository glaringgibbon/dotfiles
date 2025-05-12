# $XDG_CONFIG_HOME/zsh/lib/core.zsh
# Core zsh settings
# HomeLab Dotfiles - Created 2025-05-05

# Basic zsh options
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

# Directory stack
setopt AUTO_PUSHD           # Push directories to stack
setopt PUSHD_IGNORE_DUPS    # Don't store duplicates in stack
setopt PUSHD_SILENT         # Don't print directory stack
setopt PUSHD_TO_HOME        # pushd with no arguments goes to home

# History options (core options - see history.zsh for more)
setopt HIST_VERIFY          # Show command with history expansion before running it
setopt SHARE_HISTORY        # Share history between all sessions
setopt HIST_IGNORE_SPACE    # Don't record commands starting with a space
setopt HIST_IGNORE_DUPS     # Don't record duplicate commands
setopt HIST_FIND_NO_DUPS    # Don't display duplicates when searching
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks
setopt HIST_SAVE_NO_DUPS    # Don't write duplicate entries in history file

# Job control
setopt LONG_LIST_JOBS       # List jobs in the long format
setopt AUTO_RESUME          # Attempt to resume existing job before creating a new process
setopt NOTIFY               # Report status of background jobs immediately

# Ensure critical directories exist
mkdir -p "${XDG_CONFIG_HOME}/zsh/lib"
mkdir -p "${XDG_CONFIG_HOME}/zsh/modules"
mkdir -p "${XDG_CONFIG_HOME}/zsh/functions"
mkdir -p "${XDG_CONFIG_HOME}/zsh/local"
mkdir -p "${XDG_STATE_HOME}/zsh"
mkdir -p "${XDG_CACHE_HOME}/zsh"
mkdir -p "${XDG_DATA_HOME}/zsh/plugins"
mkdir -p "${XDG_DATA_HOME}/zsh/site-functions"
