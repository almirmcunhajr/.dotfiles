#!/bin/bash

# Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew
brew update

# Install tools
echo "Installing tools: zsh, nvim, tmux, tmuxinator, iterm2, opencode-desktop..."
brew install zsh neovim tmux tmuxinator
brew install --cask iterm2 opencode-desktop
