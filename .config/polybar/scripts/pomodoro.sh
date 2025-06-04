#!/usr/bin/env bash

LOG_FILE="/tmp/pomodoro-log.json"
# Total completed rounds
total_rounds=$(jq 'select(.round | test("work-.*"))' "$LOG_FILE" 2>/dev/null | jq -s 'length')

total_rounds=${total_rounds:-0}

# Read the last JSON entry and extract the "round" field
last_round=$(tail -n 1 "$LOG_FILE" | jq -r '.round')

if [[ "$last_round" == work-* ]]; then
  icon="%{F#fabd2f} %{F-}"
elif [[ "$last_round" == break-* ]]; then
  icon="%{F#83a598} 󰣉%{F-}"
fi

if [ "$total_rounds" -eq 0 ]; then
  # All incomplete
  echo " %{F#83a598} 󰣉%{F-}     (0)"
  exit 0
fi

progress_round=$(( total_rounds % 4 ))
[ "$progress_round" -eq 0 ] && progress_round=4

# Colored apples ( in red) and grey dots ()
completed=""
for _ in $(seq 1 $progress_round); do
  completed+=" %{F#ff5f5f} %{F-}"
done

remaining=$((4 - progress_round))
incomplete=""
for _ in $(seq 1 $remaining); do
  incomplete+=" "
done

# Output
echo " $icon$completed$incomplete ($total_rounds)"
