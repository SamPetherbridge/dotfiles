###############################
#  Taps                       #
###############################
tap "1password/tap"
# Note: homebrew/cask, homebrew/cask-fonts, homebrew/bundle, and homebrew/services
# are now built into Homebrew core and no longer need to be tapped

###############################
#  Core Shell & Utilities     #
###############################

# Shells
brew "zsh"
brew "bash"
brew "starship"                # Cross-shell prompt
brew "zsh-autosuggestions"     # Fish-like autosuggestions for zsh

# GNU utilities (better than macOS BSD defaults)
brew "coreutils"
brew "findutils"
brew "gnu-sed"
brew "grep"
brew "make"

# Essential system tools
brew "mas"       # Mac App Store CLI (used by mas entries below)
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
brew "git-delta" # Better git diffs (used as pager in .gitconfig)
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
brew "openjdk"      # Required for Android development
brew "fastlane"     # iOS/Android CI/CD automation
brew "swiftlint"    # Swift code linting
brew "swiftformat"  # Swift code formatting

# JavaScript
brew "node"            # Node.js runtime

# Systems programming
brew "rust"         # Rust toolchain (also useful for CLI tools)

# Static site generation
brew "hugo"         # Static site generator

###############################
#  Cloud & Infrastructure     #
###############################

# AWS
brew "awscli"

# Azure
brew "azure-cli"

# Network & debugging
brew "mkcert"    # Local HTTPS certificates
brew "netcat"
brew "whois"
brew "wireguard-tools"

# Container & API tools
brew "httpie"    # Better curl for APIs
cask "postman"   # API testing tool

###############################
#  1Password Integration      #
###############################

brew "1password-cli"           # 1Password CLI (moved to core homebrew)

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
cask "tailscale-app"                           # Tailscale VPN (renamed from tailscale)

# Development Tools
cask "visual-studio-code"
cask "iterm2"
cask "ghostty"                                 # GPU-accelerated terminal
cask "warp"                                    # Modern terminal
cask "orbstack"                                # Docker & Linux VM (replaces Docker Desktop)
cask "android-platform-tools", args: { appdir: "~/Applications" }
cask "jetbrains-toolbox"                       # IntelliJ/Android Studio
cask "xcodes-app"                              # Xcode version manager (renamed from xcodes)
cask "chromedriver"                            # Selenium WebDriver

# Cloud SDKs
cask "gcloud-cli"                              # Google Cloud CLI (renamed from google-cloud-sdk)
cask "powershell"                              # PowerShell Core

# Design & Creative
cask "adobe-creative-cloud"
cask "imageoptim"
cask "omnigraffle"                             # Diagramming tool

# Productivity
cask "alfred"
cask "omnifocus"
cask "hazel"
cask "keyboard-maestro"
cask "bettertouchtool"                         # Input customization & window management
cask "setapp"
cask "microsoft-word"
cask "microsoft-excel"
cask "microsoft-powerpoint"

# Communication
cask "slack"
cask "discord"
cask "zoom"
cask "whatsapp"                                # Direct install (prefer over MAS)

# Utilities
cask "cyberduck"                               # FTP/cloud storage client

# Browsers
cask "firefox"
cask "google-chrome"
cask "microsoft-edge"

# AI Tools
cask "chatgpt"                                 # ChatGPT desktop app
cask "claude"                                  # Claude desktop app
cask "claude-code"                             # Claude Code CLI
cask "codex"                                   # OpenAI Codex CLI

# Development utilities
cask "sf-symbols"  # iOS/macOS development

###############################
#  Fonts                      #
###############################

# Primary monospace fonts (pick 2-3 favorites)
cask "font-sf-mono-nerd-font-ligaturized" # SF Mono with nerd font icons
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

# Development Tools (MAS)
mas "RocketSim", id: 1504940162                # iOS simulator enhancer
mas "DevCleaner", id: 1388020431               # Xcode cache cleaner
mas "CustomSymbols", id: 1566662030            # SF Symbols extension

# Productivity
mas "1Password for Safari", id: 1569813296
mas "Amphetamine", id: 937984704
mas "Drafts", id: 1435957248
mas "Fantastical", id: 975937182
mas "Cardhop", id: 1290358394                  # Contacts manager
mas "Tot", id: 1491071483                      # Quick notes

# Writing & Reading
mas "iA Writer", id: 775737590

# Design & Media
mas "Pixelmator Pro", id: 1289583905           # Image editor
mas "Photomator", id: 1444636541               # Photo editor
mas "Pastel", id: 413897608                    # Color picker
mas "Picasso", id: 6472062986                  # Design tool

# Utilities
mas "Screens 5", id: 1663047912                # Remote desktop
mas "Dark Noise", id: 1465439395               # Ambient sounds
mas "Termius", id: 1176074088                  # SSH client
