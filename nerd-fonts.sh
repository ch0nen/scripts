#!/bin/bash

# Dependency check for 'doas' or 'sudo'
if [ -x "$(command -v doas)" ] && [ -e /etc/doas.conf ]; then
    ld="doas"
elif [ -x "$(command -v sudo)" ]; then
    ld="sudo"
else
    echo "Error: This script requires 'sudo' or 'doas' with '/etc/doas.conf'."
    exit 1
fi

# Ensure wget and unzip are installed
for package in wget unzip; do
    [ -x "$(command -v $package)" ] || $ld apt install $package -y
done

nfdir="$HOME/.local/share/fonts/nerdfonts"

# Download and install font function
install_font() {
    local font_url=$1
    local font_dir=$2
    local zip_file=$(basename "$font_url")

    wget "$font_url" -O "$zip_file"
    mkdir -p "$font_dir"
    unzip "$zip_file" -d "$font_dir"
    rm "$zip_file"

    # Cleanup unnecessary files
    find "$font_dir" \( -iname 'readme.md' -o -iname 'license*' \) -exec rm -f {} \;
}

# Font URLs
ubuntu_font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/Ubuntu.zip"
ubuntu_mono_font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/UbuntuMono.zip"
iosevka_font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/Iosevka.zip"
cascadia_code_font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/CascadiaCode.zip"
firacode_font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/FiraCode.zip"

# Install fonts
install_font "$ubuntu_font_url" "$nfdir/ubuntu"
install_font "$ubuntu_mono_font_url" "$nfdir/ubuntumono"
install_font "$iosevka_font_url" "$nfdir/iosevka"
install_font "$cascadia_code_font_url" "$nfdir/cascadiacode"
install_font "$firacode_font_url" "$nfdir/firacode"

# Refresh the font cache
fc-cache -f -v

echo "Nerd Fonts installation completed."
