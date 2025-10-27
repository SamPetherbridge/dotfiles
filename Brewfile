###############################
#  Taps                       #
###############################
tap "1password/tap"
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/services"

###############################
#  Core Shell & Utilities     #
###############################

# Shells
brew "zsh"
brew "bash"

# GNU utilities (better than macOS BSD defaults)
brew "coreutils"
brew "findutils"
brew "gnu-sed"
brew "grep"
brew "make"

# Essential system tools
brew "curl"
brew "nano"
brew "openssh"
brew "openssl@3"
brew "tree"
brew "wget"
brew "htop"

# Compression & archives
brew "p7zip"
brew "unzip"
brew "xz"

###############################
#  Development Core           #
###############################

# Git
brew "git"
brew "git-lfs"
brew "gh"

# Modern CLI tools
brew "jq"        # JSON processor
brew "yq"        # YAML processor
brew "fzf"       # Fuzzy finder
brew "ripgrep"   # Fast grep alternative
brew "shellcheck" # Shell script linter
brew "shfmt"     # Shell formatter

# Build essentials
brew "autoconf"
brew "automake"
brew "pkg-config"
brew "readline"

###############################
#  Language Tooling           #
###############################

# Python
brew "uv"        # Modern Python package manager
brew "sqlite"    # Useful for local dev

# Mobile development
brew "openjdk"   # Required for Android development

# Systems programming
brew "rust"      # Rust toolchain (also useful for CLI tools)

###############################
#  Cloud & Infrastructure     #
###############################

# AWS
brew "awscli"

# Azure CLI will be installed via cask below

# Network & debugging
brew "mkcert"    # Local HTTPS certificates
brew "netcat"
brew "whois"
brew "wireguard-tools"

# Container & API tools
brew "httpie"    # Better curl for APIs

###############################
#  1Password Integration      #
###############################

brew "1password/tap/1password-cli"

###############################
#  Media & Utilities          #
###############################

brew "imagemagick"  # Image manipulation
brew "ffmpeg"       # Video/audio processing
brew "yt-dlp"       # Video downloader

###############################
#  macOS Apps via Cask        #
###############################

cask_args appdir: "/Applications"

# System Utilities
cask "the-unarchiver"

# Security & Networking
cask "1password"
cask "tailscale"

# Development Tools
cask "visual-studio-code"
cask "iterm2"
cask "docker"
cask "android-platform-tools", args: { appdir: "~/Applications" }

# Cloud SDKs
cask "google-cloud-sdk", args: { appdir: "~/Applications" }
cask "azure-cli"

# Design & Creative
cask "adobe-creative-cloud"
cask "imageoptim"

# Productivity
cask "alfred"
cask "omnifocus"
cask "hazel"
cask "keyboard-maestro"
cask "setapp"

# Communication
cask "slack"
cask "discord"
cask "zoomus"

# Browsers (choose your favorites)
cask "firefox"
cask "google-chrome"

# Development utilities
cask "sf-symbols"  # iOS/macOS development

###############################
#  Drivers                    #
###############################

cask "logi-options-plus"

###############################
#  Fonts                      #
###############################

# Primary monospace fonts (pick 2-3 favorites)
cask "font-sf-mono-nerd-font"       # SF Mono with icons
cask "font-jetbrains-mono"          # Popular dev font
cask "font-cascadia-code"           # Microsoft's dev font

# System fonts
cask "font-sf-pro"                  # macOS system font
cask "font-inter"                   # Modern UI font

###############################
#  macOS Apps via App Store   #
###############################

# Apple Development
mas "Developer", id: 640199958
mas "TestFlight", id: 899247664
mas "Compressor", id: 424390742
mas "Keynote", id: 409183694
mas "Numbers", id: 409203825
mas "Pages", id: 409201541

# Third Party
mas "1Password for Safari", id: 1569813296
mas "Amphetamine", id: 937984704
mas "Drafts", id: 1435957248
