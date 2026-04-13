#!/bin/bash
# Media control script
# Handles volume and playback control

case "$1" in
  volume)
    # Get current volume percentage
    if command -v pactl &> /dev/null; then
      pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%'
    else
      echo "50"
    fi
    ;;
    
  volume_up)
    # Increase volume by 5%
    if command -v pactl &> /dev/null; then
      pactl set-sink-volume @DEFAULT_SINK@ +5%
    fi
    ;;
    
  volume_down)
    # Decrease volume by 5%
    if command -v pactl &> /dev/null; then
      pactl set-sink-volume @DEFAULT_SINK@ -5%
    fi
    ;;
    
  mute_toggle)
    # Toggle mute
    if command -v pactl &> /dev/null; then
      pactl set-sink-mute @DEFAULT_SINK@ toggle
    fi
    ;;
    
  *)
    echo "Usage: $0 {volume|volume_up|volume_down|mute_toggle}"
    exit 1
    ;;
esac
