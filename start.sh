#!/bin/bash
# ============================================
#  Universal Disk Cleanup Tool v5.0
#  Run this script to start!
# ============================================

set -e

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                        ║${NC}"
echo -e "${CYAN}║     🧹 Universal Disk Cleanup Tool v5.0                ║${NC}"
echo -e "${CYAN}║                                                        ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check for PowerShell
if ! command -v pwsh &> /dev/null; then
    echo -e "${YELLOW}PowerShell not found. Installing...${NC}"
    echo ""
    echo "Please install PowerShell 7+ first:"
    echo ""
    echo "macOS:"
    echo "  brew install powershell"
    echo ""
    echo "Linux (Ubuntu/Debian):"
    echo "  sudo apt-get install -y powershell"
    echo ""
    exit 1
fi

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
else
    OS="Linux"
fi

echo -e "${GREEN}Starting on $OS...${NC}"
echo ""

# Run cleanup
pwsh -File cleanup.ps1 --All

echo ""
echo -e "${GREEN}Cleanup complete!${NC}"
