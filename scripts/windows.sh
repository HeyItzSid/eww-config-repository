#!/bin/bash
# Window management script
# Lists windows and handles window switching

case "$1" in
  list)
    # List all windows with ID|Title|Icon format
    if command -v wmctrl &> /dev/null; then
      wmctrl -l | while read -r line; do
        WIN_ID=$(echo "$line" | awk '{print $1}')
        WIN_TITLE=$(echo "$line" | cut -d' ' -f5-)
        WIN_CLASS=$(xprop -id "$WIN_ID" WM_CLASS 2>/dev/null | cut -d'"' -f4)
        
        # Try to find icon for the window class
        ICON_PATH="/usr/share/icons/hicolor/48x48/apps/${WIN_CLASS}.png"
        if [ ! -f "$ICON_PATH" ]; then
          ICON_PATH="/usr/share/pixmaps/${WIN_CLASS}.png"
        fi
        if [ ! -f "$ICON_PATH" ]; then
          ICON_PATH="/usr/share/icons/hicolor/48x48/apps/application-x-executable.png"
        fi
        
        echo "${WIN_ID}|${WIN_TITLE}|${ICON_PATH}"
      done
    else
      echo ""
    fi
    ;;
    
  active)
    # Get active window ID
    if command -v xdotool &> /dev/null; then
      xdotool getactivewindow 2>/dev/null | xargs printf "0x%08x\n" 2>/dev/null || echo ""
    elif command -v wmctrl &> /dev/null; then
      wmctrl -l | grep -E '\s+\*\s+' | awk '{print $1}' || echo ""
    else
      echo ""
    fi
    ;;
    
  switch)
    # Switch to specified window by ID
    if [ -z "$2" ]; then
      echo "Error: window ID required"
      exit 1
    fi
    
    if command -v wmctrl &> /dev/null; then
      wmctrl -ia "$2"
    else
      echo "Error: wmctrl not found"
      exit 1
    fi
    ;;
    
  *)
    echo "Usage: $0 {list|active|switch <window_id>}"
    exit 1
    ;;
esac
