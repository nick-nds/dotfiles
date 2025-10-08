#!/bin/bash

# Battery Watcher Script
# Monitors battery level and shows notifications when unplugged and low
# Author: Niku Nitin
# Usage: ./battery-watcher.sh

# Configuration
readonly LOW_BATTERY_THRESHOLD=20
readonly CRITICAL_BATTERY_THRESHOLD=10
readonly CHECK_INTERVAL=60
readonly NOTIFICATION_INTERVAL=5  # Show notification every 5 cycles
readonly SOUND_FILE="/usr/share/sounds/freedesktop/stereo/suspend-error.oga"
readonly LOCK_SCRIPT="$HOME/dotfiles/scripts/lock-screen"

# Global variables
NOTIFICATION_COUNTER=0

# Function to check if required commands exist
check_dependencies() {
    local missing_deps=()
    
    command -v acpi >/dev/null 2>&1 || missing_deps+=("acpi")
    command -v notify-send >/dev/null 2>&1 || missing_deps+=("notify-send")
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo "Error: Missing required dependencies: ${missing_deps[*]}" >&2
        echo "Please install them before running this script." >&2
        exit 1
    fi
}

# Function to get battery level
get_battery_level() {
    local level
    level=$(acpi -b 2>/dev/null | grep -P -o '[0-9]+(?=%)' | head -n1)
    
    if [ -z "$level" ]; then
        echo "Error: Unable to read battery level" >&2
        return 1
    fi
    
    echo "$level"
}

# Function to check if AC adapter is connected
is_ac_connected() {
    acpi -a 2>/dev/null | grep -q "on-line"
}

# Function to play notification sound
play_notification_sound() {
    if [ -f "$SOUND_FILE" ]; then
        paplay "$SOUND_FILE" 2>/dev/null || echo -e '\a'
    else
        echo -e '\a'  # Fallback to terminal bell
    fi
}

# Function to send low battery notification
send_low_battery_notification() {
    local battery_level=$1
    notify-send -u normal "Battery Low" "Battery is at ${battery_level}%"
    play_notification_sound
}

# Function to send critical battery notification and suspend
send_critical_battery_notification() {
    local battery_level=$1
    notify-send -u critical "Battery Critical" "Battery is at ${battery_level}%, suspending..."
    play_notification_sound
    
    # Lock screen and suspend
    if [ -x "$LOCK_SCRIPT" ]; then
        "$LOCK_SCRIPT" && sleep 1 && systemctl suspend
    else
        systemctl suspend
    fi
}

# Main monitoring loop
main() {
    check_dependencies
    
    echo "Battery watcher started. Monitoring every ${CHECK_INTERVAL} seconds..."
    
    while true; do
        battery_level=$(get_battery_level) || continue
        
        # Only show notifications when AC adapter is not connected
        if ! is_ac_connected; then
            if [ "$battery_level" -le "$CRITICAL_BATTERY_THRESHOLD" ]; then
                send_critical_battery_notification "$battery_level"
            elif [ "$battery_level" -le "$LOW_BATTERY_THRESHOLD" ]; then
                # Show notification every NOTIFICATION_INTERVAL cycles
                if [ $((NOTIFICATION_COUNTER % NOTIFICATION_INTERVAL)) -eq 0 ]; then
                    send_low_battery_notification "$battery_level"
                fi
                NOTIFICATION_COUNTER=$((NOTIFICATION_COUNTER + 1))
            else
                NOTIFICATION_COUNTER=0
            fi
        else
            # Reset counter when plugged in
            NOTIFICATION_COUNTER=0
        fi
        
        sleep "$CHECK_INTERVAL"
    done
}

# Handle script termination
trap 'echo "Battery watcher stopped."; exit 0' SIGINT SIGTERM

# Run main function
main "$@"
