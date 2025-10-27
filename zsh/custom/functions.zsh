#!/usr/bin/env zsh

# Make a new directory and `cd` right into it (this seems like a no-brainer)
mkcd() {
  mkdir -p -- "$1" &&
  cd -P -- "$1" || return
}
