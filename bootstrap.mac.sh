#!/bin/bash

# Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew
brew update

# Install tools
echo "Installing tools: zsh, nvim, tmux, tmuxinator, iterm2, opencode-desktop, gh, warp"
brew install zsh neovim tmux tmuxinator gh
brew install --cask iterm2 opencode-desktop warp

# Create compatibility symlinks for XDG migration
echo "Creating compatibility symlinks..."
ln -sfn "$HOME/.config/warp-terminal" "$HOME/.warp"
ln -sfn "$HOME/.local/share/claude" "$HOME/.claude"
