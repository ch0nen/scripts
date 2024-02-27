#!/bin/bash

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
git clone https://git.suckless.org/dmenu
git clone https://git.suckless.org/st

# Clean up
$CMD apt autoremove -y

echo "DWM installation is complete. Start X with 'startx' command."
