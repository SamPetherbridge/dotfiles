#!/usr/bin/env zsh
# Make a new directory and `cd` right into it (this seems like a no-brainer)
mkcd() {
  mkdir -p -- "$1" &&
  cd -P -- "$1" || return
}
# SSH via 1Password (prefers Tailscale, falls back to direct IP)
ssop() {
  local server="$1"
  if [[ -z "$server" ]]; then
    echo "Usage: ssop <server-name>"
    echo "Available servers:"
    op item list --tags ssh-server --format json 2>/dev/null | jq -r '.[] | "  - \(.title)"'
    return 1
  fi
  if ! command -v op &>/dev/null; then
    echo "Error: 1Password CLI not found. Install with: brew install --cask 1password-cli"
    return 1
  fi
  # Fetch server details from 1Password (--reveal needed to get actual values)
  local host=$(op item get "$server" --fields "address" --reveal 2>/dev/null)
  local user=$(op item get "$server" --fields "username" --reveal 2>/dev/null)
  local port=$(op item get "$server" --fields "port" --reveal 2>/dev/null || echo "22")
  
  # Default port if empty
  [[ -z "$port" ]] && port="22"
  
  if [[ -z "$host" ]]; then
    echo "Error: Server '$server' not found in 1Password"
    echo "Available servers:"
    op item list --tags ssh-server --format json 2>/dev/null | jq -r '.[] | "  - \(.title)"'
    return 1
  fi
  echo "→ Connecting to $server via Tailscale ($host)"
  ssh -p "$port" "${user}@${host}"
}

# SSH via 1Password using direct IP (bypasses Tailscale)
ssop-direct() {
  local server="$1"
  if [[ -z "$server" ]]; then
    echo "Usage: ssop-direct <server-name>"
    return 1
  fi
  if ! command -v op &>/dev/null; then
    echo "Error: 1Password CLI not found."
    return 1
  fi
  # Fetch direct IP from 1Password (--reveal needed to get actual values)
  local direct_ip=$(op item get "$server" --fields "direct_ip" --reveal 2>/dev/null)
  local user=$(op item get "$server" --fields "username" --reveal 2>/dev/null)
  local port=$(op item get "$server" --fields "port" --reveal 2>/dev/null || echo "22")
  
  # Default port if empty
  [[ -z "$port" ]] && port="22"
  
  if [[ -z "$direct_ip" || "$direct_ip" == "DIRECT_IP_PLACEHOLDER" ]]; then
    echo "Error: No direct IP configured for '$server'"
    echo "Update it in 1Password: op item edit \"$server\" direct_ip=<IP>"
    return 1
  fi
  echo "→ Connecting to $server via direct IP ($direct_ip)"
  ssh -p "$port" "${user}@${direct_ip}"
}

# SSH wrapper - change terminal colors for remote sessions (Ghostty)
# This wraps the base ssh command; ssop/ssop-direct will inherit this
ssh() {
  if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    printf '\e]11;#1a1517\e\\'  # Warm/red-tinted background
    printf '\e]10;#e8e0e0\e\\'  # Slightly warm foreground
  fi
  
  command ssh "$@"
  local ret=$?
  
  if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    printf '\e]111\e\\'  # Reset background
    printf '\e]110\e\\'  # Reset foreground
  fi
  
  return $ret
}
