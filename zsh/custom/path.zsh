#!/usr/bin/env zsh

# set PATH, MANPATH, etc., for Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
  # macOS on Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  # macOS on x86
  eval "$(/usr/local/bin/brew shellenv)"
fi

# remap macOS core utils to GNU equivalents (from coreutils, findutils, gnu-*, etc.):
# https://gist.github.com/skyzyx/3438280b18e4f7c490db8a2a2ca0b9da?permalink_comment_id=3049694#gistcomment-3049694
if command -v brew &>/dev/null; then
  for gbin in "$(brew --prefix)"/opt/*/libexec/gnubin; do
    export PATH="$gbin:$PATH"
  done
  # Ensure `man` refers to the new binaries:
  for gman in "$(brew --prefix)"/opt/*/libexec/gnuman; do
    export MANPATH="$gman:$MANPATH"
  done
  unset gbin gman

  # shellcheck disable=SC2155
  export HELPDIR="$(brew --prefix)/share/zsh/help"

  # OpenJDK
  # shellcheck disable=SC2155
  export PATH="$(brew --prefix)/opt/openjdk/bin:$PATH"

  # macOS-only fixes for rbenv/ruby
  # shellcheck disable=SC2155
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3) --with-readline-dir=$(brew --prefix readline) --with-libyaml-dir=$(brew --prefix libyaml) --with-jemalloc-dir=$(brew --prefix jemalloc)"

  # tell compilers where to find all of this stuff
  # shellcheck disable=SC2155
  export LDFLAGS="$LDFLAGS -L$(brew --prefix openssl@3)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix jemalloc)/lib"
  # shellcheck disable=SC2155
  export CPPFLAGS="$CPPFLAGS -I$(brew --prefix openjdk)/include -I$(brew --prefix openssl@3)/include -I$(brew --prefix readline)/include -I$(brew --prefix jemalloc)/include"
fi

# go
if [[ -d "$HOME/golang" ]]; then
  export GOPATH="$HOME/golang"
  export PATH="$GOPATH/bin:$PATH"
fi

# rust/cargo
if [[ -d "$HOME/.cargo" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# rbenv
if command -v rbenv &>/dev/null; then
  eval "$(rbenv init --no-rehash - zsh)"
fi

# uv tool binaries (installed via `uv tool install`)
if [[ -d "$HOME/.local/bin" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# volta
if [[ -d "$HOME/.volta" ]]; then
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
fi