#!/usr/bin/env bash

set -e

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing sudo timestamp in the background
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "→ Checking for macOS software updates..."
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
  echo "→ Installing Homebrew..."
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

# Disable analytics
# https://docs.brew.sh/Analytics
brew analytics off

echo "→ Updating Homebrew..."
brew update

# Install more current ZSH and set as default shell
# https://stackoverflow.com/a/44549662/1438024
echo "→ Setting up Homebrew zsh..."
brew install zsh

BREW_ZSH="$(brew --prefix)/bin/zsh"

# Add brew's zsh to /etc/shells if not already there
if ! grep -qxF "$BREW_ZSH" /etc/shells; then
  echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
fi

# Switch default shell only if not already set (use dscl to check actual
# setting, not $SHELL which reflects the session's original shell)
CURRENT_SHELL=$(dscl . -read /Users/"$USER" UserShell | awk '{print $2}')
if [[ "$CURRENT_SHELL" != "$BREW_ZSH" ]]; then
  echo "→ Changing default shell to Homebrew zsh..."
  sudo dscl . -change /Users/"$USER" UserShell "$CURRENT_SHELL" "$BREW_ZSH"
else
  echo "  Already using Homebrew zsh, skipping."
fi

# https://github.com/ohmyzsh/ohmyzsh/issues/6835#issuecomment-390187157
chmod 755 "$(brew --prefix)/share/zsh"
chmod 755 "$(brew --prefix)/share/zsh/site-functions"

# 1Password SSH integration
# https://developer.1password.com/docs/ssh/get-started#step-4-configure-your-ssh-or-git-client
echo "→ Setting up 1Password SSH agent..."
mkdir -p ~/.1password
ln -sf ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock

# Install all apps from the Brewfile, ignore errors
# brew bundle is now built into Homebrew core (no tap needed)
echo "→ Installing Brewfile packages (this may take a while)..."
brew bundle --verbose || true

# Set macOS defaults
# Needs to be last since this will restart everything when done
echo "→ Applying macOS defaults..."
source ./macos/defaults.sh
