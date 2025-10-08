#!/usr/bin/env bash

# Pomodoro Control Script
# Handles click actions for the Polybar pomodoro module

action="$1"

case "$action" in
    "toggle"|"start_stop")
        # Toggle timer (start/pause)
        ~/.config/polybar/scripts/pomodoro/wrapper.sh toggle
        ;;
    "skip"|"next")
        # Skip current session
        ~/.config/polybar/scripts/pomodoro/wrapper.sh skip
        ;;
    "reset")
        # Reset rounds and stop timer
        ~/.config/polybar/scripts/pomodoro/wrapper.sh reset
        notify-send "🍅 Pomodoro Reset" "Timer completely stopped and rounds reset to 0."
        ;;
    "status")
        # Show current status
        ~/.config/polybar/scripts/pomodoro/wrapper.sh status
        ;;
    *)
        echo "Usage: $0 {toggle|skip|reset|status}"
        exit 1
        ;;
esac
