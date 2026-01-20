# $XDG_CONFIG_HOME/zsh/tools/profile.zsh
# Zsh startup profiling tool
# Usage: ZSH_PROFILE=1 zsh

if [[ "$ZSH_PROFILE" == "1" ]]; then
    zmodload zsh/zprof
    # Display results automatically when the shell starts up
    # (Useful for finding which module is slow)
    add-zsh-hook precmd () {
        if [[ -n "$ZSH_PROF_DONE" ]]; then return; fi
        zprof | head -n 20
        export ZSH_PROF_DONE=1
    }
fi
