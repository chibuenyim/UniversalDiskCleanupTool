#!/bin/bash
# ============================================
#  Universal Disk Cleanup Tool v5.5.0
#  GUI Launcher for macOS/Linux using Zenity
# ============================================

set -e

# Colors for fallback
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
else
    OS="Unknown"
fi

# Check for Zenity
if ! command -v zenity &> /dev/null; then
    echo -e "${RED}ERROR: Zenity is not installed${NC}"
    echo ""
    echo "Zenity is required for the GUI interface."
    echo ""

    if [[ "$OS" == "macOS" ]]; then
        echo -e "${GREEN}macOS:${NC}"
        echo "  brew install zenity"
        echo ""
    elif [[ "$OS" == "Linux" ]]; then
        echo -e "${GREEN}Linux (Ubuntu/Debian):${NC}"
        echo "  sudo apt-get install -y zenity"
        echo ""
        echo -e "${GREEN}Linux (Fedora):${NC}"
        echo "  sudo dnf install -y zenity"
        echo ""
        echo -e "${GREEN}Linux (Arch):${NC}"
        echo "  sudo pacman -S zenity"
        echo ""
    fi

    echo "Falling back to CLI mode..."
    echo ""
    exec "./start.sh"
fi

# Check for PowerShell
if ! command -v pwsh &> /dev/null; then
    zenity --error \
        --title="PowerShell Required" \
        --text="PowerShell 7+ (pwsh) is not installed.\n\nPlease install it first:\n\nmacOS:\n  brew install powershell\n\nUbuntu/Debian:\n  wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb\n  sudo dpkg -i packages-microsoft-prod.deb\n  sudo apt-get update\n  sudo apt-get install -y powershell" \
        --width=500 \
        --height=300
    exit 1
fi

# Main GUI dialog
cleanup_choice=$(zenity --list \
    --title="Universal Disk Cleanup Tool v5.5.0" \
    --text="Choose what to clean:" \
    --column="Option" \
    --column="Description" \
    "Quick Cleanup" "Clean everything (recommended)" \
    "Temporary Files" "System temp files and caches" \
    "Browser Caches" "Chrome, Firefox, Edge, Safari" \
    "Developer Tools" "npm, pip, cargo, maven, etc." \
    "System Files" "Logs, thumbnails, recycle bin" \
    --radiolist \
    --width=600 \
    --height=450 \
    --ok-label="Start Cleanup" \
    --cancel-label="Cancel" \
    2>/dev/null)

if [ $? -ne 0 ] || [ -z "$cleanup_choice" ]; then
    echo "Cleanup cancelled."
    exit 0
fi

# Build PowerShell arguments
case "$cleanup_choice" in
    "Quick Cleanup")
        ARGS="--All"
        ;;
    "Temporary Files")
        ARGS="--Temp"
        ;;
    "Browser Caches")
        ARGS="--Browser"
        ;;
    "Developer Tools")
        ARGS="--Dev"
        ;;
    "System Files")
        ARGS="--System"
        ;;
esac

# Show progress dialog
(
    echo "10"
    echo "# Starting cleanup..."
    sleep 0.5

    # Run cleanup and capture output
    pwsh -File "./cleanup.ps1" $ARGS 2>&1 | while IFS= read -r line; do
        echo "# $line"
    done

    echo "100"
    echo "# Cleanup complete!"
) | zenity --progress \
    --title="Universal Disk Cleanup Tool" \
    --text="Starting cleanup..." \
    --width=500 \
    --height=150 \
    --auto-kill \
    2>/dev/null

# Show completion message
zenity --info \
    --title="Cleanup Complete" \
    --text="Disk cleanup has finished!\n\nCleaned: $cleanup_choice" \
    --width=300 \
    --height=150

echo "Cleanup complete!"
