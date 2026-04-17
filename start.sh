#!/bin/bash
# ============================================
#  Universal Disk Cleanup Tool v4.0
#  macOS and Linux
#  Double-click this file or run: ./start.sh
# ============================================

set -e

# Colors for terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd "$SCRIPT_DIR" && pwd)"

# Check if PowerShell is installed
if ! command -v pwsh &> /dev/null; then
    echo -e "${RED}ERROR: PowerShell (pwsh) is not installed${NC}"
    echo ""
    echo "Please install PowerShell 7+ first:"
    echo ""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macOS:"
        echo "  brew install powershell"
    else
        echo "Linux (Ubuntu/Debian):"
        echo "  wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb"
        echo "  sudo dpkg -i packages-microsoft-prod.deb"
        echo "  sudo apt-get update"
        echo "  sudo apt-get install -y powershell"
    fi
    echo ""
    exit 1
fi

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
else
    OS="Unknown"
fi

# Show welcome
clear
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                        ║${NC}"
echo -e "${CYAN}║     🧹 Universal Disk Cleanup Tool v4.0                ║${NC}"
echo -e "${CYAN}║     $OS${NC}                                        ║${NC}"
echo -e "${CYAN}║                                                        ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Starting GUI...${NC}"
echo ""

# Change to script directory
cd "$SCRIPT_DIR"

# Launch GUI
pwsh -File gui.ps1
