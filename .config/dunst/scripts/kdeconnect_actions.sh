#!/bin/bash
# KDE Connect notification action handler
# This script is called by dunst when a KDE Connect notification is clicked

# Get notification parameters
APP_NAME="$1"
SUMMARY="$2"
BODY="$3"
ICON="$4"
ACTION="$5"

# Log for debugging
echo "KDE Connect action triggered: $APP_NAME - $SUMMARY - $ACTION" >> /tmp/dunst_kdeconnect.log

# Handle different notification types based on the summary/body
case "$SUMMARY" in
    *"Phone call"*)
        # Handle incoming calls
        if [[ "$BODY" == *"incoming"* ]]; then
            # Accept call on the phone
            kdeconnect-cli -d "$DEVICE_ID" --send-sms "AUTO: I'm busy, will call back later" "${BODY%%:*}"
        fi
        ;;
    *"SMS"*|*"Message"*)
        # Open SMS conversation
        kdeconnect-cli -d "$DEVICE_ID" --open-conversation "${BODY%%:*}"
        ;;
    *"Battery"*)
        # Just acknowledge battery notifications
        notify-send "KDE Connect" "Battery notification acknowledged"
        ;;
    *"File received"*)
        # Open the received file
        FILE_PATH=$(echo "$BODY" | grep -oP '/[^ ]+')
        if [ -f "$FILE_PATH" ]; then
            xdg-open "$FILE_PATH"
        fi
        ;;
    *)
        # Default action - focus KDE Connect
        i3-msg '[class="kdeconnect-app|kdeconnect-indicator"] focus'
        ;;
esac

# You can add more custom actions here