# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Environment Variables
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="$PATH:$HOME/development/flutter/bin"
export PATH="$HOME/.local/bin:$PATH"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias txo='tmuxinator start project'
alias dotfiles="/usr/bin/git --git-dir=\"$HOME/.dotfiles/\" --work-tree=\"$HOME\""

# OS-specific routing
if [[ "$OSTYPE" == "darwin"* ]]; then
    [[ -f ~/.zshrc.mac ]] && source ~/.zshrc.mac
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    [[ -f ~/.zshrc.linux ]] && source ~/.zshrc.linux
fi

# Untracked kocal configuration
# Catches rogue installer scripts or machine-specific secrets
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
