# $XDG_CONFIG_HOME/zsh/lib/terminal.zsh
# Terminal-specific settings
# HomeLab Dotfiles - Created 2025-05-05

# Set window title based on current command/directory
function set_window_title() {
  # For local terminals show directory and command
  if [[ -z "$SSH_CLIENT" ]]; then
    print -Pn "\e]0;%~: $1\a"
  else
    # For SSH sessions, show hostname, directory and command
    print -Pn "\e]0;%m: %~: $1\a"
  fi
}

# Update window title before command execution
function title_precmd() {
  set_window_title "zsh"
}

function title_preexec() {
  set_window_title "$1"
}

# Install the functions
autoload -Uz add-zsh-hook
add-zsh-hook precmd title_precmd
add-zsh-hook preexec title_preexec

# Handle terminal capabilities
# Ensure backspace and delete work correctly
bindkey "^?" backward-delete-char
bindkey "^[[3~" delete-char

# Enable cursor shape changes based on vi mode
# Block cursor for normal mode, beam for insert mode
if [[ $TERM =~ 'xterm' || $TERM =~ 'alacritty' || $TERM = 'screen' || $TERM = 'tmux' ]]; then
  cursor_mode() {
    # 0 = blinking block
    # 1 = blinking block (default)
    # 2 = steady block
    # 3 = blinking underline
    # 4 = steady underline
    # 5 = blinking beam
    # 6 = steady beam
    if [[ ${KEYMAP} == vicmd ]]; then
      echo -ne '\e[2 q' # Use steady block in normal mode
    else
      echo -ne '\e[6 q' # Use steady beam in insert mode
    fi
  }
  
  zle-keymap-select() {
    cursor_mode
  }
  
  zle-line-init() {
    cursor_mode
  }
  
  zle -N zle-keymap-select
  zle -N zle-line-init
fi

# Terminal specific settings for different terminals
if [[ "$TERM" == "alacritty" ]]; then
  # Alacritty specific settings
  :
elif [[ "$TERM" == "tmux-256color" || "$TERM" == "screen-256color" ]]; then
  # tmux specific settings
  :
fi

# Reset terminal if needed
ttyctl -f

# Handle terminal closing properly
function zshexit() {
  # Reset cursor to default beam shape
  echo -ne '\e[5 q'
}
