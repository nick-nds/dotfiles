#!/bin/bash
# Test script to generate notifications and test history

# Send a few test notifications
notify-send -u low "Low Priority" "This is a low priority test notification."
sleep 1
notify-send -u normal "Normal Priority" "This is a normal priority test notification."
sleep 1
notify-send -u critical "Critical Priority" "This is a critical priority test notification."
sleep 1

# Test KDE Connect notification
notify-send -a "KDE Connect" "SMS from John" "Hey, are you available for a call?"
sleep 1

# Test Spotify notification
notify-send -a "Spotify" "Now Playing" "Artist - Song Title"
sleep 1

echo "Notifications sent. Press Ctrl+h to view notification history."
echo "If history doesn't work, try running these commands:"
echo "xmodmap -e 'keycode 49 = grave asciitilde'"
echo "xmodmap -pke | grep grave"