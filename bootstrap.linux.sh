#!/bin/bash

# Update package list and install prerequisites
sudo apt update
sudo apt install -y software-properties-common

# Add Neovim unstable PPA for latest versions (>= 0.12)
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update

# Install tools
echo "Installing tools: zsh, nvim, tmux, tmuxinator, wget, curl..."
sudo apt install -y zsh neovim tmux ruby-full wget curl
sudo gem install tmuxinator

# Install GitHub CLI
sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s $(which zsh)
fi

