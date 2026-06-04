#!/bin/bash

NODE_VERSION=24

echo "Starting bootstrap"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OS="$(uname)"

case "$OS" in
    Linux*)     "$DIR/bootstrap.linux.sh" ;;
    Darwin*)    "$DIR/bootstrap.mac.sh" ;;
    *)          echo "Unknown OS: $OS"; exit 1 ;;
esac

# Install Antigravity
if ! command -v agy &> /dev/null; then
  echo "Installing Antigravity"
  curl -fsSL https://antigravity.google/cli/install.sh | bash
fi

# Install uv
if ! command -v uv &> /dev/null; then
  echo "Installing uv"
  wget -qO- https://astral.sh/uv/install.sh | sh
fi

# Install nvm
if ! command -v nvm &> /dev/null; then
  echo "Installing nvm"
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
fi

# Installing Node.js
if ! command -v node &> /dev/null; then
  echo "Installing Node.js ${NODE_VERSION}"
  nvm install $NODE_VERSION
  nvm use $NODE_VERSION
fi

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

# Install OpenCode
if ! command -v opencode &> /dev/null; then
  echo "Installing OpenCode"
  curl -fsSL https://opencode.ai/install | bash
fi

# Install Claude Code
if ! command -v claude &> /dev/null; then
  echo "Installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
fi

# Install gemini-cli
if ! command -v gemini &> /dev/null; then
  echo "Installing gemini-cli"
  npm install -g @google/gemini-cli
fi

# Install superpowers
claude plugins marketplace add obra/superpowers-marketplace
claude plugins install superpowers@superpowers-marketplace

echo "Bootstrap completed"
