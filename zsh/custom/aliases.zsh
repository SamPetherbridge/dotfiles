#!/usr/bin/env zsh

# allow sudo-able aliases
alias sudo="sudo "

# Homebrew
alias brewu='brew update && brew upgrade && brew cleanup && brew doctor'

# Navigation shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~"
alias -- -="cd -"  # Go back to previous directory

# colorful ls
alias ls="ls -G --color=auto"
alias ll="ls -lah"
alias la="ls -a"
alias l="ll"

# easier dotfile tinkering
alias shreload="exec \$SHELL"

# git
alias g="git"
alias gc="git commit -m"  # + commit message
alias gca="git add . && git commit -m"  # + commit message
alias gs="git status -sb"
alias gl="git log --pretty=short"
alias gd="git diff"
alias gds="git diff --staged"
alias gpom="git push origin main"
alias glom="git pull origin main"
alias gpo="git push origin"  # + branch name
alias glo="git pull origin"  # + branch name
alias glfm="git fetch && git reset origin/main --hard"
alias gb="git checkout"  # + existing branch name
alias gbn="git checkout -b"  # + new branch name
alias grm="git rebase -i origin/main"
alias gsub="git submodule update --recursive --remote"
alias gundo="git reset --soft HEAD~1"
alias gres="git reset"
alias github="gh repo view --web"
alias gist="gh gist create --web"

# docker
alias dps="docker ps -a"
dbar() {
  # build and run:
  # https://stackoverflow.com/questions/45141402/build-and-run-dockerfile-with-one-command/59220656#59220656
  docker build --progress=plain --no-cache . | tee /dev/tty | tail -n1 | cut -d' ' -f3 | xargs -I{} docker run --rm -i {}
}
dsh() {
  docker exec -it "$1" /bin/sh
}
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcr="docker compose down && docker compose up -d"
alias dcl="docker compose logs -f"

# VS Code
alias vs="code ."

# Global aliases (work anywhere in the command)
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

# Quick directory access
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias dev="cd ~/Developer"

# Cleanup
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
