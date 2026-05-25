# Enable Powerlevel10k instant prompt. Must be at the very top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Aliases
alias txo='tmuxinator start dev'
alias dotfiles="/usr/bin/git --git-dir=\"$HOME/.dotfiles/\" --work-tree=\"$HOME\""

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git kubectl aws)
source $ZSH/oh-my-zsh.sh

# OS-specific routing (after oh-my-zsh so compinit is already initialized)
if [[ "$OSTYPE" == "darwin"* ]]; then
    [[ -f ~/.zshrc.mac ]] && source ~/.zshrc.mac
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    [[ -f ~/.zshrc.linux ]] && source ~/.zshrc.linux
fi

# Untracked local configuration
# Catches rogue installer scripts or machine-specific secrets
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# flutter
export PATH="$PATH:$HOME/development/flutter/bin"
export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
