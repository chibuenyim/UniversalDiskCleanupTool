# 🧹 Universal Disk Cleanup Tool

**A cross-platform disk cleanup utility for Windows, macOS, and Linux**

![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-blue.svg)

## ✨ Features

- 🌍 **Cross-Platform** - Works on Windows, macOS, and Linux
- 🧹 **Comprehensive Cleaning** - Removes temp files, caches, logs, and more
- 🚀 **Fast & Efficient** - Quickly frees up gigabytes of space
- 🔒 **Safe** - Only removes junk files, never your personal data
- 🎯 **Selective** - Choose what to clean with command-line options
- 📦 **Portable** - No installation required (optional install available)

## 🗑️ What It Cleans

### Common (All Platforms)
- ✅ Temporary files
- ✅ Browser caches (Chrome, Firefox, Safari, Edge, Brave)
- ✅ Developer caches (npm, yarn, pip, Composer)
- ✅ System logs
- ✅ Thumbnail caches

### Windows Specific
- ✅ Windows temp folders
- ✅ Prefetch
- ✅ SoftwareDistribution
- ✅ Recycle Bin
- ✅ WinSxS cleanup (DISM)
- ✅ NuGet cache

### macOS Specific
- ✅ User caches
- ✅ Xcode DerivedData
- ✅ Homebrew cache
- ✅ Application logs

### Linux Specific
- ✅ Package manager caches (apt, dnf, yum, pacman)
- ✅ Journal logs
- ✅ Thumbnail cache

## 📋 Requirements

- **PowerShell 7+** (pwsh)
- **Administrator/root privileges** for system cleaning
- Supported operating systems:
  - Windows 10/11
  - macOS 10.14+
  - Linux (Ubuntu, Fedora, Arch, etc.)

## 🚀 Quick Start

### Option 1: Direct Download (Recommended for Linux/macOS)

```bash
# Download installer
curl -LO https://raw.githubusercontent.com/chibuenyim/DiskCleanupTool/main/install.sh

# Run installer
chmod +x install.sh
sudo ./install.sh

# Run cleanup
cleanup --all
```

### Option 2: Clone Repository

```bash
git clone https://github.com/chibuenyim/DiskCleanupTool.git
cd DiskCleanupTool

# Run directly
pwsh -File cleanup.ps1 --all
```

### Option 3: Windows

Download `cleanup.ps1` and run in PowerShell:

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\cleanup.ps1 --all
```

## 🎯 Usage

```bash
cleanup [OPTIONS]
```

### Options

| Option | Description |
|--------|-------------|
| `--all` | Clean everything (recommended) |
| `--temp` | Clean temporary files only |
| `--browser` | Clean browser caches only |
| `--dev` | Clean developer caches only |
| `--logs` | Clean system logs only |
| `--cache` | Clean package caches only |
| `--quiet` | Suppress output |
| `--verbose` | Show detailed output |

### Examples

```bash
# Clean everything
cleanup --all

# Clean only temp files and browser caches
cleanup --temp --browser

# Clean developer caches and logs
cleanup --dev --logs

# Clean with verbose output
cleanup --all --verbose
```

## 📦 Platform-Specific Installation

### Windows

1. Download `cleanup.ps1`
2. Right-click → "Run with PowerShell"
3. Click "Yes" when prompted

### macOS

**Method 1: Homebrew (Recommended)**
```bash
brew install diskcleanup
```

**Method 2: Manual**
```bash
# Download and run installer
curl -LO https://raw.githubusercontent.com/chibuenyim/DiskCleanupTool/main/install.sh
sudo ./install.sh
```

**Method 3: Use App Bundle**
```bash
# Copy DiskCleanupTool.app to /Applications
# Double-click to run
```

### Linux

**Debian/Ubuntu**
```bash
# Download .deb package
sudo dpkg -i diskcleanup_2.0.0_amd64.deb
sudo apt-get install -f
```

**Fedora/RHEL**
```bash
# Download .rpm package
sudo dnf install diskcleanup-2.0.0-1.noarch.rpm
```

**Arch**
```bash
yay -S diskcleanup
```

**Manual Installation**
```bash
curl -LO https://raw.githubusercontent.com/chibuenyim/DiskCleanupTool/main/install.sh
sudo ./install.sh
```

## 🐧 Building Packages

### Debian Package (.deb)

```bash
cd packages/debian
dpkg-buildpackage -us -uc
```

### RPM Package (.rpm)

```bash
cd packages/rpm
rpmbuild -ba diskcleanup.spec
```

### AppImage

```bash
cd packages/appimage
./build-appimage.sh
```

### DMG (macOS)

```bash
cd packages/macos
./build-dmg.sh
```

## 📊 Before & After

### Before Cleanup
```
Free space: 5.2 GB
Used:  114.8 GB
Total: 120 GB
```

### After Cleanup
```
Free space: 22.4 GB (+17.2 GB freed!)
Used:  97.6 GB
Total: 120 GB
```

*Results may vary based on system usage*

## ⚠️ Safety

This tool is designed to be safe:
- ✅ Never deletes user documents
- ✅ Never deletes personal files
- ✅ Only removes temporary files and caches
- ✅ Shows what will be cleaned before running
- ✅ Can be run with selective options

However, always:
- 💾 Backup important data before cleanup
- 📋 Review what will be cleaned
- 🔍 Use `--verbose` to see details

## 🛠️ Troubleshooting

### "PowerShell not found"

**Linux:**
```bash
# Ubuntu/Debian
sudo apt-get install -y powershell

# Fedora
sudo dnf install -y powershell

# Arch
sudo pacman -S powershell
```

**macOS:**
```bash
brew install powershell
```

### "Permission denied"

```bash
# Make script executable
chmod +x cleanup.ps1
sudo ./cleanup.ps1 --all
```

### "Cannot clean system files"

Run with sudo/administrator:
```bash
sudo cleanup --all
```

## 📁 Project Structure

```
UniversalDiskCleanupTool/
├── cleanup.ps1              # Main script
├── install.sh               # Linux/macOS installer
├── README.md                # This file
├── LICENSE                  # MIT License
├── packages/
│   ├── debian/             # Debian packaging
│   ├── rpm/                # RPM packaging
│   ├── appimage/           # AppImage build
│   └── macos/              # macOS DMG build
├── macos/
│   └── DiskCleanupTool.app/ # macOS app bundle
└── diskcleanup.desktop      # Linux desktop entry
```

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE) for details

## 🙏 Acknowledgments

- Built with PowerShell Core 7+
- Cross-platform testing on Windows, macOS, and Linux
- Community contributions and feedback

## 📞 Support

- **Issues**: https://github.com/chibuenyim/DiskCleanupTool/issues
- **Discussions**: https://github.com/chibuenyim/DiskCleanupTool/discussions

## ⭐ Star the Repo!

If you find this tool helpful, please give it a star!

---

Made with ❤️ for Windows, macOS, and Linux users worldwide
