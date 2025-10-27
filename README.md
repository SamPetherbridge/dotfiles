# dotfiles

macOS development environment automation for [@sampetherbridge](https://github.com/sampetherbridge)

## Overview

This repository contains configuration files and installation scripts for setting up a complete macOS development environment. It automates the installation of development tools, applications, and system preferences.

## Features

- **Shell Configuration**: Zsh with custom aliases, functions, and environment settings
- **Package Management**: Homebrew for CLI tools and applications
- **Python Management**: Uses `uv` for modern Python package and project management
- **Git Configuration**: Pre-configured with 1Password SSH signing and useful aliases
- **SSH Hardening**: Modern security settings with 1Password agent integration
- **iTerm2**: Custom color schemes and preferences
- **macOS Settings**: Automated system preferences configuration

## Installation

### Prerequisites

- macOS (Apple Silicon or Intel)
- Command Line Tools: `xcode-select --install`

### Quick Start

```bash
# Clone the repository
git clone https://github.com/sampetherbridge/dotfiles.git ~/.dotfiles

# Run the installer
cd ~/.dotfiles
./install.sh
```

The installer will:
1. Create symlinks for configuration files
2. Install Homebrew packages and applications
3. Set up SSH and iTerm2 configurations
4. Apply macOS system preferences
5. Initialize Zsh with zinit plugin manager

### Manual Steps After Installation

1. **Log out and log back in** to activate all Zsh features
2. **Configure 1Password SSH Agent**: Ensure 1Password is installed and SSH agent is enabled
3. **Import iTerm2 colors**: Color schemes are in `iterm/` directory
4. **Review Brewfile**: Uncomment any additional packages you need

## What's Included

### Core Tech Stack

**Primary Languages:**
- Python (via `uv`)
- Swift (native macOS tooling)
- Kotlin (for Android development)

**Mobile Development:**
- Android Platform Tools
- OpenJDK (required for Android)
- SF Symbols (for iOS/macOS)

**Cloud Platforms:**
- AWS CLI
- Google Cloud SDK
- Azure CLI

### Development Tools

- **Python**: `uv` (modern package manager replacing pip/pipenv/poetry)
- **Git**: Git, git-lfs, GitHub CLI (`gh`)
- **Build Tools**: autoconf, automake, pkg-config, rust
- **Modern CLI**: jq, yq, fzf, ripgrep, shellcheck, shfmt
- **Database**: SQLite (local development)

### Applications (via Homebrew Cask)

- **Development**: VS Code, Docker, iTerm2, Android Platform Tools
- **Cloud**: Google Cloud SDK, Azure CLI
- **Design**: Adobe Creative Cloud, ImageOptim
- **Productivity**: 1Password, Alfred, OmniFocus, Hazel, Keyboard Maestro, Setapp
- **Communication**: Slack, Discord, Zoom
- **Browsers**: Firefox, Chrome

### Optional: Security Tools

Security/pentesting tools have been moved to `Brewfile.security` for optional installation:

```bash
# Install security tools when needed
brew bundle --file=~/.dotfiles/Brewfile.security
```

Includes: nmap, hashcat, mitmproxy, aircrack-ng, and 25+ other tools for authorized security testing.

### Shell Features

- GNU coreutils (replacing macOS BSD tools)
- Custom aliases for Git, Docker, and common operations
- Optimized PATH configuration for Python, Android, and Rust
- Telemetry disabled for major development tools

## Configuration Files

| File | Purpose |
|------|---------|
| `Brewfile` | Core packages and applications (streamlined) |
| `Brewfile.security` | Optional security/pentesting tools |
| `zsh/.zshrc` | Main Zsh configuration |
| `zsh/custom/*.zsh` | Modular shell configuration (aliases, functions, PATH) |
| `git/.gitconfig` | Git settings with 1Password SSH signing |
| `ssh/.ssh/config` | SSH client configuration with security hardening |
| `iterm/` | iTerm2 preferences and color schemes |
| `macos/defaults.sh` | macOS system preferences |

## Customization

### Local Overrides

Create `~/.zshrc.local` for machine-specific settings (automatically sourced):

```bash
# Example: Add local API keys
export ANTHROPIC_API_KEY="sk-..."
export OPENAI_API_KEY="sk-..."
```

### SSH Hosts

Add custom SSH hosts to `~/.ssh/conf.d/` (automatically included)

### Computer Name

Edit `COMPUTER_NAME` in `macos/defaults.sh` before running the installer

## Key Technologies

- **Shell**: Zsh with [zinit](https://github.com/zdharma-continuum/zinit) plugin manager
- **Prompt**: Starship prompt (configured in `starship/config.toml`)
- **Theme**: Powerlevel10k (included in `zsh/themes/`)
- **Git Diff**: [Delta](https://github.com/dandavison/delta) for syntax-highlighted diffs
- **Python**: [uv](https://github.com/astral-sh/uv) for fast Python package management

## Updates

```bash
# Update Homebrew packages
brewu  # alias for: update, upgrade, cleanup, doctor

# Pull latest dotfiles
cd ~/.dotfiles
git pull

# Re-run installer to update symlinks
./install.sh
```

## Optional Installations

### Security Tools

```bash
brew bundle --file=~/.dotfiles/Brewfile.security
```

### Additional Tools (install as needed)

```bash
# Database servers
brew install postgresql
brew install redis

# Additional language tooling
brew install go
brew install node  # or use volta

# Terraform/Infrastructure
brew install hashicorp/tap/terraform
brew install hashicorp/tap/packer
```

## Notes

- This configuration is **macOS-only** (Linux support removed)
- Requires **1Password** for SSH key management and Git signing
- Some settings require **logout/restart** to take effect
- The installer is **idempotent** (safe to run multiple times)

## License

MIT

## Acknowledgments

Based on dotfiles from:
- [Mathias Bynens](https://mths.be/macos)
- [Paul Irish](https://github.com/paulirish/dotfiles)
- [Kevin Suttle](https://github.com/kevinSuttle/macOS-Defaults)
