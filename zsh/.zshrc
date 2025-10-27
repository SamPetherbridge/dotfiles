#!/usr/bin/env zsh

# path to this directory:
export ZSH_CUSTOM=~/.dotfiles/zsh

# load .zsh files from the above dir in this order:
for _dotzsh in "$ZSH_CUSTOM"/custom/{common,env,path,aliases,functions,plugins}.zsh; do
  if [[ -f "$_dotzsh" ]]; then
    source "$_dotzsh"
  fi
done
unset _dotzsh

# macos.zsh has aliases, functions, etc specific to macOS:
if [[ "$OSTYPE" = "darwin"* ]] && [[ -f "$ZSH_CUSTOM"/custom/macos.zsh ]]; then
  source "$ZSH_CUSTOM"/custom/macos.zsh
fi

if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

# Java (Zulu OpenJDK)
if [[ -d /Library/Java/JavaVirtualMachines/zulu-17.jdk ]]; then
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
fi

# Android SDK
if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$PATH:$ANDROID_HOME/emulator
  export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

# Rust/Cargo (fallback if not already in PATH from custom/path.zsh)
if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi
