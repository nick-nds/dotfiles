#!/bin/bash

NOTIFIED_20=false
while true; do
  battery_level=$(acpi -b | grep -P -o '[0-9]+(?=%)')

  if [ "$battery_level" -le 20 ] && [ "$battery_level" -gt 10 ] && [ "$NOTIFIED_20" = false ]; then
    notify-send -u normal "Battery Low" "Battery is at ${battery_level}%"
    NOTIFIED_20=true
  elif [ "$battery_level" -gt 20 ]; then
    NOTIFIED_20=false
  fi

  if [ "$battery_level" -le 10 ]; then
    notify-send -u critical "Battery Critical" "Battery is at ${battery_level}%, suspending..."
    $HOME/dotfiles/scripts/lock-screen && sleep 1 && systemctl suspend
  fi

  sleep 60
done
