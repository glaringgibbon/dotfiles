# ~/.config/zsh/functions/font.zsh

# Source shared font configuration
FONT_CONFIG="${HOME}/.local/share/fonts/font_config"

if [[ ! -f "$FONT_CONFIG" ]]; then
    echo "Warning: Font configuration file not found at $FONT_CONFIG"
    return 1
fi

source "$FONT_CONFIG"

# Font management functions
function check_fonts() {
    local missing_fonts=()
    
    for font in "${NERD_FONTS[@]}"; do
        if ! fc-list | grep -i "$font" > /dev/null; then
            missing_fonts+=("$font")
        fi
    done
    
    if (( ${#missing_fonts[@]} > 0 )); then
        echo "Missing Nerd Fonts: ${missing_fonts[*]}"
        echo "Run 'install-nerd-fonts' to install missing fonts"
        return 1
    fi
    return 0
}

function list-fonts() {
    local font_dir="$HOME/.config/alacritty/fonts"
    if [[ ! -d "$font_dir" ]]; then
        echo "Font configuration directory not found"
        return 1
    fi
    echo "Available font configurations:"
    for conf in "$font_dir"/*.toml; do
        [[ -f "$conf" ]] || continue
        basename "$conf" .toml
    done
}

function switch-font() {
    local font_name="$1"
    local font_dir="$HOME/.config/alacritty/fonts"
    local font_file="$font_dir/${font_name}.toml"
    
    if [[ ! -f "$font_file" ]]; then
        echo "Font configuration '$font_name' not found"
        echo "Available configurations:"
        list-fonts
        return 1
    fi
    
    ln -sf "$font_file" "$font_dir/active-font.toml"
    echo "Switched to font: $font_name"
    echo "Please open a new terminal window to see the changes"
    
    # Optionally offer to launch a new instance
    echo "Would you like to open a new terminal window? (y/n)"
    read -q response && {
        # Temporarily disable tmux
        local old_auto_tmux=$AUTO_TMUX
        export AUTO_TMUX=no
        alacritty &
        export AUTO_TMUX=$old_auto_tmux
    }
}

function verify-font() {
    # Show current font symlink
    echo "Current font symlink points to:"
    ls -l ~/.config/alacritty/fonts/active-font.toml

    # Print test pattern
    echo "\nTest Pattern:"
    echo "----------------"
    echo "0123456789"
    echo "ABCDEFGHIJKLM"
    echo "abcdefghijklm"
    echo "!@#$%^&*()"
    echo "-> => != >= <="  # Ligature test
    echo "----------------"
    echo "\nNerd Font Test Icons:"
    echo "  󰈚   󰊗   󰊤   󰡄   󰊠 "  # These should appear as icons if Nerd Font is working
}
