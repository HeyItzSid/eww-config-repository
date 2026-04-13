#!/bin/bash
# Network management script
# Handles WiFi, Ethernet status and controls

case "$1" in
  wifi_status)
    # Check WiFi connection status
    if command -v nmcli &> /dev/null; then
      STATUS=$(nmcli -t -f STATE,TYPE device | grep wifi | cut -d':' -f1)
      if [ "$STATUS" = "connected" ]; then
        echo "connected"
      else
        echo "disconnected"
      fi
    else
      echo "unknown"
    fi
    ;;
    
  wifi_ssid)
    # Get connected WiFi SSID
    if command -v nmcli &> /dev/null; then
      nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d':' -f2 || echo "Not connected"
    else
      echo "N/A"
    fi
    ;;
    
  wifi_strength)
    # Get WiFi signal strength (0-100)
    if command -v nmcli &> /dev/null; then
      nmcli -t -f active,signal dev wifi | grep '^yes' | cut -d':' -f2 || echo "0"
    else
      echo "0"
    fi
    ;;
    
  ethernet_status)
    # Check Ethernet connection status
    if command -v nmcli &> /dev/null; then
      STATUS=$(nmcli -t -f STATE,TYPE device | grep ethernet | cut -d':' -f1)
      if [ "$STATUS" = "connected" ]; then
        echo "connected"
      else
        echo "disconnected"
      fi
    else
      echo "unknown"
    fi
    ;;
    
  wifi_toggle)
    # Toggle WiFi on/off
    if command -v nmcli &> /dev/null; then
      CURRENT=$(nmcli radio wifi)
      if [ "$CURRENT" = "enabled" ]; then
        nmcli radio wifi off
      else
        nmcli radio wifi on
      fi
    fi
    ;;
    
  *)
    echo "Usage: $0 {wifi_status|wifi_ssid|wifi_strength|ethernet_status|wifi_toggle}"
    exit 1
    ;;
esac
