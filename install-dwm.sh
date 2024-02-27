#!/bin/bash

# Define the base directory for dwm and patches
DWM_DIR="$HOME/.config/suckless/dwm"
PATCHES_DIR="$DWM_DIR/patches"

# Define command loader
[ -x "$(command -v sudo)" ] && CMD="sudo" || CMD=""

# Update and Upgrade
$CMD nala update && $CMD nala upgrade -y

# Install Xorg and other dependencies
$CMD nala install -y xorg build-essential libx11-dev libxcb1-dev libxft-dev libxinerama-dev

# Optional: Install fonts
#$CMD apt install -y fonts-liberation

# Create the working directory
mkdir -p $HOME/.config/suckless
cd $HOME/.config/suckless

# Clone dwm source code
git clone https://git.suckless.org/dwm
cd dwm

# Ensure the base directory exists
mkdir -p "$PATCHES_DIR"

# List of patches to apply
declare -A PATCHES=(
  ["alwayscenter"]="https://dwm.suckless.org/patches/alwayscenter/dwm-alwayscenter-20200625-f04cac6.diff"
)

#  ["attachbottom"]="https://dwm.suckless.org/patches/attachbottom/dwm-attachbottom-6.3.diff"
#  ["cool_autostart"]="https://dwm.suckless.org/patches/cool_autostart/dwm-cool-autostart-6.2.diff"
#  ["fakefullscreen"]="https://dwm.suckless.org/patches/fakefullscreen/dwm-fakefullscreen-20210714-138b405.diff"
#  ["fullgaps"]="https://dwm.suckless.org/patches/fullgaps/dwm-fullgaps-6.4.diff"
#  ["hide_vacant_tags"]="https://dwm.suckless.org/patches/hide_vacant_tags/dwm-hide_vacant_tags-6.3.diff"
#  ["preserveonrestart"]="https://dwm.suckless.org/patches/preserveonrestart/dwm-preserveonrestart-6.3.diff"
#  ["status2d"]="https://dwm.suckless.org/patches/status2d/dwm-status2d-6.3.diff"
#  ["titlecolor"]="https://dwm.suckless.org/patches/titlecolor/dwm-titlecolor-20210815-ed3ab6b4.diff"
#  ["bottomstack"]="https://dwm.suckless.org/patches/bottomstack/dwm-bottomstack-6.1.diff"

# Download and apply patches
cd "$DWM_DIR"
for patch in "${!PATCHES[@]}"; do
  echo "Applying $patch patch..."
  patch_file="$PATCHES_DIR/$patch.diff"
  curl -sLo "$patch_file" "${PATCHES[$patch]}"
  if git apply --check "$patch_file"; then
    git apply "$patch_file"
    echo "$patch applied successfully."
  else
    echo "Failed to apply $patch. Manual intervention required."
  fi
done

# Compile dwm
echo "Compiling dwm..."
sudo make clean install
cd ..
git clone https://git.suckless.org/dmenu
git clone https://git.suckless.org/st

# Clean up
$CMD apt autoremove -y

echo "DWM installation is complete. Start X with 'startx' command."
