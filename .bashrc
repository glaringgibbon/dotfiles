# .bashrc

#

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases
if [ -f ~/.bashrc.d/.bash_aliases ]; then
    . ~/.bashrc.d/.bash_aliases
fi

# User specific functions
if [ -f ~/.bashrc.d/.bash_functions ]; then
    . ~/.bashrc.d/.bash_functions
fi

# Powerline
#if [ -f "which powerline-daemon" ]; then
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/share/powerline/bash/powerline.sh
#fi

# Options

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Bash history
export HISTSIZE=10000

# Text editor
export EDITOR="nvim"

# Python virtual environments
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Code/python
source $HOME/.local/bin/virtualenvwrapper.sh

# THIS IS A TEST


