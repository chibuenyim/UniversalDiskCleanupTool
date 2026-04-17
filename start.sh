#!/bin/bash
# ============================================
#  Universal Disk Cleanup Tool v5.6.0
#  Run this script to start!
# ============================================

set -e

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                        ║${NC}"
echo -e "${CYAN}║     Universal Disk Cleanup Tool v5.6.0                   ║${NC}"
echo -e "${CYAN}║                                                        ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
else
    OS="Unknown"
fi

# Check for PowerShell
if ! command -v pwsh &> /dev/null; then
    echo -e "${RED}ERROR: PowerShell (pwsh) is not installed${NC}"
    echo ""
    echo "Please install PowerShell 7+ first:"
    echo ""

    if [[ "$OS" == "macOS" ]]; then
        echo -e "${GREEN}macOS:${NC}"
        echo "  brew install powershell"
        echo ""
    elif [[ "$OS" == "Linux" ]]; then
        # Detect Linux distribution
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$ID

            case $DISTRO in
                ubuntu|debian)
                    echo -e "${GREEN}Ubuntu/Debian:${NC}"
                    echo "  # Download Microsoft repository"
                    echo "  wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb"
                    echo "  sudo dpkg -i packages-microsoft-prod.deb"
                    echo ""
                    echo "  # Update and install PowerShell"
                    echo "  sudo apt-get update"
                    echo "  sudo apt-get install -y powershell"
                    echo ""
                    ;;
                fedora|rhel|centos)
                    echo -e "${GREEN}Fedora/RHEL:${NC}"
                    echo "  # Import Microsoft key"
                    echo "  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc"
                    echo ""
                    echo "  # Register Microsoft repository"
                    echo "  sudo rpm -Uvh https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm"
                    echo ""
                    echo "  # Install PowerShell"
                    echo "  sudo dnf install -y powershell"
                    echo ""
                    ;;
                arch|manjaro)
                    echo -e "${GREEN}Arch Linux:${NC}"
                    echo "  yay -S powershell"
                    echo ""
                    ;;
                *)
                    echo -e "${YELLOW}Linux (${DISTRO}):${NC}"
                    echo "  Visit: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux"
                    echo ""
                    ;;
            esac
        else
            echo -e "${YELLOW}Linux:${NC}"
            echo "  Visit: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux"
            echo ""
        fi
    fi

    echo "After installing PowerShell, run this script again:"
    echo "  ./start.sh"
    echo ""
    exit 1
fi

echo -e "${GREEN}PowerShell found!${NC}"
echo -e "${GREEN}Starting on $OS...${NC}"
echo ""

# Check for arguments
if [ "$1" == "--FixAll" ]; then
    echo -e "${CYAN}Running full cleanup (FixAll mode)...${NC}"
    echo ""
    pwsh -File cleanup.ps1 --FixAll
elif [ "$1" == "--Quick" ]; then
    echo -e "${CYAN}Running quick cleanup...${NC}"
    echo ""
    pwsh -File cleanup.ps1 --All
else
    echo -e "${CYAN}Usage:${NC}"
    echo "  ./start.sh           - Interactive mode (not implemented)"
    echo "  ./start.sh --FixAll  - Clean everything (recommended)"
    echo "  ./start.sh --Quick   - Quick cleanup"
    echo ""
    echo -e "${YELLOW}Running default cleanup...${NC}"
    echo ""
    pwsh -File cleanup.ps1 --All
fi

echo ""
echo -e "${GREEN}Cleanup complete!${NC}"
