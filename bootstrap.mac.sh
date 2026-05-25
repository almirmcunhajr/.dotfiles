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
brew install --cask iterm2 opencode-desktop warp

# Create compatibility symlinks for XDG migration
echo "Creating compatibility symlinks..."
mkdir -p "$HOME/.warp"
ln -sfn "$HOME/.config/warp-terminal/settings.toml" "$HOME/.warp/settings.toml"
ln -sfn "$HOME/.local/share/warp-terminal/tab_configs" "$HOME/.warp/tab_configs"
