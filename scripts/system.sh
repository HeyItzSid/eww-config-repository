#!/bin/bash
# System settings script
# Handles brightness, airplane mode, hotspot, and other system toggles

case "$1" in
  brightness)
    # Get current brightness (0-100)
    if command -v brightnessctl &> /dev/null; then
      brightnessctl -m | cut -d',' -f4 | tr -d '%'
    elif [ -f /sys/class/backlight/intel_backlight/brightness ]; then
      CURRENT=$(cat /sys/class/backlight/intel_backlight/brightness)
      MAX=$(cat /sys/class/backlight/intel_backlight/max_brightness)
      echo "scale=0; ($CURRENT * 100) / $MAX" | bc
    else
      echo "50"
    fi
    ;;
    
  set_brightness)
    # Set brightness to specified percentage
    if [ -z "$2" ]; then
      echo "Error: brightness value required"
      exit 1
    fi
    
    BRIGHTNESS="$2"
    
    if command -v brightnessctl &> /dev/null; then
      brightnessctl set "${BRIGHTNESS}%"
    elif [ -f /sys/class/backlight/intel_backlight/brightness ]; then
      MAX=$(cat /sys/class/backlight/intel_backlight/max_brightness)
      VALUE=$(echo "scale=0; ($MAX * $BRIGHTNESS) / 100" | bc)
      echo "$VALUE" | sudo tee /sys/class/backlight/intel_backlight/brightness > /dev/null
    fi
    ;;
    
  airplane_mode)
    # Check airplane mode status
    if command -v rfkill &> /dev/null; then
      STATUS=$(rfkill list all | grep -i "soft blocked: yes" | wc -l)
      if [ "$STATUS" -gt 0 ]; then
        echo "on"
      else
        echo "off"
      fi
    else
      echo "off"
    fi
    ;;
    
  airplane_toggle)
    # Toggle airplane mode
    if command -v rfkill &> /dev/null; then
      STATUS=$(rfkill list all | grep -i "soft blocked: yes" | wc -l)
      if [ "$STATUS" -gt 0 ]; then
        rfkill unblock all
      else
        rfkill block all
      fi
    fi
    ;;
    
  hotspot_status)
    # Check mobile hotspot status
    if command -v nmcli &> /dev/null; then
      STATUS=$(nmcli connection show --active | grep -i hotspot | wc -l)
      if [ "$STATUS" -gt 0 ]; then
        echo "on"
      else
        echo "off"
      fi
    else
      echo "off"
    fi
    ;;
    
  hotspot_toggle)
    # Toggle mobile hotspot
    if command -v nmcli &> /dev/null; then
      STATUS=$(nmcli connection show --active | grep -i hotspot | wc -l)
      if [ "$STATUS" -gt 0 ]; then
        # Turn off hotspot
        nmcli connection down Hotspot 2>/dev/null || nmcli connection down id Hotspot 2>/dev/null
      else
        # Turn on hotspot (requires pre-configured hotspot connection)
        nmcli connection up Hotspot 2>/dev/null || nmcli connection up id Hotspot 2>/dev/null
      fi
    fi
    ;;
    
  captions_toggle)
    # Toggle live captions (placeholder - requires specific implementation)
    # This would typically launch a captions service or toggle it
    notify-send "Live Captions" "Feature not yet implemented"
    ;;
    
  cast_open)
    # Open cast/projection dialog
    # This would typically open a screen sharing or casting tool
    if command -v gnome-control-center &> /dev/null; then
      gnome-control-center display &
    elif command -v arandr &> /dev/null; then
      arandr &
    else
      notify-send "Cast" "No display manager found"
    fi
    ;;
    
  *)
    echo "Usage: $0 {brightness|set_brightness <value>|airplane_mode|airplane_toggle|hotspot_status|hotspot_toggle|captions_toggle|cast_open}"
    exit 1
    ;;
esac
