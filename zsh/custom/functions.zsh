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

  # Fetch server details from 1Password
  local host=$(op item get "$server" --fields "address" 2>/dev/null)
  local user=$(op item get "$server" --fields "username" 2>/dev/null)
  local port=$(op item get "$server" --fields "port" 2>/dev/null || echo "22")

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

  # Fetch direct IP from 1Password
  local direct_ip=$(op item get "$server" --fields "direct_ip" 2>/dev/null)
  local user=$(op item get "$server" --fields "username" 2>/dev/null)
  local port=$(op item get "$server" --fields "port" 2>/dev/null || echo "22")

  if [[ -z "$direct_ip" || "$direct_ip" == "DIRECT_IP_PLACEHOLDER" ]]; then
    echo "Error: No direct IP configured for '$server'"
    echo "Update it in 1Password: op item edit \"$server\" direct_ip=<IP>"
    return 1
  fi

  echo "→ Connecting to $server via direct IP ($direct_ip)"
  ssh -p "$port" "${user}@${direct_ip}"
}
