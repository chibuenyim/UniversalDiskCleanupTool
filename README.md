# 🧹 Universal Disk Cleanup Tool v5.0

**The easiest way to free up disk space on Windows, macOS, and Linux**

![Version](https://img.shields.io/badge/version-5.2.2-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

---

## 🚀 Quick Start

### Windows:
1. Download from: https://github.com/chibuenyim/UniversalDiskCleanupTool/releases
2. Extract ZIP
3. **Double-click `START.bat`**
4. If PowerShell 7+ is missing, we will install it automatically for you!
5. A beautiful GUI will open - choose what to clean and click Start!

### macOS:
```bash
# Install PowerShell
brew install powershell

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

# Download and run
chmod +x start.sh
./start.sh
```

### Linux (Arch):
```bash
# Install from AUR
yay -S powershell

# Download and run
chmod +x start.sh
./start.sh
```

---

## ✨ Features

- **Beautiful GUI** - Windows users get a graphical interface (NEW!)
- **Cross-Platform** - Works on Windows, macOS, and Linux
- **Easy to Use** - Simple launcher for each platform
- **Safe** - Never deletes your documents or personal files
- **Fast** - Cleans in minutes, not hours
- **Powerful** - Frees up to 45 GB of space
- **Smart** - Knows exactly what to clean
- **Auto-Install** - Automatically installs PowerShell 7+ on Windows if missing (NEW!)

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
- **Download:** https://github.com/chibuenyim/UniversalDiskCleanupTool/releases
- **Support:** https://github.com/chibuenyim/UniversalDiskCleanupTool/issues

---

## 🌟 What's New in v5.0

- ✅ **Beautiful GUI** - Windows users now get a graphical interface!
- ✅ **Auto-Install** - Automatically installs PowerShell 7+ on Windows if missing!
- ✅ **Windows Support** - Now works on Windows too!
- ✅ **Cleaner interface** - Simplified for all platforms
- ✅ **Faster cleanup** - Optimized performance
- ✅ **Better progress tracking** - See what's happening
- ✅ **More safety features** - Won't delete your files
- ✅ **Easier than ever** - Just run and go

---

## 📄 License

MIT License - Free to use, modify, and distribute

---

## ⭐ Enjoy Your Free Space!

Made with ❤️ for Windows, macOS, and Linux users worldwide

**Version:** 5.0.0 (Stable Production Release)
**Release Date:** 2025
