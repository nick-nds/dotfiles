#!/usr/bin/env bash

CONFIG_FILE="$HOME/dotfiles/scripts/farmd/profiles.conf"

# Check input
if [[ "$1" != "start" && "$1" != "stop" && "$1" != "down" ]]; then
  echo "Usage: $0 [start|stop|down]"
  exit 1
fi

# Check if config file exists
if [[ ! -f $CONFIG_FILE ]]; then
  echo "Config file $CONFIG_FILE not found!"
  exit 1
fi

# Get current git branch
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [[ -z "$BRANCH" ]]; then
  echo "Could not determine current git branch"
  exit 1
fi

# Get profiles for current branch (if any)
PROFILES=$(grep "^$BRANCH=" "$CONFIG_FILE" | cut -d'=' -f2-)
PROFILE_ARGS=" --profile reverb"

if [[ -n "$PROFILES" ]]; then
  IFS=',' read -ra PROFILE_LIST <<< "$PROFILES"
  for profile in "${PROFILE_LIST[@]}"; do
    PROFILE_ARGS+=" --profile $profile"
  done
else
  echo "No profile mapping found for branch '$BRANCH'. Running docker compose without profiles."
fi

# Construct command
if [[ "$1" == "start" ]]; then
  CMD="docker compose $PROFILE_ARGS up -d"
elif [[ "$1" == "stop" ]]; then
  CMD="docker compose $PROFILE_ARGS stop"
else
  CMD="docker compose $PROFILE_ARGS down"
fi

echo "Running: $CMD"
eval "$CMD"
