# tools/profile.zsh
if [[ "$ZSH_PROFILE" == "1" ]]; then
    zmodload zsh/zprof
    # Set trap to ensure zprof runs at end even if something fails
    trap 'zprof' EXIT
fi
