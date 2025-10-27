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

### Development Tools

- **Languages**: Rust, OpenJDK, Deno, Angular CLI
- **Version Managers**: `uv` (Python), `volta` (Node.js)
- **Build Tools**: GCC, autoconf, automake, pkg-config
- **Git Tools**: Git, git-lfs, GitHub CLI (`gh`)

### Applications (via Homebrew Cask)

- **Development**: VS Code, JetBrains Toolbox, Docker, iTerm2
- **Design**: Adobe Creative Cloud, Sketch, ImageOptim
- **Productivity**: 1Password, OmniFocus, Hazel, Keyboard Maestro, Alfred
- **Communication**: Slack, Discord, Zoom
- **Browsers**: Firefox, Firefox Developer Edition, Chrome

### Security Tools

- Network scanning: nmap, nikto, nuclei, massdns
- Password cracking: hashcat, hydra, john
- Traffic analysis: mitmproxy, tcpdump, wireshark components
- Wireless: aircrack-ng, bettercap

### Shell Features

- GNU coreutils (replacing macOS BSD tools)
- Custom aliases for Git, Docker, and common operations
- Optimized PATH configuration for multiple languages
- Telemetry disabled for major development tools

## Configuration Files

| File | Purpose |
|------|---------|
| `Brewfile` | Homebrew packages and applications |
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
