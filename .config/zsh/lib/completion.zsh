# $XDG_CONFIG_HOME/zsh/lib/completion.zsh
# ZSH completion system configuration
# HomeLab Dotfiles - Created 2025-05-05

# Load and initialize the completion system
autoload -Uz compinit

# Set completion cache path (XDG compliant)
compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"

# Define custom site-functions directory for XDG compliance
fpath=("${XDG_DATA_HOME}/zsh/site-functions" $fpath)

# Complete to the longest unambiguous substring
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Display process names in completion (procedural)
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:processes-names' command 'ps -e -o comm='

# Fuzzy matching of completions
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' verbose true

# Case insensitive path-completion 
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Cache completions for better performance
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"

# Don't show certain users
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp git games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# Ignore completion functions for commands you don't have
zstyle ':completion:*:functions' ignored-patterns '_*'

# Host completion
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_,~/.ssh/}known_hosts(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Fix the menuselect keymap issue:
# Add zmodload zsh/complist before any bindkey commands that use menuselect
# Load the complist module which provides the menuselect keymap
zmodload zsh/complist

# Make completion menu behave more intuitively
bindkey -M menuselect '^o' accept-and-infer-next-history
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^j' vi-down-line-or-history
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char

# Initialize the new completion system if available
if type brew &>/dev/null; then
  # Add brew-installed completions to fpath
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

# Re-initialize for changes to take effect if shell is interactive
[[ -o interactive ]] && compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"
