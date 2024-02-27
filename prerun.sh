#!/bin/bash

# Update package list and upgrade existing packages
sudo apt update && sudo apt upgrade -y

# Check and install Nala if it's not installed
[ -x "$(command -v nala)" ] || sudo apt install nala -y

# Install zsh, wget, curl, and git if they're not already installed
for package in zsh wget curl git; do
    [ -x "$(command -v $package)" ] || sudo nala install $package -y
done

# Change the default shell to zsh if it's not already zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

echo "Installation complete. Please log out and log back in for the default shell change to take effect."
