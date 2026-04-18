# Universal Disk Cleanup Tool - GUI Guide

## 🖥️ GUI Options by Platform

### Windows
**Status:** ✅ Full GUI Support

**Files:**
- `START.bat` - Launcher with auto-install
- `install-pwsh.ps1` - Automatic PowerShell 7+ installer (GUI)
- `launcher.ps1` - Beautiful Windows Forms GUI

**How to Use:**
1. Double-click `START.bat`
2. If PowerShell 7+ is missing, installer GUI opens automatically
3. Click "Install Automatically" to install via winget
4. Main cleanup GUI opens with options:
   - Quick Cleanup (recommended)
   - Temporary Files
   - Browser Caches
   - Developer Tools
   - System Files
5. Click "Start Cleanup"

**GUI Technology:** Windows Forms (native Windows)

---

### macOS
**Status:** ✅ GUI Support (via Zenity)

**Files:**
- `start-gui.sh` - Zenity-based GUI launcher
- `start.sh` - CLI fallback

**How to Use:**
```bash
# Install dependencies
brew install powershell zenity

# Run GUI
chmod +x start-gui.sh
./start-gui.sh
```

**GUI Features:**
- Zenity dialog with cleanup options
- Progress bar during cleanup
- Completion notification

**GUI Technology:** Zenity (GTK+)

**Note:** Zenity requires XQuartz on macOS
```bash
brew install --cask xquartz
```

---

### Linux
**Status:** ✅ GUI Support (via Zenity)

**Files:**
- `start-gui.sh` - Zenity-based GUI launcher
- `start.sh` - CLI fallback

**How to Use:**

**Ubuntu/Debian:**
```bash
# Install PowerShell 7+
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell zenity

# Run GUI
chmod +x start-gui.sh
./start-gui.sh
```

**Fedora/RHEL:**
```bash
# Install PowerShell 7+
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo rpm -Uvh https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm
sudo dnf install -y powershell zenity

# Run GUI
chmod +x start-gui.sh
./start-gui.sh
```

**Arch Linux:**
```bash
# Install PowerShell 7+
yay -S powershell zenity

# Run GUI
chmod +x start-gui.sh
./start-gui.sh
```

**GUI Features:**
- Native GTK+ dialogs
- Radio button selection
- Progress bar
- Desktop notifications

**GUI Technology:** Zenity (GTK+)

---

## 📊 GUI Comparison Table

| Platform | GUI Technology | Native? | Auto-Install | Status |
|----------|----------------|---------|--------------|--------|
| Windows | Windows Forms | ✅ Yes | ✅ Yes | ✅ Full Support |
| macOS | Zenity | ⚠️ Requires XQuartz | ❌ No | ✅ Supported |
| Linux (GTK+) | Zenity | ✅ Yes | ❌ No | ✅ Full Support |
| Linux (KDE) | Zenity (Qt) | ✅ Yes | ❌ No | ✅ Supported |

---

## 🎨 GUI Screenshots

### Windows GUI
```
┌─────────────────────────────────────────┐
│  🧹 Universal Disk Cleanup Tool v5.3.0 │
├─────────────────────────────────────────┤
│  Free up to 45 GB of disk space safely │
│                                         │
│  ◉ Quick Cleanup                       │
│    Clean everything (recommended)       │
│                                         │
│  ○ Temporary Files                     │
│    System temp files and caches         │
│                                         │
│  ○ Browser Caches                      │
│    Chrome, Firefox, Edge, Safari        │
│                                         │
│  ○ Developer Tools                     │
│    npm, pip, cargo, maven, etc.         │
│                                         │
│  ○ System Files                        │
│    Logs, thumbnails, recycle bin        │
│                                         │
│  [▶ Start Cleanup]  [Cancel]           │
│  ✓ Ready to clean                       │
└─────────────────────────────────────────┘
```

### PowerShell Installer (Windows)
```
┌─────────────────────────────────────────┐
│      PowerShell 7+ Required             │
├─────────────────────────────────────────┤
│  This tool requires PowerShell 7+       │
│  (pwsh) to run.                         │
│                                         │
│  We can install it for you              │
│  automatically, or you can install      │
│  it manually.                           │
│                                         │
│  [🚀 Install Automatically]             │
│  [📥 Download Manually] [Cancel]        │
│                                         │
│  Automatic installation requires        │
│  Windows Package Manager (winget).      │
└─────────────────────────────────────────┘
```

### Linux/macOS GUI (Zenity)
```
┌─────────────────────────────────────────┐
│  Universal Disk Cleanup Tool v5.3.0    │
├─────────────────────────────────────────┤
│  Choose what to clean:                  │
│                                         │
│  ● Quick Cleanup                        │
│    Clean everything (recommended)       │
│                                         │
│  ○ Temporary Files                     │
│    System temp files and caches         │
│                                         │
│  ○ Browser Caches                      │
│    Chrome, Firefox, Edge, Safari        │
│                                         │
│  ○ Developer Tools                     │
│    npm, pip, cargo, maven, etc.         │
│                                         │
│  ○ System Files                        │
│    Logs, thumbnails, recycle bin        │
│                                         │
│           [Start Cleanup] [Cancel]      │
└─────────────────────────────────────────┘
```

---

## 🔧 Troubleshooting

### Windows

**Issue:** START.bat closes immediately
**Solution:** Check that all files are extracted. Run from Command Prompt to see errors.

**Issue:** "PowerShell 7+ not found"
**Solution:** Let the installer run automatically, or install manually from GitHub releases.

**Issue:** GUI doesn't open
**Solution:** Ensure PowerShell 7+ (pwsh) is installed, not just Windows PowerShell.

### macOS

**Issue:** Zenity not found
**Solution:** `brew install zenity` (also install XQuartz if needed)

**Issue:** GUI looks different
**Solution:** Zenity uses XQuartz on macOS, which may look different than native apps.

### Linux

**Issue:** Zenity not found
**Solution:** Install zenity: `sudo apt-get install zenity` (Ubuntu/Debian)

**Issue:** GUI doesn't match desktop theme
**Solution:** Zenity follows GTK+ theme. Install `qt5-style-plugins` for Qt integration.

---

## 📝 Summary

**Windows:** Best GUI experience (native Windows Forms)
**macOS:** Good GUI via Zenity (requires XQuartz)
**Linux:** Great GUI via Zenity (native GTK+)

All platforms have full GUI support! 🎉
