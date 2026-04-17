#!/bin/bash
# Universal Disk Cleanup Tool GUI Launcher
# Cross-platform launcher for macOS and Linux

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🧹 Universal Disk Cleanup Tool v4.0"
echo "=================================="
echo ""

# Check if PowerShell is installed
if ! command -v pwsh &> /dev/null; then
    echo "❌ ERROR: PowerShell (pwsh) is not installed!"
    echo ""
    echo "Please install PowerShell 7+ first:"
    echo ""
    echo "macOS:"
    echo "  brew install powershell"
    echo ""
    echo "Linux (Ubuntu/Debian):"
    echo "  wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb"
    echo "  sudo dpkg -i packages-microsoft-prod.deb"
    echo "  sudo apt-get update"
    echo "  sudo apt-get install -y powershell"
    echo ""
    echo "Linux (Fedora):"
    echo "  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc"
    echo "  sudo dnf install -y powershell"
    echo ""
    exit 1
fi

# Check if gui.ps1 exists
if [ ! -f "$SCRIPT_DIR/gui.ps1" ]; then
    echo "❌ ERROR: gui.ps1 not found in $SCRIPT_DIR"
    echo "Please ensure you have the complete UniversalDiskCleanupTool."
    exit 1
fi

# Launch the GUI
echo "🚀 Launching GUI..."
echo ""
cd "$SCRIPT_DIR"
pwsh -File gui.ps1 "$@"
