#!/usr/bin/env bash
# Starship-inspired statusLine for Claude Code
set -e

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
model_name=$(echo "$input" | jq -r '.model.display_name // empty')
output_style=$(echo "$input" | jq -r '.output_style.name // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
agent_name=$(echo "$input" | jq -r '.agent.name // empty')

CYAN='\e[36m'
PURPLE='\e[35m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
ORANGE='\e[38;5;208m'
RESET='\e[0m'
BOLD='\e[1m'

output=""

# Directory (truncate to 4 segments like Starship)
if [[ "$cwd" == "$project_dir" ]]; then
    dir=$(basename "$project_dir")
elif [[ "$cwd" == "$project_dir"/* ]]; then
    rel_path="${cwd#$project_dir/}"
    IFS='/' read -ra PARTS <<< "$rel_path"
    if [[ ${#PARTS[@]} -gt 4 ]]; then
        dir=".../${PARTS[-3]}/${PARTS[-2]}/${PARTS[-1]}"
    else
        dir="$rel_path"
    fi
else
    dir=$(basename "$cwd")
fi
output+="${BOLD}${CYAN}${dir}${RESET} "

# Git info
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" -c "core.fsmonitor=" -c "core.untrackedcache=" branch --show-current 2>/dev/null || echo "detached")
    output+="${BOLD}${PURPLE} ${branch}${RESET} "

    status=$(git -C "$cwd" -c "core.fsmonitor=" -c "core.untrackedcache=" status --porcelain 2>/dev/null)
    if [[ -n "$status" ]]; then
        modified=$(echo "$status" | grep -c "^ M" || true)
        staged=$(echo "$status" | grep -c "^[MARC]" || true)
        untracked=$(echo "$status" | grep -c "^??" || true)

        git_status=""
        [[ $staged -gt 0 ]] && git_status+="+${staged} "
        [[ $modified -gt 0 ]] && git_status+="!${modified} "
        [[ $untracked -gt 0 ]] && git_status+="?${untracked} "

        [[ -n "$git_status" ]] && output+="${BOLD}${RED}${git_status}${RESET}"
    fi
fi

# Python virtual environment detection
if [[ -f "$cwd/pyproject.toml" ]] || [[ -f "$cwd/requirements.txt" ]]; then
    output+="${BOLD}${YELLOW} py${RESET} "
fi

# Node.js project detection
if [[ -f "$cwd/package.json" ]]; then
    output+="${BOLD}${GREEN} node${RESET} "
fi

# Docker context detection
if [[ -f "$cwd/Dockerfile" ]] || [[ -f "$cwd/docker-compose.yml" ]]; then
    output+="${BOLD}${BLUE} docker${RESET} "
fi

# Vim mode indicator
if [[ -n "$vim_mode" ]]; then
    if [[ "$vim_mode" == "NORMAL" ]]; then
        output+="${BOLD}${GREEN}[N]${RESET} "
    else
        output+="${BOLD}${BLUE}[I]${RESET} "
    fi
fi

# Agent indicator
if [[ -n "$agent_name" ]]; then
    output+="${BOLD}${ORANGE}[${agent_name}]${RESET} "
fi

# Output style indicator (if not default)
if [[ -n "$output_style" ]] && [[ "$output_style" != "default" ]]; then
    output+="${BOLD}${PURPLE}[${output_style}]${RESET} "
fi

# Context usage
if [[ -n "$used_pct" ]]; then
    used_int=$(printf "%.0f" "$used_pct")
    if [[ $used_int -ge 80 ]]; then
        ctx_color="$RED"
    elif [[ $used_int -ge 50 ]]; then
        ctx_color="$YELLOW"
    else
        ctx_color="$GREEN"
    fi
    output+="${BOLD}${ctx_color}ctx:${used_int}%${RESET} "
fi

# Model name (shortened)
if [[ -n "$model_name" ]]; then
    short_model=$(echo "$model_name" | sed 's/Claude //' | sed 's/ (.*)//')
    output+="${CYAN}${short_model}${RESET}"
fi

printf "%b" "$output"
