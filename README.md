# 🧹 Universal Disk Cleanup Tool v5.3.0

**The easiest way to free up disk space on Windows, macOS, and Linux**

![Version](https://img.shields.io/badge/version-5.3.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

---

## 🚀 Quick Start

### 📥 Download from Releases

Go to [https://github.com/chibuenyim/UniversalDiskCleanupTool/releases](https://github.com/chibuenyim/UniversalDiskCleanupTool/releases) and download the file for your operating system:

- **Windows**: `UniversalDiskCleanupTool-windows-vX.X.X.zip`
- **macOS**: `UniversalDiskCleanupTool-macos-vX.X.X.tar.gz`
- **Linux**: `UniversalDiskCleanupTool-linux-vX.X.X.tar.gz`

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
tar -xzf UniversalDiskCleanupTool-macos-vX.X.X.tar.gz
cd UniversalDiskCleanupTool-macos-vX.X.X

# Download and run
chmod +x start.sh
./start.sh
```

### Linux (Ubuntu/Debian):
```bash
# Install PowerShell (Ubuntu 20.04+)
# Download Microsoft repository configuration
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

# Update and install
sudo apt-get update
sudo apt-get install -y powershell

# Download and extract the release
tar -xzf UniversalDiskCleanupTool-linux-vX.X.X.tar.gz
cd UniversalDiskCleanupTool-linux-vX.X.X

# Download and run this tool
chmod +x start.sh
./start.sh
```

### Linux (Fedora):
```bash
# Import Microsoft key
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Install PowerShell
sudo dnf install -y powershell

# Download and extract
tar -xzf UniversalDiskCleanupTool-linux-vX.X.X.tar.gz
cd UniversalDiskCleanupTool-linux-vX.X.X

# Download and run
chmod +x start.sh
./start.sh
```

### Linux (Arch):
```bash
# Install from AUR
yay -S powershell

# Download and extract
tar -xzf UniversalDiskCleanupTool-linux-vX.X.X.tar.gz
cd UniversalDiskCleanupTool-linux-vX.X.X

# Download and run
chmod +x start.sh
./start.sh
```

---

## ✨ Features

- **Accurate Space Measurement** - Verifies TRUE disk space freed with filesystem sync (NEW!)
- **Beautiful GUI** - Windows users get a graphical interface
- **Cross-Platform** - Works on Windows, macOS, and Linux
- **Easy to Use** - Simple launcher for each platform
- **Safe** - Never deletes your documents or personal files
- **Fast** - Cleans in minutes, not hours
- **Powerful** - Frees up to 45 GB of space
- **Smart** - Knows exactly what to clean
- **Verified Results** - Shows tracking accuracy and actual space freed
- **Auto-Install** - Automatically installs PowerShell 7+ on Windows if missing

---

## 📊 What It Cleans

| Category | Space Saved |
|----------|-------------|
| Temporary Files | 500 MB - 3 GB |
| Browser Caches | 300 MB - 2 GB |
| Developer Caches | 8-25 GB |
| Package Caches | 1-5 GB |
| Application Caches | 1-5 GB |
| System Files | 2-8 GB |
| **Total** | **20-45 GB** |

---

## 🛡️ Is It Safe?

**YES!** We only clean:
- ✅ Temporary files
- ✅ Cache files
- ✅ Package downloads
- ✅ Build artifacts
- ✅ System logs

**NEVER touch:**
- ❌ Your documents
- ❌ Your photos/videos
- ❌ Your source code
- ❌ Your settings
- ❌ Browser history

---

## 🎯 How to Use

### Windows:
```
Double-click START.bat
A GUI will open - choose what to clean and click Start!
```

### macOS/Linux:
```bash
./start.sh
```

That's it! The cleanup will start automatically.

---

## 📦 What's Included

- `START.bat` - Windows GUI launcher
- `start.sh` - Unix launcher  
- `launcher.ps1` - GUI launcher for Windows
- `install-pwsh.ps1` - Automatic PowerShell 7+ installer
- `cleanup.ps1` - Cross-platform cleanup script
- `README.md` - This file
- `README.txt` - Quick reference
- `LICENSE` - MIT License

---

## 💡 Tips

- **First time?** Just run the launcher
- **Windows user?** Double-click START.bat for the GUI
- **Developer?** Choose "Developer Tools" in the GUI for extra cleanup
- **Run monthly** for best results
- **Safe to run anytime**

---

## 📈 Expected Results

### Windows:
```
Before:  5 GB free
After:   30 GB free
Freed:   25 GB
```

### macOS:
```
Before:  8 GB free
After:   28 GB free
Freed:   20 GB
```

### Linux:
```
Before:  5 GB free
After:   35 GB free
Freed:   30 GB
```

---

## 🔗 Links

- **Website:** https://github.com/chibuenyim/UniversalDiskCleanupTool
- **Releases:** https://github.com/chibuenyim/UniversalDiskCleanupTool/releases
- **Issues:** https://github.com/chibuenyim/UniversalDiskCleanupTool/issues

---

## 📦 Automated Multi-OS Releases

This project uses GitHub Actions to automatically build releases for all platforms:

- **Windows** - `.zip` file with GUI launcher
- **macOS** - `.tar.gz` file with Unix launcher
- **Linux** - `.tar.gz` file with Unix launcher

When you push a version tag (like `v5.2.4`) or trigger a release from the Actions tab, the workflow automatically:

1. Builds release artifacts for all platforms
2. Tests PowerShell compatibility
3. Creates a GitHub release with platform-specific downloads
4. Generates detailed release notes

### Creating a New Release

To create a new release:

```bash
# Tag and push (triggers automated release)
git tag v5.2.4
git push origin v5.2.4
```

Or manually trigger from GitHub Actions → Release workflow → Run workflow.

---

---

## 🌟 What's New in v5.3.0

### Accurate Space Measurement
- ✅ **TRUE Disk Space Tracking** - Measures actual disk space before and after cleanup
- ✅ **Filesystem Verification** - Forces SSD/HDD flush to verify space is actually freed
- ✅ **Accuracy Metrics** - Shows tracking accuracy percentage
- ✅ **Platform-Specific Tools** - Uses `fsutil` on Windows, `sync` on Unix/macOS
- ✅ **Verified Results** - Confirms disk counters are updated before showing results
- ✅ **Color-Coded Output** - Visual feedback based on amount freed
- ✅ **GUI Updates** - Enhanced completion dialog with accuracy details

### Technical Improvements
- Double-sync on Unix for maximum safety
- Garbage collection forcing on Windows
- Platform-specific folder size calculation using `du` command
- Environment variable integration for accurate reporting
- Enhanced error handling and recovery

The tool now provides **honest, accurate results** that reflect the true state of your SSD/HDD!

---

## 📄 License

MIT License - Free to use, modify, and distribute

---

## ⭐ Enjoy Your Free Space!

Made with ❤️ for Windows, macOS, and Linux users worldwide

**Version:** 5.3.0 (Stable Production Release)
**Release Date:** April 2026
