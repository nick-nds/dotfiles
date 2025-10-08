#!/usr/bin/env bash

# Pomodoro Notification Script
# Handles notifications and sound alerts for completed sessions

session_type="$1"
round_num="$2"

# Files for tracking
TOTAL_COUNT_FILE="/tmp/pomodoro-total-count.txt"
COMPLETED_ROUNDS_FILE="/tmp/pomodoro-completed-rounds.txt"

# Initialize total count file if it doesn't exist
[ ! -f "$TOTAL_COUNT_FILE" ] && echo "0" > "$TOTAL_COUNT_FILE"
[ ! -f "$COMPLETED_ROUNDS_FILE" ] && echo "" > "$COMPLETED_ROUNDS_FILE"

# Sound files (you can customize these paths)
WORK_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"
BREAK_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"
FALLBACK_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"

# Function to play sound
play_sound() {
    local sound_file="$1"
    
    # Try different audio players in order of preference
    if command -v paplay >/dev/null 2>&1; then
        paplay "$sound_file" 2>/dev/null &
    elif command -v aplay >/dev/null 2>&1; then
        aplay "$sound_file" 2>/dev/null &
    elif command -v play >/dev/null 2>&1; then
        play "$sound_file" 2>/dev/null &
    elif command -v mpv >/dev/null 2>&1; then
        mpv --no-video --volume=50 "$sound_file" 2>/dev/null &
    fi
}

# Function to send notification
send_notification() {
    local title="$1"
    local message="$2"
    local icon="$3"
    local urgency="$4"
    local sound_file="$5"
    
    # Send desktop notification
    notify-send \
        --urgency="$urgency" \
        --icon="$icon" \
        --app-name="Pomodoro Timer" \
        "$title" \
        "$message"
    
    # Play sound if file exists
    if [[ -f "$sound_file" ]]; then
        play_sound "$sound_file"
    elif [[ -f "$FALLBACK_SOUND" ]]; then
        play_sound "$FALLBACK_SOUND"
    fi
}

# Signal wrapper to update display immediately
touch "/tmp/pomodoro-update.signal"

# Main notification logic
case "$session_type" in
    "work")
        # Use the round number passed as parameter
        round_num=${round_num:-"?"}
        
        # Increment total count
        total_count=$(cat "$TOTAL_COUNT_FILE" 2>/dev/null || echo "0")
        new_total=$((total_count + 1))
        echo "$new_total" > "$TOTAL_COUNT_FILE"
        
        # Determine next session message
        next_session=""
        if [[ "$round_num" == "4" ]]; then
            next_session="Time for a long break! 🌟"
        else
            next_session="Time for a short break! ☕"
        fi
        
        send_notification \
            "🍅 Focus Session $round_num Complete!" \
            "Great job! You completed focus session $round_num/4.
Total pomodoros today: $new_total
$next_session

Click the pomodoro icon to start your break." \
            "dialog-information" \
            "normal" \
            "$WORK_SOUND"
        ;;
        
    "short_break")
        # Use the break number passed as parameter
        break_num=${round_num:-"?"}
        next_focus=$((break_num + 1))
        
        # Mark this round as fully completed
        echo "$break_num" >> "$COMPLETED_ROUNDS_FILE"
        
        send_notification \
            "☕ Short Break $break_num Complete!" \
            "Break time is over! Ready to get back to focus?

Click the pomodoro icon to start focus session $next_focus." \
            "dialog-information" \
            "normal" \
            "$BREAK_SOUND"
        ;;
        
    "long_break")
        # Mark round 4 as fully completed
        echo "4" >> "$COMPLETED_ROUNDS_FILE"
        
        send_notification \
            "🌟 Long Break Complete!" \
            "That was a refreshing break! Ready for the next cycle?

You've completed a full pomodoro cycle (4 focus sessions). Great work!
Click the pomodoro icon to start a new cycle." \
            "dialog-information" \
            "normal" \
            "$BREAK_SOUND"
        ;;
        
    *)
        send_notification \
            "⏰ Pomodoro Timer" \
            "Session completed!" \
            "dialog-information" \
            "low" \
            "$FALLBACK_SOUND"
        ;;
esac

# Optional: Log the completion
echo "$(date): $session_type session completed" >> "/tmp/pomodoro.log"
