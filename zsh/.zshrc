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

# Use local SSH key when connected via SSH (bypasses 1Password GUI agent)
if [ -n "$SSH_CONNECTION" ]; then
    unset SSH_AUTH_SOCK
    eval $(ssh-agent -s) > /dev/null 2>&1
    ssh-add ~/.ssh/id_github 2>/dev/null
    export GIT_CONFIG_COUNT=1
    export GIT_CONFIG_KEY_0="commit.gpgsign"
    export GIT_CONFIG_VALUE_0="false"
fi
