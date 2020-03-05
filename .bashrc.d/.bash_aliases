# Safety first
alias mkdir="mkdir -p" #Enforce parent directories are also created
alias rm="rm -i" #Prompt to confirm
alias cp="cp -i" #Prompt to confirm
alias mv="mv -i" #Prompt to confirm

# System process'

# SystemD
alias sc="systemctl" # 

alias scst="sudo systemctl start" # 
alias scsp="sudo systemctl stop" # 
alias scrl="sudo systemctl reload" # 
alias scrt="sudo systemctl restart" # 
alias sce="sudo systemctl enable" # 
alias scd="sudo systemctl disable" # 
alias scs="sudo systemctl status" # 
alias scsw="sudo systemctl show" # 
alias sclu="sudo systemctl list-units" # 
alias scluf="sudo systemctl list-unit-files" # 
alias sclt="sudo systemctl list-timers" # 
alias scc="sudo systemctl cat" # 
alias scie="sudo systemctl is-enabled" # 

# Journalctl
alias jc="journalctl" # 
alias jcb="journalctl -b" # 
alias jcxb="journalctl -xb" # 
alias jcxbp="journalctl -xb -p" # 
alias jclb="journalctl --list-boots" # 
alias jck="journalctl -k" # 
alias jcxk="journalctl -xk" # 
alias jcxkp="journalctl -xk -p" # 
alias jcg="journalctl --grep=" # 
alias jcll="journalctl -f -u" # 
alias jcs="journalctl --since" # 
#alias jc="journalctl" # 
#alias jc="journalctl" # 

# DNF Package management
alias dnfla="dnf list --all" # 
alias dnfli="dnf list --installed" # 
alias dnflu="dnf list --upgrades"
alias dnfif="dnf info"
alias dnfs="dnf search"

alias dnfin="sudo dnf install" # 
alias dnfrm="sudo dnf remove" # 
alias dnfupg="sudo dnf upgrade" # 
alias dnfarm="sudo dnf autoremove" #
alias dnfca="sudo dnf clean all" #
alias dnfrl="sudo dnf repolist" #
alias dnfrq="sudo dnf repoquery" #
alias dnfgrps="sudo dnf group summary" #
alias dnfgrpin="sudo dnf group install" #
alias dnfgrpif="sudo dnf group info" #
alias dnfgrprm="sudo dnf group remove" #



# Files and navigation

# List
alias ls="ls -ahl --color | less -R" # 
alias lshm="ls ~ -ahl --color | less -R" # 
alias lsrt="ls / -ahl --color | less -R" # 
alias lsdtop="ls ~/Desktop -ahl --color | less -R" # 
alias lsdox="ls ~/Documents-ahl --color | less -R" # 
alias lspix="ls ~/Pictures -ahl --color | less -R" # 
alias lsetc="ls /etc -ahl --color | less -R" # 
alias lsvar="ls /var -ahl --color | less -R" # 
alias lsmedia="ls /media -ahl --color | less -R" # 
alias lsusr="ls /usr -ahl --color | less -R" # 

# Navigation
alias home="cd ~" # 
alias root="cd /" # 
alias dtop="cd ~/Desktop" # 
alias dox="cd ~/Documents" # 
alias pix="cd ~/Pictures" # 
alias etc="cd /etc" # 
alias var="cd /var" # 
alias media="cd /media" # 
alias mnt="cd /mnt" # 
alias usr="cd /usr" # 

# History
alias h="history" #
alias hg="history | grep" #
alias hl="history | less" # 
 
alias h10="history -n 10" # 
alias h50="history -n 50" # 
alias h100="history -n 100" # 

# Configs
alias bashrc="nvim ~/.bashrc" # 
alias aliases="nvim ~/.bash_aliases" # 
alias functions="nvim ~/.bash_functions" # 
alias tmuxconf="nvim ~/.tmux.conf" # 
alias initnvim="nvim ~/.config/nvim/init.vim" # 

# Source
alias loadbash=". ~/.bashrc" # 
alias loadtmux="tmux source-file ~/.tmux.conf" # 
alias loadnvim=". ~/.config/nvim/initvim"

# SSH
#ssh julia
#ssh pi0
#ssh pi1
#ssh pi2
#ssh pi3
#ssh t440

# Apps

# TMUX




# NEOVIM



# GIT
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"


# Languages

# Python
#






