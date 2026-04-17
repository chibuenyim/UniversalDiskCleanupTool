# 🧹 Universal Disk Cleanup Tool v4.0

## 🚀 Quick Start (It's Easy!)

### macOS or Linux

**Step 1: Open your terminal**

**Step 2: Run this command:**
```bash
./start.sh
```

That's it! The GUI/menu will open automatically.

---

## 🎯 What You'll See

### On macOS/Linux: Interactive Menu
```
╔══════════════════════════════════════════════════════════╗
║     🧹 Universal Disk Cleanup Tool v4.0                 ║
║     macOS                                               ║
╚══════════════════════════════════════════════════════════╝

Choose an option:
  [1] GUI Mode              ← Recommended!
  [2] Quick Cleanup
  [3] Scheduled Cleanup
  [Q] Quit
```

---

## 📋 What Can You Clean?

| Category | What It Cleans | Space Saved |
|----------|---------------|-------------|
| 🌐 **Browsers** | Chrome, Firefox, Safari, Edge | 300 MB - 2 GB |
| 👨‍💻 **Developer** | npm, yarn, pip, Docker, etc. | 8-25 GB |
| 📦 **Packages** | apt, brew, dnf, pacman, etc. | 1-5 GB |
| 🎮 **Apps** | Spotify, Discord, VSCode, etc. | 1-5 GB |
| 📁 **System** | Logs, caches, thumbnails | 2-8 GB |
| 🗑️ **Temp** | Temporary files | 500 MB - 3 GB |

---

## 🎨 How to Use

### Option 1: Interactive Menu (Easiest)

1. Run `./start.sh`
2. Choose `[1] GUI Mode`
3. Use the arrow keys to select options
4. Press Enter to start cleanup

### Option 2: Quick Cleanup

```bash
# Clean everything (recommended)
./start.sh
# Then choose: [3] Quick Cleanup
```

### Option 3: Command-Line

```bash
# Clean everything
pwsh -File cleanup.ps1 --All

# Clean specific categories
pwsh -File cleanup.ps1 --Browser --Dev --Cache

# Preview without changes
pwsh -File cleanup.ps1 --All --DryRun
```

---

## 🛡️ Is It Safe?

**YES!** The tool only cleans:
- ✅ Temporary files
- ✅ Cache files
- ✅ Package downloads
- ✅ Build artifacts
- ✅ System logs

**NEVER touches:**
- ❌ Your documents
- ❌ Your photos/videos
- ❌ Your desktop
- ❌ Your source code
- ❌ Your settings
- ❌ Browser history/bookmarks

---

## 📊 Expected Results

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

**Typical savings:**
- Basic users: 3-8 GB
- Web browsing: 5-12 GB
- Developers: 15-30 GB
- Power users: 20-40 GB

---

## 🗜️ Bonus: Compression Tools

**Save an additional 2-5 GB!**

```bash
# Launch compression utility
pwsh -File compress.sh
```

**Options:**
- Compress system folders (2-5 GB)
- Compress home folder (1-3 GB)
- Compress specific folders

---

## 🎮 Menu Options

When you run `./start.sh`, you'll see:

- **[1] GUI Mode** - Interactive menu (recommended)
- **[2] Command-Line** - For scripts/automation
- **[3] Quick Cleanup** - Clean everything now
- **[4] Dry Run** - Preview what would be cleaned
- **[5] Schedule** - Set up weekly automatic cleanup
- **[6] Export/Import** - Save your settings
- **[7] Statistics** - See cleanup history
- **[8] Compression** - Additional space savings
- **[9] Help** - More information

---

## ⏰ Schedule Automatic Cleanup

Set up weekly automatic cleanup:

```bash
./start.sh
# Choose: [5] Schedule
```

This will:
- Create a cron job (Linux) or launchd task (macOS)
- Run every Sunday at 2 AM
- Clean automatically in the background

---

## 💡 Tips

1. **First time?** Use Quick Cleanup
2. **Developer?** Include --Dev option
3. **Low disk space?** Use --All for maximum cleanup
4. **Run monthly** for best results
5. **Schedule it** for automatic cleaning

---

## 🛠️ Requirements

### macOS:
- PowerShell 7+ (`brew install powershell`)
- macOS 10.14+

### Linux:
- PowerShell 7+ (see installation below)
- Ubuntu, Fedora, Arch, Debian, etc.

### Installing PowerShell:

**macOS:**
```bash
brew install powershell
```

**Ubuntu/Debian:**
```bash
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell
```

**Fedora:**
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf install -y powershell
```

**Arch:**
```bash
yay -S powershell
```

---

## 📁 Files Explained

| File | What It Does |
|------|--------------|
| **start.sh** | ⭐ **Run this!** Opens the menu |
| gui.ps1 | Interactive GUI/menu |
| gui.sh | GUI launcher script |
| cleanup.ps1 | Main cleanup script |
| compress.sh | Compression utility |
| launcher.sh | Advanced launcher |

---

## 🆘 Troubleshooting

### "Permission denied"
```bash
chmod +x start.sh
```

### "pwsh: command not found"
Install PowerShell 7+ (see requirements above)

### Need to run as root?
```bash
sudo ./start.sh
```

---

## 🌟 Features

✅ **Cross-Platform** - Works on macOS and Linux
✅ **Easy to Use** - Interactive menu
✅ **Safe** - Never deletes your files
✅ **Fast** - Cleans in minutes
✅ **Powerful** - Frees up to 40 GB
✅ **Smart** - Knows what to clean
✅ **Flexible** - Choose what to clean
✅ **Free** - No cost, no ads

---

## 🔗 Links

- **Repository:** https://github.com/chibuenyim/UniversalDiskCleanupTool
- **Issues:** https://github.com/chibuenyim/UniversalDiskCleanupTool/issues
- **Windows Tool:** https://github.com/chibuenyim/DiskCleanupTool

---

## ⭐ Enjoy Your Free Space!

Made with ❤️ for macOS and Linux users
