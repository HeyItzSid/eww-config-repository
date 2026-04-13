#!/bin/bash
# Telemetry data collection script
# Collects CPU, GPU, RAM, VRAM, FPS, network, temperatures, and fan speeds

case "$1" in
  cpu)
    # CPU percentage using top
    if command -v top &> /dev/null; then
      top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'
    else
      echo "N/A"
    fi
    ;;
    
  gpu)
    # GPU percentage using nvidia-smi
    if command -v nvidia-smi &> /dev/null; then
      nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo "N/A"
    else
      echo "N/A"
    fi
    ;;
    
  ram_used)
    # RAM used in GB
    if command -v free &> /dev/null; then
      free -g | awk '/^Mem:/ {printf "%.1f", $3}'
    else
      echo "N/A"
    fi
    ;;
    
  ram_total)
    # RAM total in GB
    if command -v free &> /dev/null; then
      free -g | awk '/^Mem:/ {print $2}'
    else
      echo "N/A"
    fi
    ;;
    
  vram_used)
    # VRAM used in GB
    if command -v nvidia-smi &> /dev/null; then
      nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits 2>/dev/null | awk '{printf "%.1f", $1/1024}' || echo "N/A"
    else
      echo "N/A"
    fi
    ;;
    
  vram_total)
    # VRAM total in GB
    if command -v nvidia-smi &> /dev/null; then
      nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null | awk '{printf "%.1f", $1/1024}' || echo "N/A"
    else
      echo "N/A"
    fi
    ;;
    
  fps)
    # FPS - placeholder (requires mangohud or similar)
    # You can integrate with mangohud or other FPS monitoring tools
    echo "60"
    ;;
    
  net_down)
    # Network download speed in MB/s
    if [ -f /proc/net/dev ]; then
      # Get bytes received, calculate speed
      RX1=$(cat /proc/net/dev | grep -E "eth0|wlan0|enp|wlp" | head -1 | awk '{print $2}')
      sleep 1
      RX2=$(cat /proc/net/dev | grep -E "eth0|wlan0|enp|wlp" | head -1 | awk '{print $2}')
      SPEED=$(echo "scale=2; ($RX2 - $RX1) / 1048576" | bc 2>/dev/null || echo "0")
      echo "$SPEED"
    else
      echo "0"
    fi
    ;;
    
  net_up)
    # Network upload speed in MB/s
    if [ -f /proc/net/dev ]; then
      # Get bytes transmitted, calculate speed
      TX1=$(cat /proc/net/dev | grep -E "eth0|wlan0|enp|wlp" | head -1 | awk '{print $10}')
      sleep 1
      TX2=$(cat /proc/net/dev | grep -E "eth0|wlan0|enp|wlp" | head -1 | awk '{print $10}')
      SPEED=$(echo "scale=2; ($TX2 - $TX1) / 1048576" | bc 2>/dev/null || echo "0")
      echo "$SPEED"
    else
      echo "0"
    fi
    ;;
    
  cpu_temp)
    # CPU temperature using sensors
    if command -v sensors &> /dev/null; then
      sensors | grep -E "Core 0|Tctl|CPU" | head -1 | awk '{print $3}' | sed 's/+//;s/°C//' | cut -d'.' -f1 || echo "N/A"
    else
      echo "N/A"
    fi
    ;;
    
  gpu_temp)
    # GPU temperature
    if command -v nvidia-smi &> /dev/null; then
      nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo "N/A"
    else
      echo "N/A"
    fi
    ;;
    
  sys_temp)
    # System/motherboard temperature
    if command -v sensors &> /dev/null; then
      sensors | grep -i "temp1" | head -1 | awk '{print $2}' | sed 's/+//;s/°C//' | cut -d'.' -f1 || echo "N/A"
    else
      echo "N/A"
    fi
    ;;
    
  cpu_fan)
    # CPU fan speed in RPM
    if command -v sensors &> /dev/null; then
      sensors | grep -i "fan1" | head -1 | awk '{print $2}' || echo "N/A"
    else
      echo "N/A"
    fi
    ;;
    
  gpu_fan)
    # GPU fan speed in RPM
    if command -v nvidia-smi &> /dev/null; then
      nvidia-smi --query-gpu=fan.speed --format=csv,noheader,nounits 2>/dev/null | awk '{print $1 * 50}' || echo "N/A"
    else
      echo "N/A"
    fi
    ;;
    
  *)
    echo "Usage: $0 {cpu|gpu|ram_used|ram_total|vram_used|vram_total|fps|net_down|net_up|cpu_temp|gpu_temp|sys_temp|cpu_fan|gpu_fan}"
    exit 1
    ;;
esac
