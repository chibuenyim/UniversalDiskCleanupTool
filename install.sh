#!/bin/bash
# Universal Disk Cleanup Tool - Installer for Linux/macOS

set -e

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="cleanup"
SCRIPT_URL="https://raw.githubusercontent.com/chibuenyim/DiskCleanupTool/main/cleanup.ps1"

echo "=========================================="
echo "  Universal Disk Cleanup Tool Installer"
echo "=========================================="
echo ""

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

echo "Detected OS: $OS"
echo ""

# Check if PowerShell is installed
if ! command -v pwsh &> /dev/null; then
    echo "PowerShell Core is not installed."
    echo ""

    if [[ "$OS" == "Linux" ]]; then
        echo "Installing PowerShell Core..."
        if command -v apt-get &> /dev/null; then
            # Debian/Ubuntu
            sudo apt-get update
            sudo apt-get install -y wget apt-transport-https software-properties-common
            wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
            sudo dpkg -i "packages-microsoft-prod.deb"
            sudo apt-get update
            sudo apt-get install -y powershell
        elif command -v dnf &> /dev/null; then
            # Fedora
            sudo dnf install -y powershell
        elif command -v pacman &> /dev/null; then
            # Arch
            sudo pacman -S powershell
        else
            echo "Please install PowerShell manually:"
            echo "https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core"
            exit 1
        fi
    elif [[ "$OS" == "macOS" ]]; then
        echo "Installing PowerShell Core..."
        if command -v brew &> /dev/null; then
            brew install powershell
        else
            echo "Please install Homebrew first:"
            echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            exit 1
        fi
    fi
fi

echo "PowerShell version:"
pwsh --version
echo ""

# Download script
echo "Downloading cleanup script..."
sudo curl -L "$SCRIPT_URL" -o "$INSTALL_DIR/$SCRIPT_NAME.ps1"
sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME.ps1"
echo ""

# Create wrapper script
echo "Creating wrapper script..."
cat <<EOF | sudo tee "$INSTALL_DIR/$SCRIPT_NAME" > /dev/null
#!/bin/bash
pwsh -NoProfile -ExecutionPolicy Bypass -File "$INSTALL_DIR/$SCRIPT_NAME.ps1" "\$@"
EOF
sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo ""

# Create symlink
sudo ln -sf "$INSTALL_DIR/$SCRIPT_NAME" "/usr/local/bin/diskcleanup"
echo ""

echo "=========================================="
echo "  Installation Complete!"
echo "=========================================="
echo ""
echo "You can now run the tool using:"
echo "  cleanup"
echo "  diskcleanup"
echo ""
echo "Options:"
echo "  cleanup --all        Clean everything"
echo "  cleanup --temp       Clean temp files"
echo "  cleanup --browser    Clean browser caches"
echo "  cleanup --dev        Clean developer caches"
echo "  cleanup --logs       Clean logs"
echo "  cleanup --cache      Clean package caches"
echo ""
echo "For more info:"
echo "  cleanup --help"
echo ""
