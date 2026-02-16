#!/usr/bin/env bash

set -e

# Ask for the administrator password upfront
sudo -v

# Make sure macOS is fully up to date before doing anything
sudo softwareupdate --install --all

# Install Rosetta 2
# sudo softwareupdate --install-rosetta --agree-to-license

# Install Xcode Command Line Tools
# sudo xcode-select --install
# Accept Xcode license
# sudo xcodebuild -license accept

# This whole thing kinda hinges on having Homebrew...
# Check for it and install from GitHub if it's not there
if ! command -v brew &>/dev/null; then
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

# Disable analytics
# https://docs.brew.sh/Analytics
brew analytics off

# Update Homebrew recipes
brew update

# Install more current ZSH and set as default shell
# https://stackoverflow.com/a/44549662/1438024
brew install zsh

BREW_ZSH="$(brew --prefix)/bin/zsh"

# Add brew's zsh to /etc/shells if not already there
if ! grep -qxF "$BREW_ZSH" /etc/shells; then
  echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
fi

# Switch default shell only if not already set
if [[ "$SHELL" != "$BREW_ZSH" ]]; then
  sudo chsh -s "$BREW_ZSH" "$USER"
fi

# https://github.com/ohmyzsh/ohmyzsh/issues/6835#issuecomment-390187157
chmod 755 "$(brew --prefix)/share/zsh"
chmod 755 "$(brew --prefix)/share/zsh/site-functions"

# 1Password SSH integration
# https://developer.1password.com/docs/ssh/get-started#step-4-configure-your-ssh-or-git-client
mkdir -p ~/.1password
ln -sf ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock

# Install all apps from the Brewfile, ignore errors
# brew bundle is now built into Homebrew core (no tap needed)
brew bundle || true

# Set macOS defaults
# Needs to be last since this will restart everything when done
source ./macos/defaults.sh