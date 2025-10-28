#!/usr/bin/env zsh

# Load zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ -d "$ZINIT_HOME" ]]; then
  source "${ZINIT_HOME}/zinit.zsh"

  # Load Powerlevel10k theme
  zinit ice depth=1
  zinit light romkatv/powerlevel10k

  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

  # Load essential plugins
  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-completions

  # Load OMZ library snippets (useful utilities without full OMZ)
  zinit snippet OMZL::git.zsh
  zinit snippet OMZL::clipboard.zsh
  zinit snippet OMZL::completion.zsh
  zinit snippet OMZL::key-bindings.zsh

  # Load OMZ plugins
  zinit snippet OMZP::git
  zinit snippet OMZP::colored-man-pages
  zinit snippet OMZP::command-not-found

  # FZF integration
  if command -v fzf &>/dev/null; then
    zinit snippet OMZP::fzf
  fi

  # Load completions
  autoload -Uz compinit
  compinit

  # Turbo mode for faster startup
  zinit cdreplay -q
fi
