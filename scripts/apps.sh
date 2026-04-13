#!/bin/bash
# Application management script
# Handles app search, running apps detection, and launching

DESKTOP_FILES_DIRS=(
  "/usr/share/applications"
  "/usr/local/share/applications"
  "$HOME/.local/share/applications"
)

case "$1" in
  search)
    # Search for applications matching query
    QUERY="$2"
    
    if [ -z "$QUERY" ]; then
      exit 0
    fi
    
    # Search through desktop files
    for DIR in "${DESKTOP_FILES_DIRS[@]}"; do
      if [ -d "$DIR" ]; then
        find "$DIR" -name "*.desktop" -type f | while read -r DESKTOP_FILE; do
          APP_NAME=$(grep -m 1 "^Name=" "$DESKTOP_FILE" | cut -d'=' -f2)
          APP_ID=$(basename "$DESKTOP_FILE" .desktop)
          
          # Case-insensitive search
          if echo "$APP_NAME" | grep -iq "$QUERY"; then
            # Try to find icon
            ICON=$(grep -m 1 "^Icon=" "$DESKTOP_FILE" | cut -d'=' -f2)
            ICON_PATH="/usr/share/icons/hicolor/48x48/apps/${ICON}.png"
            
            if [ ! -f "$ICON_PATH" ]; then
              ICON_PATH="/usr/share/pixmaps/${ICON}.png"
            fi
            if [ ! -f "$ICON_PATH" ]; then
              ICON_PATH="/usr/share/icons/hicolor/48x48/apps/application-x-executable.png"
            fi
            
            echo "${APP_ID}|${APP_NAME}|${ICON_PATH}"
          fi
        done | head -10  # Limit to 10 results
      fi
    done
    ;;
    
  running)
    # List running applications
    if command -v wmctrl &> /dev/null; then
      wmctrl -l | awk '{print $4}' | sort -u | tr '\n' ' '
    else
      echo ""
    fi
    ;;
    
  launch)
    # Launch application by ID
    if [ -z "$2" ]; then
      echo "Error: app ID required"
      exit 1
    fi
    
    APP_ID="$2"
    
    # Try gtk-launch first
    if command -v gtk-launch &> /dev/null; then
      gtk-launch "$APP_ID" &
    else
      # Fallback: find and execute desktop file
      for DIR in "${DESKTOP_FILES_DIRS[@]}"; do
        DESKTOP_FILE="$DIR/${APP_ID}.desktop"
        if [ -f "$DESKTOP_FILE" ]; then
          EXEC_CMD=$(grep -m 1 "^Exec=" "$DESKTOP_FILE" | cut -d'=' -f2 | sed 's/%[a-zA-Z]//g')
          eval "$EXEC_CMD" &
          exit 0
        fi
      done
      
      echo "Error: application not found"
      exit 1
    fi
    ;;
    
  *)
    echo "Usage: $0 {search <query>|running|launch <app_id>}"
    exit 1
    ;;
esac
