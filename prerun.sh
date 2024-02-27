#!/bin/bash

# Update package list and upgrade existing packages
sudo apt update && sudo apt upgrade -y

# Check and install Nala if it's not installed
if [ -x "$(command -v nala)" ]; then
    echo "nala is installed and executable."
else
    echo "nala is not installed. Attempting to install..."
    # Assuming you have sudo rights and apt is available
    sudo apt update && sudo apt install -y nala
    # Re-check if nala is now installed and executable
    if [ -x "$(command -v nala)" ]; then
        echo "nala successfully installed."
    else
        echo "Failed to install nala. Please check for errors."
    fi
fi


# Replace apt with nala for the rest of the script
alias apt=nala

# Install zsh, wget, curl, and git if they're not already installed
for package in zsh wget curl git; do
    if [ -x "$(command -v $package)" ]; then
        echo "$package not found, installing..."
        sudo apt install $package -y
    else
        echo "$package is already installed."
    fi
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
