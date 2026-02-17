#!/usr/bin/env bash

set -e

LINK_ONLY=false
if [[ "$1" == "--link-only" ]]; then
  LINK_ONLY=true
fi

echo "🙏 Deep breaths, everything will (probably) be fine!"
echo ""

# location of the *full repo* (defaults to ~/.dotfiles)
DOTFILES_PATH="${DOTFILES_PATH:="$HOME/.dotfiles"}"
# location of this script (should be right next to all the other files, but we handle that next if it's not)
INSTALLER_PATH="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# if this is a codespace, link automatically cloned dotfiles repo to the expected DOTFILES_PATH
# https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-personalization-for-codespaces#troubleshooting-dotfiles
if [[ "$CODESPACES" = "true" ]] && [[ -d /workspaces/.codespaces/.persistedshare/dotfiles ]]; then
  ln -sf /workspaces/.codespaces/.persistedshare/dotfiles "$DOTFILES_PATH"
fi

# clone this repo if this script is all by itself and/or we're not in the expected location
if [[ "$INSTALLER_PATH" != "$DOTFILES_PATH" ]] && [[ ! -d "$DOTFILES_PATH" ]]; then
  git clone https://github.com/SamPetherbridge/dotfiles.git "$DOTFILES_PATH"

  echo "Successfully cloned the full repo to '$DOTFILES_PATH'"
  echo "Run install.sh from that directory to continue. Exiting now..."
  exit 0
fi

###############################################################################
# Symlinks (always runs — fast and idempotent)
###############################################################################

echo "→ Creating symlinks..."

# Ensure directories exist
mkdir -p ~/.config
mkdir -p ~/.ssh && chmod 700 ~/.ssh
mkdir -p ~/.ssh/conf.d

# Shell
ln -sf "$DOTFILES_PATH/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_PATH/zsh/.zprofile" ~/.zprofile
touch ~/.zshrc.local

# Git
ln -sf "$DOTFILES_PATH/git/.gitconfig" ~/.gitconfig
ln -sf "$DOTFILES_PATH/git/.gitignore_global" ~/.gitignore_global

# SSH
ln -sf "$DOTFILES_PATH/ssh/.ssh/config" ~/.ssh/config

# Nano
ln -sf "$DOTFILES_PATH/nano/brew.nanorc" ~/.nanorc

# Tmux
ln -sf "$DOTFILES_PATH/tmux/.tmux.conf" ~/.tmux.conf

# Brewfile
ln -sf "$DOTFILES_PATH/Brewfile" ~/Brewfile

# Ghostty terminal config
GHOSTTY_CONFIG_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
mkdir -p "$GHOSTTY_CONFIG_DIR"
ln -sf "$DOTFILES_PATH/ghostty/config" "$GHOSTTY_CONFIG_DIR/config"

# Claude Code config (symlink individual files, not the whole directory)
mkdir -p ~/.claude
ln -sf "$DOTFILES_PATH/claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$DOTFILES_PATH/claude/settings.json" ~/.claude/settings.json
ln -sf "$DOTFILES_PATH/claude/statusline-command.sh" ~/.claude/statusline-command.sh
if [[ -d "$DOTFILES_PATH/claude/commands" ]]; then
  rm -rf ~/.claude/commands
  ln -sf "$DOTFILES_PATH/claude/commands" ~/.claude/commands
fi

# Suppress terminal login banners
touch ~/.hushlogin

echo "  Symlinks created."

###############################################################################
# Full bootstrap (skipped with --link-only)
###############################################################################

if [[ "$LINK_ONLY" == true ]]; then
  echo ""
  echo "🎉 Symlinks updated! Run without --link-only for full setup."
  exit 0
fi

# macOS-specific setup
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "This dotfiles repo is macOS-only. Exiting..."
  exit 1
fi

# shellcheck disable=SC1090,SC1091
source "$DOTFILES_PATH/macos/macos.sh"

echo ""
echo "🎉 It actually worked!"
echo "Log out and log back in (or just restart) to finish installing all ZSH features."
