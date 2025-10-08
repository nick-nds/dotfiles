#!/usr/bin/env bash

# Complete Pomodoro Reset Script
# Ensures all processes are stopped and state is cleared

STATUS_FILE="/tmp/pomodoro-status.txt"
UAIR_PID_FILE="/tmp/uair.pid"
UPDATE_SIGNAL_FILE="/tmp/pomodoro-update.signal"
TOTAL_COUNT_FILE="/tmp/pomodoro-total-count.txt"
COMPLETED_ROUNDS_FILE="/tmp/pomodoro-completed-rounds.txt"

# Check if --full flag is passed to reset total count
RESET_TOTAL=false
if [[ "$1" == "--full" ]]; then
    RESET_TOTAL=true
fi

echo "🔄 Resetting Pomodoro Timer..."

# Kill all uair processes
echo "Stopping uair processes..."
pkill -f "uair" 2>/dev/null && echo "✓ uair processes stopped" || echo "✓ No uair processes running"

# Kill any uairctl processes
pkill -f "uairctl" 2>/dev/null

# Reset state files
echo "IDLE" > "$STATUS_FILE"
echo "" > "$COMPLETED_ROUNDS_FILE"
echo "✓ State files reset"

# Clean up PID file and signal file
rm -f "$UAIR_PID_FILE" 2>/dev/null && echo "✓ PID file cleaned" || echo "✓ No PID file found"
rm -f "$UPDATE_SIGNAL_FILE" 2>/dev/null

# Signal update to polybar
touch "$UPDATE_SIGNAL_FILE"

# Reset total count if requested
if [[ "$RESET_TOTAL" == "true" ]]; then
    echo "0" > "$TOTAL_COUNT_FILE"
    echo "✓ Total count reset to 0"
fi

# Wait for processes to fully terminate
sleep 2

# Send notification
if [[ "$RESET_TOTAL" == "true" ]]; then
    notify-send "🍅 Pomodoro Full Reset Complete" "All timers stopped and total count reset to 0. Ready for a fresh start!"
else
    total_count=$(cat "$TOTAL_COUNT_FILE" 2>/dev/null || echo "0")
    notify_msg="All timers stopped. Total pomodoros completed: $total_count. Ready for a fresh start!"
    notify-send "🍅 Pomodoro Reset Complete" "$notify_msg"
fi

echo "✅ Pomodoro reset complete! You can now start fresh."
