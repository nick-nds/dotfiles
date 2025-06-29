#!/bin/bash

# Enhanced i3lock screen with visual effects
# Optimized for speed and proper display

# Configuration
LOCK_PID_FILE="/tmp/i3lock.pid"
TEMP_DIR="/tmp/lockscreen-$$"
SCREENSHOT="$TEMP_DIR/screenshot.png"
FINAL="$TEMP_DIR/final.png"

# Gruvbox color scheme
BG_COLOR="#282828"
FG_COLOR="#ebdbb2"
FG_DIM="#a89984"
AQUA="#689d6a"

# Check if already locked
if [ -f "$LOCK_PID_FILE" ]; then
    PID=$(cat "$LOCK_PID_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Screen already locked (PID: $PID)"
        exit 1
    fi
fi

# Create temp directory
mkdir -p "$TEMP_DIR"

# Cleanup function
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Check for required tools
if ! command -v i3lock &> /dev/null; then
    echo "Error: i3lock is not installed"
    exit 1
fi

# Determine screenshot tool
if command -v scrot &> /dev/null; then
    SCREENSHOT_CMD="scrot -o"
elif command -v maim &> /dev/null; then
    SCREENSHOT_CMD="maim"
else
    echo "Error: No screenshot tool found"
    exit 1
fi

# Determine image tool
if command -v magick &> /dev/null; then
    CONVERT_CMD="magick"
elif command -v convert &> /dev/null; then
    CONVERT_CMD="convert"
else
    echo "Error: ImageMagick not found"
    exit 1
fi

# Lock screen first with simple color (instant lock)
i3lock --nofork --color="$BG_COLOR" &
LOCK_PID=$!
echo $LOCK_PID > "$LOCK_PID_FILE"

# Now create the fancy image in background
(
    # Take screenshot
    $SCREENSHOT_CMD "$SCREENSHOT" 2>/dev/null

    # Get screen resolution
    RESOLUTION=$($CONVERT_CMD identify -format "%wx%h" "$SCREENSHOT" 2>/dev/null)
    WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
    HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2)

    # Create blurred background with all elements in one pass
    TIME_TEXT=$(date '+%H:%M')
    DATE_TEXT=$(date '+%A, %B %d %Y')
    
    # Get system info
    BATTERY=""
    if command -v acpi &> /dev/null; then
        BATTERY=$(acpi -b 2>/dev/null | grep -oP '\d+%' | head -1)
        [ ! -z "$BATTERY" ] && BATTERY="Battery: $BATTERY"
    fi
    
    HOSTNAME=$(hostname 2>/dev/null || echo "localhost")

    # Create the final image with blur and text
    $CONVERT_CMD "$SCREENSHOT" \
        -blur 0x12 \
        -fill black -colorize 25% \
        -font "/usr/share/fonts/liberation/LiberationMono-Bold.ttf" \
        -pointsize 86 \
        -gravity center \
        -fill "rgba(0,0,0,0.3)" -annotate +2-102 "$TIME_TEXT" \
        -fill "$FG_COLOR" -annotate +0-100 "$TIME_TEXT" \
        -font "/usr/share/fonts/liberation/LiberationMono-Regular.ttf" \
        -pointsize 28 \
        -fill "$FG_DIM" -annotate +0-30 "$DATE_TEXT" \
        -pointsize 18 \
        -fill "$FG_DIM" -annotate +0+40 "Type password to unlock" \
        -gravity south \
        -pointsize 16 \
        -fill "$FG_DIM" -annotate +0+30 "$HOSTNAME" \
        $([ ! -z "$BATTERY" ] && echo "-fill '$AQUA' -annotate +0+50 '$BATTERY'") \
        "$FINAL" 2>/dev/null

    # Kill the color-only lock and replace with image
    if [ -f "$FINAL" ] && kill -0 $LOCK_PID 2>/dev/null; then
        kill $LOCK_PID 2>/dev/null
        i3lock --nofork --image="$FINAL" &
        echo $! > "$LOCK_PID_FILE"
    fi
) &

# Turn off screen after a moment
(sleep 2 && xset dpms force off) &