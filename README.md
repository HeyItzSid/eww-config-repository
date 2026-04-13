# EWW Custom Desktop UI

A minimal, futuristic desktop UI built with EWW (Elkowar's Wacky Widgets) featuring system telemetry, workspace management, media controls, and hover-activated sidebars.

## Features

- **Top Bar**: System telemetry (CPU, GPU, RAM, VRAM, FPS, network, temps, fans), workspace switcher, media controls
- **Left Sidebar**: Hover-activated window selector with 3 states (idle 5px → hover 50px → expanded 350px)
- **Right Sidebar**: Clock and app shortcuts with swipeable pages
- **Bottom Bar**: Search bar with expandable results and app dock with hover magnification
- **Fan Safety Warning**: Alerts when CPU temp > 80°C and fan speed < 500 RPM
- **Smooth Animations**: 200-300ms transitions with easing functions

## Prerequisites

### Required
- EWW (Elkowar's Wacky Widgets)
- bash
- Basic system utilities (top, free, date)

### Optional (for full functionality)
- `nvidia-smi` - GPU monitoring (NVIDIA cards)
- `sensors` (lm-sensors) - Temperature and fan monitoring
- `playerctl` - Media playback control
- `pactl` (PulseAudio) - Volume control
- `pavucontrol` - Audio mixer
- `wmctrl` - Window management (X11)
- `xdotool` - Window management (X11)
- `xprop` - Window properties (X11)
- `swaymsg` - Window management (Wayland/Sway)
- `jq` - JSON parsing (for Sway)

## Installation

1. **Install EWW**:
   ```bash
   # Follow instructions at: https://github.com/elkowar/eww
   ```

2. **Install dependencies**:
   ```bash
   # Arch Linux
   sudo pacman -S lm_sensors playerctl pulseaudio wmctrl xdotool xorg-xprop jq

   # Ubuntu/Debian
   sudo apt install lm-sensors playerctl pulseaudio-utils wmctrl xdotool x11-utils jq

   # Fedora
   sudo dnf install lm_sensors playerctl pulseaudio-utils wmctrl xdotool xprop jq
   ```

3. **Configure sensors** (first time):
   ```bash
   sudo sensors-detect
   # Answer YES to all prompts
   ```

4. **Copy configuration**:
   ```bash
   # Backup existing config if you have one
   mv ~/.config/eww ~/.config/eww.backup

   # Copy this config
   cp -r eww-config ~/.config/eww
   ```

5. **Make scripts executable**:
   ```bash
   chmod +x ~/.config/eww/scripts/*.sh
   ```

## Usage

### Start EWW
```bash
eww daemon
eww open main-desktop
```

### Stop EWW
```bash
eww close main-desktop
eww kill
```

### Reload configuration
```bash
eww reload
```

### Debug
```bash
eww logs
```

## Configuration

### Customize App Shortcuts

Edit `widgets/right-sidebar.yuck` and `widgets/bottom-bar.yuck` to modify app shortcuts:

```lisp
(defvar app_shortcuts_page1 [
  "app-id|Display Name|/path/to/icon.png"
  ...
])
```

### Adjust Polling Intervals

Edit the `:interval` values in widget files:
- Telemetry: `2s` (default)
- Workspace: `1s` (default)
- Media: `1s` (default)
- Windows: `2s` (default)

### Customize Colors

Edit `eww.scss` to change color scheme:
```scss
$accent-cyan: #00ffff;
$accent-blue: #0088ff;
$temp-cyan: #00ffff;
$temp-yellow: #ffff00;
$temp-orange: #ff8800;
$temp-red: #ff0000;
```

### Adjust Sidebar Widths

Edit sidebar SCSS files:
```scss
&.idle { min-width: 5px; }      // Aesthetic border
&.hover { min-width: 50px; }    // Icon preview
&.expanded { min-width: 350px; } // Full tray
```

## File Structure

```
eww-config/
├── eww.yuck              # Main configuration
├── eww.scss              # Global styles
├── widgets/              # Widget modules
│   ├── top-bar.yuck
│   ├── left-sidebar.yuck
│   ├── right-sidebar.yuck
│   └── bottom-bar.yuck
├── styles/               # Component styles
│   ├── animations.scss
│   ├── top-bar.scss
│   ├── left-sidebar.scss
│   ├── right-sidebar.scss
│   └── bottom-bar.scss
└── scripts/              # Data collection scripts
    ├── telemetry.sh
    ├── workspace.sh
    ├── media.sh
    ├── windows.sh
    └── apps.sh
```

## Troubleshooting

### No telemetry data showing
- Check if required utilities are installed
- Run scripts manually: `bash ~/.config/eww/scripts/telemetry.sh cpu`
- Check EWW logs: `eww logs`

### GPU data shows "N/A"
- Install `nvidia-smi` for NVIDIA cards
- For AMD cards, modify `telemetry.sh` to use `radeontop` or similar

### Temperature/fan data missing
- Install and configure lm-sensors: `sudo sensors-detect`
- Test sensors: `sensors`

### Window switching not working
- Install `wmctrl` and `xdotool` for X11
- Install `swaymsg` for Wayland/Sway

### Media controls not responding
- Install `playerctl`
- Test: `playerctl status`

### Search not finding apps
- Check desktop file locations in `scripts/apps.sh`
- Verify desktop files exist: `ls /usr/share/applications/*.desktop`

## Performance

- CPU usage: < 2% idle, < 5% active
- Memory usage: ~50-100 MB
- Polling intervals optimized for minimal system impact

## License

This configuration is provided as-is for personal use.

## Credits

Built with [EWW](https://github.com/elkowar/eww) by elkowar.
