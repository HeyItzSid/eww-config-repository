#!/bin/bash
# Workspace management script
# Handles workspace detection and switching

# Detect window manager
detect_wm() {
  if command -v wmctrl &> /dev/null; then
    echo "wmctrl"
  elif command -v xdotool &> /dev/null; then
    echo "xdotool"
  elif command -v swaymsg &> /dev/null; then
    echo "sway"
  else
    echo "none"
  fi
}

WM=$(detect_wm)

case "$1" in
  current)
    # Get current workspace number
    case "$WM" in
      wmctrl)
        wmctrl -d | grep '\*' | awk '{print $1 + 1}'
        ;;
      xdotool)
        xdotool get_desktop | awk '{print $1 + 1}'
        ;;
      sway)
        swaymsg -t get_workspaces | jq '.[] | select(.focused==true) | .num'
        ;;
      *)
        echo "1"
        ;;
    esac
    ;;
    
  count)
    # Get total number of workspaces
    case "$WM" in
      wmctrl)
        wmctrl -d | wc -l
        ;;
      xdotool)
        xdotool get_num_desktops
        ;;
      sway)
        swaymsg -t get_workspaces | jq 'length'
        ;;
      *)
        echo "4"
        ;;
    esac
    ;;
    
  switch)
    # Switch to specified workspace
    if [ -z "$2" ]; then
      echo "Error: workspace number required"
      exit 1
    fi
    
    WORKSPACE=$((${2} - 1))  # Convert to 0-indexed
    
    case "$WM" in
      wmctrl)
        wmctrl -s "$WORKSPACE"
        ;;
      xdotool)
        xdotool set_desktop "$WORKSPACE"
        ;;
      sway)
        swaymsg workspace number "$2"
        ;;
      *)
        echo "Error: no window manager detected"
        exit 1
        ;;
    esac
    ;;
    
  *)
    echo "Usage: $0 {current|count|switch <number>}"
    exit 1
    ;;
esac
