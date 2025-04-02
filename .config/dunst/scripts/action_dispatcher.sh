#!/bin/bash
# Dunst Action Dispatcher
# This script is used as a central dispatcher for all notification actions
# It determines which app-specific handler to call based on the notification data

# Get notification parameters
APP_NAME="$1"
SUMMARY="$2"
BODY="$3"
ICON="$4"
ACTION="${5:-default}"

# Log the notification for debugging
echo "$(date): $APP_NAME - $SUMMARY - $ACTION" >> /tmp/dunst_actions.log

# Set path to scripts directory
SCRIPTS_DIR="$HOME/.config/dunst/scripts"

# Dispatch based on the application name
case "$APP_NAME" in
    "KDE Connect"|"kdeconnect"|"org.kde.kdeconnect")
        # Handle KDE Connect notifications
        "$SCRIPTS_DIR/kdeconnect_actions.sh" "$APP_NAME" "$SUMMARY" "$BODY" "$ICON" "$ACTION"
        ;;
    "Spotify"|"spotify")
        # Handle Spotify notifications
        i3-msg '[class="Spotify"] focus'
        ;;
    "Slack"|"slack")
        # Handle Slack notifications
        i3-msg '[class="Slack"] focus'
        ;;
    "Firefox"|"firefox"|"firedragon")
        # Handle browser notifications
        i3-msg '[class="Firefox|Firedragon"] focus'
        ;;
    "Signal"|"signal")
        # Handle Signal notifications
        i3-msg '[class="Signal"] focus'
        ;;
    *)
        # Default action - try to focus the app if we can guess the window class
        # WINDOW_CLASS=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')
        # i3-msg "[class=\"$WINDOW_CLASS\"] focus" 2>/dev/null || \
        # i3-msg "[title=\"$APP_NAME\"] focus" 2>/dev/null || \
        # echo "No specific action for $APP_NAME" >> /tmp/dunst_actions.log
        # ;;
esac

# If we have a URL in the body, offer to open it
if echo "$BODY" | grep -q "https\?://"; then
    URL=$(echo "$BODY" | grep -o "https\?://[^ ]*")
    notify-send -t 3000 "Open URL?" "$URL\n\nClick to open" -a "ActionDispatcher" \
        -A "open=Open in browser" -A "copy=Copy to clipboard"
    case "$ACTION" in
        "open")
            xdg-open "$URL"
            ;;
        "copy")
            echo "$URL" | xclip -selection clipboard
            notify-send "URL copied to clipboard" "$URL" -t 2000
            ;;
    esac
fi

exit 0
