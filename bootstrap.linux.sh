#!/bin/bash

echo "Starting Linux bootstrap..."

# Update package list
sudo apt update

# Install tools
echo "Installing tools: zsh, nvim, tmux, tmuxinator..."
sudo apt install -y zsh neovim tmux ruby-full
sudo gem install tmuxinator

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install powerlevel10k theme
P10K_PATH="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_PATH" ]; then
    echo "Installing powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_PATH"
fi

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    sudo chsh -s $(which zsh) $USER
fi

echo "Linux bootstrap complete!"
