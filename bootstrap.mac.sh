#!/bin/bash

# Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew
brew update

# Install tools
echo "Installing tools"
brew install zsh neovim tmux tmuxinator gh kubectx
brew install --cask iterm2 opencode-desktop

