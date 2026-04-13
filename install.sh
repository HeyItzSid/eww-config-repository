#!/bin/bash
# EWW Desktop UI - Automated Installation Script
# This script will install and configure the complete EWW desktop UI

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    print_error "This script is designed for Linux systems only"
    exit 1
fi

print_header "EWW Desktop UI Installation"

# Step 1: Check for EWW
print_info "Checking for EWW installation..."
if command -v eww &> /dev/null; then
    print_success "EWW is installed"
else
    print_error "EWW is not installed"
    print_info "Please install EWW first: https://github.com/elkowar/eww"
    exit 1
fi

# Step 2: Check dependencies
print_info "Checking dependencies..."

MISSING_DEPS=()

check_dep() {
    if command -v "$1" &> /dev/null; then
        print_success "$1 found"
    else
        print_warning "$1 not found (optional: $2)"
        MISSING_DEPS+=("$1")
    fi
}

# Required dependencies
check_dep "bash" "required"
check_dep "top" "required"
check_dep "free" "required"

# Optional but recommended
check_dep "sensors" "temperature monitoring"
check_dep "nvidia-smi" "GPU monitoring"
check_dep "wmctrl" "window management"
check_dep "xdotool" "desktop control"
check_dep "xprop" "window properties"
check_dep "playerctl" "media control"
check_dep "pactl" "volume control"
check_dep "nmcli" "network control"
check_dep "brightnessctl" "brightness control"
check_dep "rfkill" "airplane mode"
check_dep "bc" "calculations"
check_dep "jq" "JSON parsing"

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    print_warning "Some optional dependencies are missing"
    print_info "Missing: ${MISSING_DEPS[*]}"
    print_info "Some features may not work without these dependencies"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Step 3: Backup existing configuration
print_info "Checking for existing EWW configuration..."
if [ -d "$HOME/.config/eww" ]; then
    print_warning "Existing EWW configuration found"
    BACKUP_DIR="$HOME/.config/eww.backup.$(date +%Y%m%d_%H%M%S)"
    print_info "Creating backup at: $BACKUP_DIR"
    mv "$HOME/.config/eww" "$BACKUP_DIR"
    print_success "Backup created"
fi

# Step 4: Copy configuration
print_info "Installing EWW configuration..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$HOME/.config"
cp -r "$SCRIPT_DIR" "$HOME/.config/eww"
print_success "Configuration copied"

# Step 5: Make scripts executable
print_info "Making scripts executable..."
chmod +x "$HOME/.config/eww/scripts/"*.sh
print_success "Scripts are now executable"

# Step 6: Configure sensors (if available)
if command -v sensors-detect &> /dev/null; then
    print_info "Sensors utility found"
    read -p "Run sensors-detect to configure temperature monitoring? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Running sensors-detect (answer YES to all prompts)..."
        sudo sensors-detect --auto
        print_success "Sensors configured"
    fi
fi

# Step 7: Test scripts
print_info "Testing scripts..."

test_script() {
    if bash "$HOME/.config/eww/scripts/$1" $2 &> /dev/null; then
        print_success "$1 working"
    else
        print_warning "$1 may have issues"
    fi
}

test_script "telemetry.sh" "cpu"
test_script "workspace.sh" "current"
test_script "media.sh" "volume"
test_script "network.sh" "wifi_status"
test_script "system.sh" "brightness"

# Step 8: Start EWW
print_info "Starting EWW..."

# Kill existing daemon if running
if pgrep -x "eww" > /dev/null; then
    print_info "Stopping existing EWW daemon..."
    eww kill
    sleep 1
fi

# Start daemon
eww daemon &
sleep 2

if pgrep -x "eww" > /dev/null; then
    print_success "EWW daemon started"
else
    print_error "Failed to start EWW daemon"
    exit 1
fi

# Open main window
print_info "Opening main desktop window..."
eww open main-desktop

if eww windows | grep -q "main-desktop"; then
    print_success "Main window opened"
else
    print_error "Failed to open main window"
    print_info "Check logs with: eww logs"
    exit 1
fi

# Step 9: Final checks
print_header "Installation Complete!"

print_success "EWW Desktop UI is now running"
echo ""
print_info "Useful commands:"
echo "  eww logs          - View logs"
echo "  eww reload        - Reload configuration"
echo "  eww close-all     - Close all windows"
echo "  eww kill          - Stop daemon"
echo ""
print_info "Configuration location: ~/.config/eww"
print_info "Documentation: ~/.config/eww/README.md"
echo ""

# Check for warnings
if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    print_warning "Some features may not work due to missing dependencies:"
    for dep in "${MISSING_DEPS[@]}"; do
        echo "  - $dep"
    done
    echo ""
    print_info "Install missing dependencies for full functionality"
fi

print_success "Installation successful! Enjoy your new desktop UI! 🎉"
