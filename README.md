# Dotfiles

This repository contains my system configuration files. It is managed using the bare Git repository method detailed in the [ArchWiki Dotfiles guide](https://wiki.archlinux.org/title/Dotfiles).

## Replicating on a new system

### 1. Clone the bare repository

```bash
git clone --bare git@github.com:almirmcunhajr/.dotfiles $HOME/.dotfiles
```

### 2. Define the `dotfiles` alias

```bash
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
```

### 3. Checkout the files

```bash
dotfiles checkout
```

If there are conflicts with existing files (e.g. a default `.bashrc`), back them up first:

```bash
mkdir -p $HOME/.dotfiles-backup && \
dotfiles checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | \
xargs -I{} mv $HOME/{} $HOME/.dotfiles-backup/{}
```

Then retry:

```bash
dotfiles checkout
```

### 4. Hide untracked files

```bash
dotfiles config --local status.showUntrackedFiles no
```

### 5. Make the alias permanent

Add the alias to your shell configuration (e.g. `~/.bashrc` or `~/.zshrc`):

```bash
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
```

You can now manage dotfiles with the `dotfiles` command the same way you would use `git`:

```bash
dotfiles status
dotfiles add ~/.config/some-app/config
dotfiles commit -m "Add some-app config"
dotfiles push
```

