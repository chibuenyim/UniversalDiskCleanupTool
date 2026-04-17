#!/bin/bash
# Universal Disk Cleanup Tool Launcher v4.0
# Main launcher with menu for all tools

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if PowerShell is installed
if ! command -v pwsh &> /dev/null; then
    echo -e "${RED}ERROR: PowerShell (pwsh) is not installed!${NC}"
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

# Show menu
show_menu() {
    clear
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║     🧹 Universal Disk Cleanup Tool v4.0 - Menu         ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "Detected OS: ${GREEN}$OS${NC}"
    echo ""
    echo "Choose an option:"
    echo ""
    echo -e "  ${GREEN}[1]${NC} GUI Mode"
    echo "      - Windows: Full Windows Forms GUI"
    echo "      - macOS/Linux: Interactive terminal menu"
    echo "      - Visual cleanup options selection"
    echo "      - Real-time progress tracking"
    echo ""
    echo -e "  ${GREEN}[2]${NC} Command-Line Mode"
    echo "      - Run cleanup without GUI"
    echo "      - Use scripts for automation"
    echo "      - Full control over options"
    echo ""
    echo -e "  ${GREEN}[3]${NC} Quick Cleanup"
    echo "      - Clean everything with one command"
    echo "      - Recommended for most users"
    echo ""
    echo -e "  ${GREEN}[4]${NC} Interactive Mode"
    echo "      - Terminal-based interactive menu"
    echo "      - Select options step-by-step"
    echo ""
    echo -e "  ${GREEN}[5]${NC} Dry Run"
    echo "      - Preview what would be cleaned"
    echo "      - No changes made"
    echo ""
    echo -e "  ${GREEN}[6]${NC} Scheduled Cleanup"
    echo "      - Set up automatic weekly cleanup"
    echo "      - Sundays at 2 AM"
    echo ""
    echo -e "  ${GREEN}[7]${NC} Export/Import Settings"
    echo "      - Save your cleanup preferences"
    echo "      - Restore settings later"
    echo ""
    echo -e "  ${GREEN}[8]${NC} View Statistics"
    echo "      - See cleanup history"
    echo "      - Total space freed"
    echo ""
    echo -e "  ${GREEN}[9]${NC} Help / Documentation"
    echo ""
    echo -e "  ${RED}[Q]${NC} Quit"
    echo ""
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice: " choice

    case $choice in
        1|GUI|gui)
            echo ""
            echo "Launching GUI..."
            cd "$SCRIPT_DIR"
            pwsh -File gui.ps1
            read -p "Press Enter to continue..."
            ;;
        2|CMD|cmd)
            echo ""
            echo "Command-Line Mode"
            echo ""
            echo "Available options:"
            echo "  --All        Clean everything"
            echo "  --Temp       Clean temporary files"
            echo "  --Browser    Clean browser caches"
            echo "  --Dev        Clean developer caches"
            echo "  --Cache      Clean package caches"
            echo "  --Apps       Clean application caches"
            echo "  --System     Clean system files"
            echo "  --DryRun     Preview without changes"
            echo "  --ScanOnly   Scan and show results"
            echo "  --Verbose    Show detailed output"
            echo ""
            read -p "Enter options (e.g., --All --Verbose): " options
            cd "$SCRIPT_DIR"
            pwsh -File cleanup.ps1 $options
            read -p "Press Enter to continue..."
            ;;
        3|QUICK|quick)
            echo ""
            echo "Starting Quick Cleanup (--All)..."
            cd "$SCRIPT_DIR"
            pwsh -File cleanup.ps1 --All
            read -p "Press Enter to continue..."
            ;;
        4|INTERACTIVE|interactive)
            echo ""
            echo "Starting Interactive Mode..."
            cd "$SCRIPT_DIR"
            pwsh -File cleanup.ps1 --All --Interactive
            read -p "Press Enter to continue..."
            ;;
        5|DRYRUN|dryrun)
            echo ""
            echo "Starting Dry Run (preview)..."
            cd "$SCRIPT_DIR"
            pwsh -File cleanup.ps1 --All --DryRun
            read -p "Press Enter to continue..."
            ;;
        6|SCHEDULE|schedule)
            echo ""
            echo "Setting up scheduled cleanup..."
            cd "$SCRIPT_DIR"
            pwsh -File cleanup.ps1 --Schedule
            read -p "Press Enter to continue..."
            ;;
        7|SETTINGS|settings)
            echo ""
            echo "Export/Import Settings"
            echo "  [1] Export Settings"
            echo "  [2] Import Settings"
            echo ""
            read -p "Enter choice: " setting_choice
            case $setting_choice in
                1)
                    cd "$SCRIPT_DIR"
                    pwsh -File cleanup.ps1 --ExportConfig
                    ;;
                2)
                    cd "$SCRIPT_DIR"
                    pwsh -File cleanup.ps1 --ImportConfig
                    ;;
                *)
                    echo "Invalid choice"
                    ;;
            esac
            read -p "Press Enter to continue..."
            ;;
        8|STATS|stats)
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
            echo ""
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
            echo "Cleanup Statistics"
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
            echo "═══════════════════"
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
            echo ""
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
            if [ -f "$HOME/.diskcleanup/config.json" ]; then
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
                pwsh -Command "\$config = Get-Content '$HOME/.diskcleanup/config.json' | ConvertFrom-Json; Write-Host 'Total Cleaned:' ([math]::Round(\$config.TotalCleaned/1GB, 2)) 'GB'; Write-Host 'Last Run:' \$config.LastRun"
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
            else
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
                echo "No statistics found yet. Run a cleanup first."
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
            fi
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
            echo ""
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
            read -p "Press Enter to continue..."
;;        10|COMPRESS|compress)            echo ""            echo "Launching Compression Utility..."            cd "$SCRIPT_DIR"            pwsh -File compress.sh            read -p "Press Enter to continue..."
            ;;
        9|HELP|help)
            echo ""
            echo "Universal Disk Cleanup Tool v4.0 - Help"
            echo "════════════════════════════════════════"
            echo ""
            echo "REPOSITORY:"
            echo "  https://github.com/chibuenyim/UniversalDiskCleanupTool"
            echo ""
            echo "FEATURES:"
            echo "  - Cleans 15-35 GB of disk space"
            echo "  - Cross-platform (Windows, macOS, Linux)"
            echo "  - 60+ application cache locations"
            echo "  - 15+ package managers"
            echo "  - 20+ developer tools"
            echo "  - Dry run and scan-only modes"
            echo "  - Configuration management"
            echo "  - Scheduled cleanup"
            echo ""
            echo "CONFIGURATION:"
            echo "  Config: ~/.diskcleanup/config.json"
            echo "  Logs:   ~/.diskcleanup/cleanup.log"
            echo ""
            echo "SAFE TO CLEAN:"
            echo "  ✓ Temporary files and caches"
            echo "  ✓ Browser caches (not history/bookmarks)"
            echo "  ✓ Developer package caches"
            echo "  ✓ System logs"
            echo "  ✓ Build artifacts"
            echo ""
            echo "PROTECTED:"
            echo "  ✗ User documents and files"
            echo "  ✗ Desktop and Downloads"
            echo "  ✗ Browser history, bookmarks"
            echo "  ✗ Application settings"
            echo "  ✗ Source code and projects"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        Q|q|QUIT|quit)
            echo ""
            echo "Thanks for using Universal Disk Cleanup Tool!"
            echo ""
            exit 0
            ;;
        *)
            echo ""
            echo -e "${RED}Invalid choice. Please try again.${NC}"
            sleep 1
            ;;
    esac
done
