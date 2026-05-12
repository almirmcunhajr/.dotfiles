# OS-specific routing
if [[ "$OSTYPE" == "darwin"* ]]; then
    [[ -f ~/.zshrc.mac ]] && source ~/.zshrc.mac
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    [[ -f ~/.zshrc.linux ]] && source ~/.zshrc.linux
fi

# Untracked kocal configuration
# Catches rogue installer scripts or machine-specific secrets
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Aliases
alias txo='tmuxinator start project'
alias dotfiles="/usr/bin/git --git-dir=\"$HOME/.dotfiles/\" --work-tree=\"$HOME\""

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# flutter
export PATH="$PATH:$HOME/development/flutter/bin"
export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH=/Users/almir.cunha/.opencode/bin:$PATH
