# 🧹 Universal Disk Cleanup Tool v7.0.2

**Comprehensive disk cleanup tool for Windows, macOS, and Linux with real space measurement**

![Version](https://img.shields.io/badge/version-7.0.2-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

---

## 🚀 Quick Start

### 📥 Download from Releases

Go to [https://github.com/chibuenyim/UniversalDiskCleanupTool/releases](https://github.com/chibuenyim/UniversalDiskCleanupTool/releases) and download:

- **Windows**: `UniversalDiskCleanupTool-v7.0.2.zip`
- **macOS**: `UniversalDiskCleanupTool-macos-v7.0.2.tar.gz`
- **Linux**: `UniversalDiskCleanupTool-linux-v7.0.2.tar.gz`

### Windows:
1. Download the `.zip` file from releases
2. Extract ZIP
3. **Double-click `START.bat`**
4. If PowerShell 7+ is missing, we will install it automatically for you!
5. A beautiful GUI will open - choose what to clean and click Start!

### macOS:
```bash
# Install PowerShell
brew install powershell

# Download and extract the release
tar -xzf UniversalDiskCleanupTool-macos-v7.0.2.tar.gz
cd UniversalDiskCleanupTool-macos-v7.0.2

# Run
chmod +x start.sh
./start.sh
```

### Linux (Ubuntu/Debian):
```bash
# Install PowerShell (Ubuntu 20.04+)
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell

# Download and extract
tar -xzf UniversalDiskCleanupTool-linux-v7.0.2.tar.gz
cd UniversalDiskCleanupTool-linux-v7.0.2

# Run
chmod +x start.sh
./start.sh
```

---

## ✨ Features

- **Comprehensive Cleanup** - Browsers, dev tools, system files, caches, and more
- **Real Space Measurement** - Verifies TRUE disk space freed with filesystem sync
- **Beautiful GUI** - Windows users get a graphical interface
- **Cross-Platform** - Works on Windows, macOS, and Linux
- **Desktop Environment Support** - GNOME, KDE, XFCE caches for Linux
- **Interactive Safety** - Prompts before high-impact operations
- **Easy to Use** - Simple launcher for each platform
- **Safe** - Never deletes your documents or personal files
- **Fast** - Cleans in minutes, not hours
- **Verified Results** - Actual space freed shown after cleanup
- **Smart** - Knows exactly what to clean
- **Auto-Install** - Automatically installs PowerShell 7+ on Windows if missing
- **New!** `--DisableHibernation` flag for Windows (4-16GB additional space)

---

## 📊 What It Cleans

### Windows (15-50GB+ potential)
| Category | Techniques | Space Saved |
|----------|-----------|-------------|
| Temporary Files | Windows Temp, Prefetch | 500 MB - 3 GB |
| Browser Caches | Chrome, Edge, Firefox, Brave, Opera, Vivaldi | 300 MB - 2 GB |
| Developer Tools | npm, yarn, pnpm, pip, poetry, composer, nuget, maven, gradle, go, cargo, flutter, docker | 8-25 GB |
| **System Files** | **Windows Store, Delivery Optimization, Defender Quarantine, Restore Points, Memory Dumps, DirectX, Windows Ink, Retail Demo, Windows.old, Hiberfil.sys** | **5-20 GB** |
| Package Caches | Windows Update, DISM cleanup | 1-5 GB |
| Application Caches | Adobe, Spotify, Discord, Slack, Teams, Zoom, Steam, Epic Games | 1-5 GB |
| **Windows Total** | **Multiple locations** | **Varies by usage** |

### macOS (2-17GB+ potential)
| Category | Techniques | Space Saved |
|----------|-----------|-------------|
| Temporary Files | /tmp, user cache, trash | 500 MB - 3 GB |
| Browser Caches | Safari, Chrome, Firefox, Brave, Edge, Opera, Vivaldi | 300 MB - 2 GB |
| Developer Tools | npm, yarn, pip, poetry, homebrew, cocoa pods, carthage, xcode, go, cargo, docker | 8-25 GB |
| **System Files** | **Spotlight Index, QuickLook Cache, Mail Downloads** | **1-10 GB** |
| Application Caches | Adobe, Spotify, Discord, Slack, Teams, Zoom, VSCode, JetBrains | 1-5 GB |
| **macOS Total** | **Multiple locations** | **Varies by usage** |

### Linux (500MB-8GB+ potential)
| Category | Techniques | Space Saved |
|----------|-----------|-------------|
| Package Managers | apt, dnf, pacman, yum, zypper, swupd, xbps, apk, snap, flatpak | 2-8 GB |
| Temp Files | /tmp, /var/tmp, user cache | 200 MB - 2 GB |
| Browser Caches | Chrome, Firefox, Brave, Chromium, Edge, Opera, Vivaldi | 200 MB - 1 GB |
| Developer Tools | npm, yarn, pnpm, pip, poetry, composer, go, cargo, gradle, maven, docker | 5-15 GB |
| **Desktop Caches** | **GNOME (dconf, GVFS), KDE (Baloo), XFCE** | **100 MB - 5 GB** |
| Application Caches | Spotify, Discord, Slack, Teams, Zoom, Telegram, VSCode, JetBrains | 200 MB - 2 GB |
| System Files | Journal logs, thumbnails, font cache, icon cache | 100 MB - 1 GB |
| **Linux Total** | **Multiple locations** | **Varies by usage** |

**Actual space freed varies based on system usage and is verified after cleanup.**

---

## 🛡️ Is It Safe?

**YES!** We only clean:
- ✅ Temporary files
- ✅ Cache files
- ✅ Package downloads
- ✅ Build artifacts
- ✅ System logs
- ✅ Browser caches (not history!)
- ✅ Application caches

**NEVER touch:**
- ❌ Your documents
- ❌ Your photos/videos
- ❌ Your source code
- ❌ Your settings
- ❌ Browser history
- ❌ Your passwords

### 🔒 Safety Features

- **Windows.old**: Interactive prompt each time
- **Hiberfil.sys**: Requires `--DisableHibernation` flag + confirmation
- **Mail Downloads**: Interactive prompt each time (macOS)
- **System Restore**: Always keeps 3 most recent points
- All operations respect `--DryRun` and `--ScanOnly` modes

---

## 🎯 How to Use

### Windows:
```powershell
# GUI (Recommended)
Double-click START.bat

# Command Line
./cleanup.ps1 --All                    # Clean everything
./cleanup.ps1 --All --DisableHibernation  # Also remove hiberfil.sys (4-16GB)
./cleanup.ps1 --DryRun --All           # Preview what would be cleaned
./cleanup.ps1 --ScanOnly --Dev         # Scan dev tools only
./cleanup.ps1 --All --Verbose          # Full cleanup with details
./cleanup.ps1 --All --Interactive      # With progress bars
```

### macOS/Linux:
```bash
./start.sh --All                      # Clean everything
./start.sh --Quick                    # Quick cleanup
./cleanup.ps1 --All                   # Clean everything
./cleanup.ps1 --DryRun --All          # Preview what would be cleaned
./cleanup.ps1 --ScanOnly --Dev        # Scan dev tools only
```

---

## 🆕 What's New in v7.0.2

### Major Updates in v7.0.0
**22 New Safe Disk Space Techniques Added!**

#### Windows Enhancements (10 new techniques):
1. Windows Store Cache cleanup
2. Delivery Optimization Cache cleanup (2-5GB)
3. Windows Defender Quarantine cleanup (30+ day old files)
4. System Restore Points cleanup (keeps 3 most recent, 5-15GB)
5. Memory Dump Files cleanup
6. DirectX Shader Cache cleanup (1-5GB)
7. Windows Ink Workspace cleanup
8. Retail Demo Content removal (2-10GB)
9. Windows.old cleanup with interactive prompt (10-20GB+)
10. **Hiberfil.sys removal with `--DisableHibernation` flag (4-16GB)**

#### macOS Enhancements (3 new techniques):
1. Spotlight Index cleanup (1-5GB)
2. QuickLook Cache cleanup (100MB-2GB)
3. Mail Downloads cleanup with interactive prompt (1-10GB)

#### Linux Enhancements (3 new techniques):
1. GNOME caches cleanup (dconf, GVFS, Evince thumbnails)
2. KDE caches cleanup (Baloo index, thumbnails, Okular)
3. XFCE caches cleanup (Thunar thumbnails, config)

#### Improvements:
- ✅ Fixed config saving bug - now correctly saves real measured space
- ✅ All techniques are safe and well-documented
- ✅ Interactive prompts for high-impact operations
- ✅ Better organization for desktop environment caches

### Technical Improvements
- Real disk space measurement: `afterFree - beforeFree`
- Filesystem sync before measurement for accuracy
- Config now saves correct value after measurement
- No fake estimates - only real measurements

---

## 📦 What's Included

- `START.bat` - Windows GUI launcher
- `start.sh` - Unix launcher
- `start-gui.sh` - Unix GUI launcher
- `launcher.ps1` - GUI launcher for Windows
- `install-pwsh.ps1` - Automatic PowerShell 7+ installer
- `cleanup.ps1` - Cross-platform cleanup script
- `README.md` - This file
- `GUIDE.md` - Comprehensive usage guide
- `CONTRIBUTING.md` - Contribution guidelines
- `LICENSE` - MIT License

---

## 💡 Tips

- **First time?** Just run the launcher
- **Windows user?** Double-click START.bat for the GUI
- **Developer?** Choose "Developer Tools" in the GUI for extra cleanup
- **Maximum cleanup?** Use `--DisableHibernation` flag on Windows (frees RAM-sized space)
- **Run monthly** for best results
- **Safe to run anytime**
- **Use `--DryRun` first** to see what would be cleaned

---

## 🔗 Links

- **Website:** https://github.com/chibuenyim/UniversalDiskCleanupTool
- **Releases:** https://github.com/chibuenyim/UniversalDiskCleanupTool/releases
- **Issues:** https://github.com/chibuenyim/UniversalDiskCleanupTool/issues

---

## 📄 License

MIT License - Free to use, modify, and distribute

---

## ⭐ Enjoy Your Free Space!

Made with ❤️ for Windows, macOS, and Linux users worldwide

**Version:** 7.0.2 (Stable Production Release)
**Release Date:** April 2026
**Cleanup:** Browsers, dev tools, system files, caches, and more
**Results:** Actual space freed verified after cleanup
