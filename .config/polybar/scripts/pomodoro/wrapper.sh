#!/usr/bin/env bash

# Pomodoro Wrapper Script for Polybar
# Integrates with uair timer and provides session status and round counting

STATUS_FILE="/tmp/pomodoro-status.txt"
UAIR_PID_FILE="/tmp/uair.pid"
UPDATE_SIGNAL_FILE="/tmp/pomodoro-update.signal"
TOTAL_COUNT_FILE="/tmp/pomodoro-total-count.txt"
COMPLETED_ROUNDS_FILE="/tmp/pomodoro-completed-rounds.txt"

# Initialize files if they don't exist
[ ! -f "$STATUS_FILE" ] && echo "IDLE" > "$STATUS_FILE"
[ ! -f "$TOTAL_COUNT_FILE" ] && echo "0" > "$TOTAL_COUNT_FILE"
[ ! -f "$COMPLETED_ROUNDS_FILE" ] && echo "" > "$COMPLETED_ROUNDS_FILE"

# Function to get current session info from uair
get_session_info() {
    local uair_output
    if is_uair_running; then
        # Try to get current session info
        local time_name
        time_name=$(timeout 1 uairctl fetch "{time}|{name}" 2>/dev/null || echo "Ready|Idle")
        
        # Determine session type and round based on name
        local session_id="idle"
        local round_num="0"
        if [[ "$time_name" == *"|Focus 1" ]]; then
            session_id="work"
            round_num="1"
        elif [[ "$time_name" == *"|Focus 2" ]]; then
            session_id="work"
            round_num="2"
        elif [[ "$time_name" == *"|Focus 3" ]]; then
            session_id="work"
            round_num="3"
        elif [[ "$time_name" == *"|Focus 4" ]]; then
            session_id="work"
            round_num="4"
        elif [[ "$time_name" == *"|Short Break"* ]]; then
            session_id="short_break"
            # Extract round from break number
            if [[ "$time_name" == *"1"* ]]; then
                round_num="1"
            elif [[ "$time_name" == *"2"* ]]; then
                round_num="2"
            elif [[ "$time_name" == *"3"* ]]; then
                round_num="3"
            fi
        elif [[ "$time_name" == *"|Long Break" ]]; then
            session_id="long_break"
            round_num="4"
        fi
        
        echo "${time_name}|${session_id}|${round_num}"
    else
        echo "Ready|Idle|idle|0"
    fi
}

# Function to format display based on session status
format_display() {
    local time="$1"
    local name="$2"
    local session_id="$3"
    local round_num="$4"
    
    # Determine icon and color based on session
    local icon color
    case "$session_id" in
        "work")
            icon="󰔟"  # Tomato icon for focus/work
            color="%{F#83a598}"  # Blue for focus
            ;;
        "short_break")
            icon=""  # Coffee icon for short break
            color="%{F#fabd2f}"  # Yellow for break
            ;;
        "long_break")
            icon=""  # Star icon for long break
            color="%{F#8ec07c}"  # Green for long break
            ;;
        *)
            icon="⏸"  # Pause icon for idle
            color="%{F#a89984}"  # Gray for idle
            ;;
    esac
    
    # Format time display - show only time, no "Ready" text
    local display_time
    if [[ "$time" == "00:00" || -z "$time" ]]; then
        display_time="--:--"
    else
        display_time="$time"
    fi
    
    # Create progress indicator based on session state
    local progress_dots=""
    local current_round=${round_num:-0}
    
    # Read completed rounds
    local completed_rounds
    completed_rounds=$(cat "$COMPLETED_ROUNDS_FILE" 2>/dev/null || echo "")
    
    # Track completion state for each round
    for ((i=1; i<=4; i++)); do
        # Check if this round is in the completed rounds list
        if echo "$completed_rounds" | grep -q "^$i$"; then
            # This round is fully completed (work + break)
            progress_dots+="%{F#fb4934}●%{F-}"  # Red filled circle
        elif [[ $current_round -gt 0 && $i -lt $current_round ]]; then
            # Previous rounds where we skipped to next work before completing break
            progress_dots+="%{F#fabd2f}●%{F-}"  # Yellow filled circle (only work completed)
        elif [[ $current_round -gt 0 && $i -eq $current_round ]]; then
            # Current round (only if we're not idle)
            if [[ "$session_id" == "work" ]]; then
                # Currently in work session
                progress_dots+="%{F#83a598}●%{F-}"  # Blue filled circle (in progress)
            elif [[ "$session_id" == "short_break" || "$session_id" == "long_break" ]]; then
                # Currently in break (work was completed)
                progress_dots+="%{F#fabd2f}●%{F-}"  # Yellow filled circle
            else
                # Idle state
                progress_dots+="%{F#504945}●%{F-}"  # Gray filled circle
            fi
        else
            # Future rounds or idle state - not started
            progress_dots+="%{F#504945}●%{F-}"  # Gray filled circle (empty state)
        fi
    done
    
    # Get total count
    local total_count
    total_count=$(cat "$TOTAL_COUNT_FILE" 2>/dev/null || echo "0")
    
    # Compact output: icon + time + dots + total count
    if [[ $total_count -gt 0 ]]; then
        echo "${color}${icon}%{F-} ${display_time} ${progress_dots} %{F#928374}(${total_count})%{F-}"
    else
        echo "${color}${icon}%{F-} ${display_time} ${progress_dots}"
    fi
}

# Function to check if uair is running
is_uair_running() {
    pgrep -f "uair" > /dev/null
}

# Function to start uair if not running
ensure_uair_running() {
    if ! is_uair_running; then
        nohup uair > /dev/null 2>&1 &
        echo $! > "$UAIR_PID_FILE"
        sleep 1
    fi
}

# Main loop for continuous output
main_loop() {
    ensure_uair_running
    
    while true; do
        local session_info
        session_info=$(get_session_info)
        
        # Parse uair output: time|name|id|round
        IFS='|' read -r time name session_id round_num <<< "$session_info"
        
        # Default values if parsing failed
        time=${time:-"Ready"}
        name=${name:-"Idle"}
        session_id=${session_id:-"idle"}
        round_num=${round_num:-"0"}
        
        # Update status file
        echo "$session_id" > "$STATUS_FILE"
        
        # Format and output display
        format_display "$time" "$name" "$session_id" "$round_num"
        
        # Check for update signal for immediate refresh
        if [[ -f "$UPDATE_SIGNAL_FILE" ]]; then
            rm -f "$UPDATE_SIGNAL_FILE" 2>/dev/null
            # Immediate update - no sleep
            continue
        fi
        
        # Normal sleep interval
        sleep 1
    done
}

# Handle command line arguments
case "${1:-main}" in
    "toggle")
        ensure_uair_running
        uairctl toggle
        # Signal immediate update
        touch "$UPDATE_SIGNAL_FILE"
        ;;
    "skip")
        ensure_uair_running
        
        # Get current session to check if we're at the end
        session_info=$(get_session_info)
        IFS='|' read -r time name session_id round_num <<< "$session_info"
        
        # If skipping a work session, increment the total count
        if [[ "$session_id" == "work" ]]; then
            total_count=$(cat "$TOTAL_COUNT_FILE" 2>/dev/null || echo "0")
            echo $((total_count + 1)) > "$TOTAL_COUNT_FILE"
        fi
        
        # If skipping a break, mark the round as fully completed
        if [[ "$session_id" == "short_break" || "$session_id" == "long_break" ]]; then
            # Mark this round as completed
            echo "$round_num" >> "$COMPLETED_ROUNDS_FILE"
        fi
        
        if [[ "$session_id" == "long_break" ]]; then
            # At the end of cycle, clear completed rounds and jump back to first work session
            echo "" > "$COMPLETED_ROUNDS_FILE"
            uairctl jump work1
        else
            # Normal skip to next session
            uairctl next
        fi
        
        # Signal immediate update after skip
        touch "$UPDATE_SIGNAL_FILE"
        ;;
    "reset")
        # Stop any running uair processes
        pkill -f "uair" 2>/dev/null || true
        
        # Reset files
        echo "IDLE" > "$STATUS_FILE"
        
        # Clean up PID file
        rm -f "$UAIR_PID_FILE" 2>/dev/null || true
        
        # Wait a moment for processes to terminate
        sleep 1
        # Signal immediate update after reset
        touch "$UPDATE_SIGNAL_FILE"
        ;;
    "status")
        # Get current session info
        session_info=$(get_session_info)
        IFS='|' read -r time name session_id round_num <<< "$session_info"
        round_num=${round_num:-"0"}
        
        # Create compact status with just dots
        progress_dots=""
        for ((i=1; i<=round_num; i++)); do
            progress_dots+="●"
        done
        for ((i=round_num+1; i<=4; i++)); do
            progress_dots+="○"
        done
        
        echo "${progress_dots}"
        ;;
    "main"|*)
        main_loop
        ;;
esac
